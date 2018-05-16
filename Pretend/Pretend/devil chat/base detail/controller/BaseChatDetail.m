//
//  BaseChatDetail.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/29.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "BaseChatDetail.h"

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
static NSString *baseChat = @"BaseChat";

- (instancetype)init {
    if (self = [super init]) {
        self.chatMgr = [[BaseMgr alloc] init];
    }
    return self;
}

//初始化聊天节点数
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self setupSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self scrollTableToFoot:NO];
    [self playBGM];
}

#pragma mark - view

- (void)setupSubviews {
    [self setupContentViews];
    [self setupCoverLabel];
}

//设置表视图和集合视图
- (void)setupContentViews {
    //聊天内容
    self.chatContentTableView = [[UITableView alloc] init];
    self.chatContentTableView.delegate = self;
    self.chatContentTableView.dataSource = self;
    self.chatContentTableView.backgroundColor = [UIColor clearColor];
    [self.chatContentTableView setAllowsSelection:NO];
    [self.chatContentTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];//设置多余cell的分割线不显示
    [self.chatContentTableView registerClass:[BaseChatTableViewCell class] forCellReuseIdentifier:baseChat];
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
    // 设置显示文字时候的蒙版视图，便于用户看得清文字。。。
    self.overlayView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        view;
    });
    [self.view addSubview:self.overlayView];
    [self.view insertSubview:self.overlayView aboveSubview:self.tableBackgroundView];
    [self.overlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tableBackgroundView);
    }];
    
    //collection view显示的视图
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    [self.layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.layout.itemSize = CGSizeMake((SCREEN_WIDTH - 40)/2 , 80);
    self.choicesCollectionView =  [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    self.choicesCollectionView.delegate = self;
    self.choicesCollectionView.dataSource = self;
    self.choicesCollectionView.backgroundColor = [UIColor warmShellColor];
    [self.choicesCollectionView registerClass:[BaseChoiceCollectionViewCell class] forCellWithReuseIdentifier:choice];
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

- (void)playBGM {
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
    switch ([self.chatMgr loadNewMessage]) {
        case PlainChat: {
            self.choicesCollectionView.userInteractionEnabled = NO;
            BaseChatModel *model =[[BaseChatModel alloc] initWithMsg:self.chatMgr.plainMsg isDevil:self.chatMgr.isDevil isChoice:self.chatMgr.isChoice];
            [self.chatMgr.chatMessageList addObject:model];
            [self.chatContentTableView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self scrollTableToFoot:YES];
                self.choicesCollectionView.userInteractionEnabled = YES;
            });
            break;
        }
        case ChatBegin: {
            NSLog(@"游戏开始了");
            break;
        }
        
        case ChatComplete: {
            self.coverLabel.alpha = 1;
            self.choicesCollectionView.userInteractionEnabled = NO;
            NSLog(@"游戏通关了");
            break;
        }
            
        case ChapterBegin: {
            break;
        }
        
        case OtherChapterBegin: {
            self.coverLabel.alpha = 1;
            self.choicesCollectionView.userInteractionEnabled = NO;
            break;
        }
            
        case ChapterComplete: {
            break;
        }
            
        case BranchBegin: {
            [self.choicesCollectionView reloadData];
            break;
        }
            
        case PlayerTime: {
            self.choicesCollectionView.userInteractionEnabled = NO;
            self.coverLabel.alpha = 1;
            BaseChatModel *model =[[BaseChatModel alloc] initWithMsg:self.chatMgr.playerChoice isDevil:self.chatMgr.isDevil isChoice:self.chatMgr.isChoice];
            [self.chatMgr.chatMessageList addObject:model];
            [self.chatContentTableView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self scrollTableToFoot:YES];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{//加个延迟有种思考的感觉233
                [self devilRespond];
            });
            break;
        }
            
        default:
            break;
    }
}

//恶魔的回复,仅在对话的时候使用
- (void)devilRespond {
    [self.chatMgr devilRespond];
    BaseChatModel *model =[[BaseChatModel alloc] initWithMsg:self.chatMgr.devilRespondContent isDevil:self.chatMgr.isDevil isChoice:self.chatMgr.isChoice];
    [self.chatMgr.chatMessageList addObject:model];
    [self.chatContentTableView reloadData];
    // 因为如果改变isChoice会影响到table加载数据，所以在加载完数据之后再改变玩家选项 给0.5s的时间应该ok。。
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        switch ([self.chatMgr loadNextChoice]) {
            case BranchComplete:
                break;
                
            case PlayerTime:
                break;
    
            default:
                break;
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
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//聊天记录每一个section仅包括一行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatMgr.chatMessageList.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!self.chatMgr.isChoice) {
        return 1;
    }
    // 如果是对话，返回玩家可选选项的个数
    else {
        return self.chatMgr.choiceCount;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseChatModel *model = [self.chatMgr.chatMessageList objectAtIndex:indexPath.row];
    BaseChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:baseChat forIndexPath:indexPath];
    [cell updateWithModel:model];
    return cell;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BaseChoiceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:choice forIndexPath:indexPath];
    // 如果是普通的文本，点击即可进入下一句
    if (!self.chatMgr.isChoice) {
        cell.messageLabel.text = @"NEXT";
    }
    // 如果是对话文本，因为在获取选项个数的时候就获得了所有的选项，所以直接读取当前的step的玩家的全部可选项，展示
    else {
        self.chatMgr.choiceDic = [self.chatMgr.choiceArr objectAtIndex:indexPath.row];
        cell.messageLabel.text = [self.chatMgr.choiceDic objectForKey:@"message"];
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
    if (self.chatMgr.isChoice) {
        self.chatMgr.playerChoice = [[self.chatMgr.choiceArr objectAtIndex:indexPath.row] objectForKey:@"message"];
        self.chatMgr.choiceIndex = indexPath.row;
    }
    [self sendMessage];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

//设置cell高度，根据文本行数和大小变化
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect cellRect = CGRectMake(0, 0, 0, 0);
    NSString *message = @"";
    // 只有当是最新的cell时才会计算
    if (indexPath.row == [tableView numberOfRowsInSection:0] - 1 ) {
        // 普通文本
        if (!self.chatMgr.isChoice) {
            message = self.chatMgr.plainMsg;
        }
        else {
            // 恶魔
            if (self.chatMgr.isDevil == YES) {
                message = self.chatMgr.devilRespondContent;
            }
            // 玩家
            else {
                message = self.chatMgr.playerChoice;
            }
        }
        cellRect = [message boundingRectWithSize:CGSizeMake(self.view.bounds.size.width * 0.7, MAXFLOAT) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
        NSNumber *height = [NSNumber numberWithFloat:(cellRect.size.height + kCellGap)];
        if ([self.chatMgr.allCellHeight count] < self.chatMgr.chatMessageList.count) {//将正确的高度存入数组
            [self.chatMgr.allCellHeight addObject:height];
        }
    }
    CGFloat cellHeight = [[self.chatMgr.allCellHeight objectAtIndex:indexPath.row] floatValue];//每次重新加载时，除了最后的cell，高度直接从数组里获取
    return cellHeight;
}

@end

NS_ASSUME_NONNULL_END
