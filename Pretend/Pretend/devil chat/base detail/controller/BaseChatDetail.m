//
//  BaseChatDetail.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/29.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "BaseChatDetail.h"
#import "ChatRoomMgr.h"
#import "BaseChatTableView.h"
#import "BaseChatTableViewCell.h"
#import "BaseChoiceCollectionView.h"
#import "BaseChoiceCollectionViewCell.h"
#import "UIColor+PRCustomColor.h"

#import <Masonry.h>


#define SCREEN_SIZE ([UIScreen mainScreen].bounds.size)
#define SCREEN_WIDTH (SCREEN_SIZE.width < SCREEN_SIZE.height ? SCREEN_SIZE.width : SCREEN_SIZE.height)
#define SCREEN_HEIGHT (SCREEN_SIZE.width > SCREEN_SIZE.height ? SCREEN_SIZE.width : SCREEN_SIZE.height)
#define kCellGap 20

NS_ASSUME_NONNULL_BEGIN

@interface BaseChatDetail ()

@end

@implementation BaseChatDetail

static NSString *choice = @"Choice";

- (instancetype)init {
    if (self = [super init]) {
        self.chatRoomMgr = [ChatRoomMgr defaultMgr];
        self.nodeNumber = 0;
        self.isDevil = NO;
        self.choiceCount = 4;
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        [self.layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        self.layout.itemSize = CGSizeMake((SCREEN_WIDTH - 40)/2 , 80);
        self.choiceContent = [[NSMutableArray alloc] init];
    }
    return self;
}

// 如果重置，直接初始化这个控制器
- (void)reset {
    //虚函数的感觉
}

//初始化聊天节点数，
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self setupContentViewsType];
    [self setupSubviews];
    [self refreshPlayerMessages];
}

//设置表视图和集合视图类型
- (void)setupContentViewsType {
    self.chatContentTableView = [[BaseChatTableView alloc] init];
    self.choicesCollectionView =  [[BaseChoiceCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    [self.choicesCollectionView registerClass:[BaseChoiceCollectionViewCell class]
                   forCellWithReuseIdentifier:choice];
}

- (void)setupSubviews {
    [self setupContentViews];
    [self setupCoverLabel];
}

//设置表视图和集合视图
- (void)setupContentViews {
    //聊天内容
    //    self.chatContent = [[BaseChatTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.7) style:UITableViewStylePlain];
    self.chatContentTableView.delegate = self;
    self.chatContentTableView.dataSource = self;
    self.chatContentTableView.rowHeight = UITableViewAutomaticDimension;
    self.chatContentTableView.estimatedRowHeight = 40;
    self.chatContentTableView.backgroundColor = [UIColor clearColor];
    [self.chatContentTableView setAllowsSelection:NO];
    [self.chatContentTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];//设置多余cell的分割线不显示
    [self.view addSubview:self.chatContentTableView];
    [self.chatContentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-140);
    }];
    //设置tableview背景视图
    self.tableBackgroundView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView;
    });
    [self.view addSubview:self.tableBackgroundView];
    [self.view sendSubviewToBack:self.tableBackgroundView];
    [self.tableBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.chatContentTableView);
    }];
    
    //collection view显示的视图
    //    self.choicesCollectionView = [[BaseChoiceCollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.7, SCREEN_WIDTH, SCREEN_HEIGHT * 0.3) collectionViewLayout:self.layout];
    self.choicesCollectionView.delegate = self;
    self.choicesCollectionView.dataSource = self;
    self.choicesCollectionView.backgroundColor = [UIColor warmShellColor];
    [self.view addSubview:self.choicesCollectionView];
    [self.choicesCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.chatContentTableView.mas_bottom);
    }];
    //设置collectionview背景视图
    self.collectionBackgroudView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView;
    });
    [self.view addSubview:self.collectionBackgroudView];
    [self.view sendSubviewToBack:self.collectionBackgroudView];
    [self.collectionBackgroudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.choicesCollectionView);
    }];
    [self setupBackgroundImage];
}

- (void)setupBackgroundImage {
}

//玩家不能选择时的视图
- (void)setupCoverLabel {
    self.coverLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor warmShellColor];
        label.text = @"...";
        label.font = [UIFont systemFontOfSize:60];
        label.textAlignment = NSTextAlignmentCenter;
        label.alpha = 0;
        label;
    });
    //    self.coverLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.7, SCREEN_WIDTH, SCREEN_HEIGHT * 0.3)];
    [self.view addSubview:self.coverLabel];
    [self.coverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.choicesCollectionView);
    }];
}

//滚动到底部
- (void)scrollTableToFoot:(BOOL)animated {
    NSInteger section = [self.chatContentTableView numberOfSections];
    if (section<1) return;  //无数据时不执行 要不会crash
    NSInteger row = [self.chatContentTableView numberOfRowsInSection:section-1];
    if (row<1) return;
    NSIndexPath *index = [NSIndexPath indexPathForRow:row-1 inSection:section-1];  //取最后一行数据
    [self.chatContentTableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:animated]; //滚动到最后一行
}

- (void)refreshDevilRespond {
    for (NSDictionary *dic in self.devilMessages) {//刷新恶魔的回复
        NSNumber *step = [dic objectForKey:@"step"];
        NSUInteger mystep = [step integerValue];
        if (mystep == self.previousStep) {
            self.devilArr = [dic objectForKey:@"respond"];
            self.devilDic = [self.devilArr objectAtIndex:self.choiceIndex];
            self.devilRespondContent = [self.devilDic objectForKey:@"message"];
            break;
        }
    }
}

- (void)refreshPlayerMessages {
    for (NSDictionary *dic in self.playerMessages) {//刷新玩家的选项
        NSNumber *step = [dic objectForKey:@"step"];
        NSUInteger myStep = [step integerValue];
        if (myStep == self.finished) {
            [self.choiceContent removeAllObjects];
            self.choiceArr = [dic objectForKey:@"choice"];
            self.choiceCount = [self.choiceArr count];
            for (NSUInteger i = 0; i < self.choiceCount; i ++) {
                self.choiceDic = [self.choiceArr objectAtIndex:i];
                [self.choiceContent addObject:[self.choiceDic objectForKey:@"message"]];
            }
            break;
        }
    }
}

//玩家做出选择的消息
- (void)sendMessage{
    self.isDevil = NO;
    self.choicesCollectionView.userInteractionEnabled = NO;
    self.coverLabel.alpha = 1;
    self.nodeNumber += 1;
    [self.chatContentTableView reloadData];
    [self scrollTableToFoot:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{//与下面的延时异步运行，加载数据
        [self refreshDevilRespond];
        [self refreshPlayerMessages];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.choicesCollectionView reloadData];
        });
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{//加个延迟有种思考的感觉233
        [self devilRespond];
    });
}

//恶魔的回复
- (void)devilRespond {
    self.isDevil = YES;
    self.nodeNumber += 1;
    [self.chatContentTableView reloadData];
    [self scrollTableToFoot:YES];
    self.coverLabel.alpha = 0;
    self.choicesCollectionView.userInteractionEnabled = YES;
}

#pragma dataSource

//聊天记录每一个作为一个新的section，而玩家选项一个section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.nodeNumber;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//聊天记录每一个section仅包括一行，玩家选项定为4个
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.choiceCount;
}

//这里做了点特别的处理，对于聊天记录的视图，每个cell有不同的标志符，对于每个玩家选择，设置为一个标志符（后面实现的时候相当于没有复用了）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.chatContentTableView) {
        NSString *baseChat = [NSString stringWithFormat:@"BaseChat%ld",(long)indexPath.section];
        BaseChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:baseChat];
        if(cell == nil){
            cell = [[BaseChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:baseChat isDevil:self.isDevil message:self.playerChoice respond:self.devilRespondContent devilName:nil];
        }
        return cell;
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BaseChoiceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:choice forIndexPath:indexPath];
    cell.messageLabel.text = [self.choiceContent objectAtIndex:indexPath.row];
    return cell;
}

#pragma delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 2;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//玩家做出选择之后的处理
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.playerChoice = [[self.choiceArr objectAtIndex:indexPath.row] objectForKey:@"message"];
    NSNumber *index = [[self.choiceArr objectAtIndex:indexPath.row] objectForKey:@"index"];
    self.choiceIndex = [index integerValue];
    NSNumber *nextStep = [[self.choiceArr objectAtIndex:indexPath.row] objectForKey:@"nextStep"];
    self.previousStep = self.finished;
    self.finished = [nextStep integerValue];
    [self sendMessage];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma json

//解析本地的json
- (void)jsonData:(NSString *)devil {
    [self.chatRoomMgr messageJson:devil];
    self.playerMessages = self.chatRoomMgr.playerMessages;
    self.devilMessages = self.chatRoomMgr.devilMessages;
}

@end

NS_ASSUME_NONNULL_END
