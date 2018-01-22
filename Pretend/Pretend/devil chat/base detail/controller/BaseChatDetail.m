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
        self.choiceCount = 1;
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        [self.layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        self.layout.itemSize = CGSizeMake((SCREEN_WIDTH - 40)/2 , 80);
        self.allCellHeight = [[NSMutableArray alloc] init];
        [self newLoading];
    }
    return self;
}

// 如果重置，直接初始化这个控制器
- (void)reset {
    //虚函数的感觉
}

// 新的加载
- (void)newLoading {
    [self.chatRoomMgr loadPlainFile];
    self.plainMsgs = self.chatRoomMgr.plainMessages;
    self.isChoice = NO;
    self.nextStep = 1;
}

//初始化聊天节点数
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self setupContentViewsType];
    [self setupSubviews];
}

#pragma mark - view

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
    self.chatContentTableView.delegate = self;
    self.chatContentTableView.dataSource = self;
    self.chatContentTableView.backgroundColor = [UIColor clearColor];
    [self.chatContentTableView setAllowsSelection:NO];
    [self.chatContentTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];//设置多余cell的分割线不显示
    [self.view addSubview:self.chatContentTableView];
    [self.chatContentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-140);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        }
        else {
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-140);
        }
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
    self.choicesCollectionView.delegate = self;
    self.choicesCollectionView.dataSource = self;
    self.choicesCollectionView.backgroundColor = [UIColor warmShellColor];
    [self.view addSubview:self.choicesCollectionView];
    [self.choicesCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }
        else {
            make.bottom.left.right.equalTo(self.view);
        }
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

#pragma mark - action

//玩家做出选择的消息
- (void)sendMessage {
    NSString *className = NSStringFromClass([self class]);
    NSString *devil = [className substringToIndex:className.length - 10];
    // 对于普通文本来说，只需要继续下一句话就好
    if (!self.isChoice) {
        // 解析普通文本
        if (self.finished <= self.plainMsgs.count) {
            NSDictionary *dic = [self.plainMsgs objectAtIndex:self.finished - 1];
            NSString *message = [dic objectForKey:@"message"];
            NSUInteger index = [[dic objectForKey:@"index"] unsignedIntegerValue];
            if (index == self.finished) {
                self.plainMsg = [NSString stringWithFormat:@"%@",message];
            }
            self.previousStep = self.finished;
            self.finished ++;
        }
        // 章节开始,只有这个时候才记录剧情的进度,其他恶魔从这里读取数据来查看是不是自己的剧情
        if ([self.plainMsg containsString:@"Chapter Begin"]) {
            NSArray *array = [self.plainMsg componentsSeparatedByString:@" "]; //文本生成的数组
            NSString *showTime = array.firstObject;
            if (![showTime isEqualToString:devil]) {
                self.finished --;
                self.coverLabel.alpha = 1;
                self.choicesCollectionView.userInteractionEnabled = NO;
            }
            if ([showTime isEqualToString:@"Santa"]) {
                self.chatRoomMgr.showTime = SantaShowTime;
            }
            else if ([showTime isEqualToString:@"Pufu"]) {
                self.chatRoomMgr.showTime = PufuShowTime;
            }
            else if ([showTime isEqualToString:@"Tiza"]) {
                self.chatRoomMgr.showTime = TizaShowTime;
            }
            else if ([showTime isEqualToString:@"Chizi"]) {
                self.chatRoomMgr.showTime = ChiziShowTime;
            }
            else {
                NSLog(@"错误的章节");
            }
            [self.chatRoomMgr updateStep:self.finished];
            NSLog(@"现在是 %@的剧情",showTime);
            return;
        }
        // 章节结束
        if ([self.plainMsg containsString:@"Chapter End"]) {
            NSArray *array = [self.plainMsg componentsSeparatedByString:@" "]; //文本生成的数组
            NSString *showTime = array.firstObject;
            NSLog(@"现在 %@剧情结束了",showTime);
            return;
        }
        // 如果文本是开始选择的消息的话，刷新玩家选项
        if ([self.plainMsg containsString:@"Branch Begin"]) {
            self.isChoice = YES;
            // 判断第几个分支
            NSArray *array = [self.plainMsg componentsSeparatedByString:@" "]; //文本生成的数组
            NSString *branchCount = array.firstObject;
            [self.chatRoomMgr loadChatFile:branchCount withDevil:devil];
            self.playerMessages = self.chatRoomMgr.playerMessages;
            self.devilMessages = self.chatRoomMgr.devilMessages;
             // 获取玩家选项数量
            if (self.nextStep <= self.playerMessages.count) {
                NSDictionary *dic = [self.playerMessages objectAtIndex:self.nextStep - 1];
                NSNumber *step = [dic objectForKey:@"step"];
                NSUInteger myStep = [step integerValue];
                if (myStep == self.nextStep) {
                    self.choiceArr = [dic objectForKey:@"choice"];
                    self.choiceCount = self.choiceArr.count;
                }
            }
            [self.choicesCollectionView reloadData];
        }
        // 如果不是开始选择的情况，直接发送这个消息就好
        else {
            self.choicesCollectionView.userInteractionEnabled = NO;
            self.nodeNumber += 1;
            [self.chatContentTableView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self scrollTableToFoot:YES];
                self.choicesCollectionView.userInteractionEnabled = YES;
            });
        }
    }
    // 对于对话文本来说，在玩家选择某一句话之后，对方会有相应的回复
    else {
        self.isDevil = NO;
        self.choicesCollectionView.userInteractionEnabled = NO;
        self.coverLabel.alpha = 1;
        self.nodeNumber += 1;
        [self.chatContentTableView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self scrollTableToFoot:YES];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{//加个延迟有种思考的感觉233
            [self devilRespond];
        });
    }
}

//恶魔的回复,仅在对话的时候使用
- (void)devilRespond {
    self.isDevil = YES;
    self.nodeNumber += 1;
    // 获取恶魔的回复
    if (self.nextStep <= self.devilMessages.count) {
        NSDictionary *dic = [self.devilMessages objectAtIndex:self.nextStep - 1];
        NSNumber *step = [dic objectForKey:@"step"];
        NSUInteger mystep = [step integerValue];
        if (mystep == self.nextStep) {
            self.devilArr = [dic objectForKey:@"choice"];
            self.devilDic = [self.devilArr objectAtIndex:self.choiceIndex];
            self.devilRespondContent = [self.devilDic objectForKey:@"message"];
        }
        self.nextStep ++;
    }
    [self.chatContentTableView reloadData];
    // 因为如果改变isChoice会影响到table加载数据，所以在加载完数据之后再改变玩家选项 给0.5s的时间应该ok。。
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        // 如果选项分支结束了，进入普通文本模式
        if (self.nextStep > self.devilMessages.count) {
            self.isChoice = NO;
            self.nextStep = 1;
        }
        // 如果有后续，获取下一步的选项
        else {
            NSDictionary *dic = [self.playerMessages objectAtIndex:self.nextStep - 1];
            NSNumber *step = [dic objectForKey:@"step"];
            NSUInteger myStep = [step integerValue];
            if (myStep == self.nextStep) {
                self.choiceArr = [dic objectForKey:@"choice"];
                self.choiceCount = self.choiceArr.count;
            }
        }
        [self.choicesCollectionView reloadData];
        [self scrollTableToFoot:YES];
        self.coverLabel.alpha = 0;
        self.choicesCollectionView.userInteractionEnabled = YES;
    });
}

#pragma dataSource

//聊天记录每一个作为一个新的section，而玩家选项一个section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.nodeNumber;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//聊天记录每一个section仅包括一行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!self.isChoice) {
        return 1;
    }
    // 如果是对话，返回玩家可选选项的个数
    else {
        return self.choiceCount;
    }
}

//这里做了点特别的处理，对于聊天记录的视图，每个cell有不同的标志符，对于每个玩家选择，设置为一个标志符（后面实现的时候相当于没有复用了）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *baseChat = [NSString stringWithFormat:@"BaseChat%ld",(long)indexPath.section];
    BaseChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:baseChat];
    // 如果普通文本的话，读取之后设置为玩家的话的形式显示
    if (!self.isChoice) {
        if(cell == nil){
            cell = [[BaseChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:baseChat isDevil:NO message:self.plainMsg respond:nil devilName:nil];
        }
    }
    // 对话文本的话，根据是玩家还是恶魔显示不同的效果
    else {
        if(cell == nil){
            cell = [[BaseChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:baseChat isDevil:self.isDevil message:self.playerChoice respond:self.devilRespondContent devilName:@"santa"];
        }
    }
    return cell;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BaseChoiceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:choice forIndexPath:indexPath];
    // 如果是普通的文本，点击即可进入下一句
    if (!self.isChoice) {
        cell.messageLabel.text = @"NEXT";
    }
    // 如果是对话文本，因为在获取选项个数的时候就获得了所有的选项，所以直接读取当前的step的玩家的全部可选项，展示
    else {
        self.choiceDic = [self.choiceArr objectAtIndex:indexPath.row];
        cell.messageLabel.text = [self.choiceDic objectForKey:@"message"];
    }
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
    // 如果是对话，则需要判断玩家的选择做出响应
    if (self.isChoice) {
        self.playerChoice = [[self.choiceArr objectAtIndex:indexPath.row] objectForKey:@"message"];
        self.choiceIndex = indexPath.row;
    }
    [self sendMessage];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

//设置cell高度，根据文本行数和大小变化
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect cellRect = CGRectMake(0, 0, 0, 0);
    NSString *message = @"";
    // 只有当是最新的cell时才会计算
    if (indexPath.section == [tableView numberOfSections] - 1 ) {
        // 普通文本
        if (!self.isChoice) {
            message = self.plainMsg;
        }
        else {
            // 恶魔
            if (self.isDevil == YES) {
                message = self.devilRespondContent;
            }
            // 玩家
            else {
                message = self.playerChoice;
            }
        }
        cellRect = [message boundingRectWithSize:CGSizeMake(self.view.bounds.size.width * 0.7, MAXFLOAT) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
        NSNumber *height = [NSNumber numberWithFloat:cellRect.size.height + kCellGap];
        if ([self.allCellHeight count] < self.nodeNumber) {//将正确的高度存入数组
            [self.allCellHeight addObject:height];
        }
    }
    CGFloat cellHeight = [[self.allCellHeight objectAtIndex:indexPath.section] floatValue];//每次重新加载时，除了最后的cell，高度直接从数组里获取
    return cellHeight;
}

@end

NS_ASSUME_NONNULL_END
