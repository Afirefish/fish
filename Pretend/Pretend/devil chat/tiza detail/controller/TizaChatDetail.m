//
//  TizaChatDetail.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/30.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "TizaChatDetail.h"
#import "TizaMgr.h"

#define kCellGap 20

//排名最后的恶魔，因为实力不济经常被其他低阶恶魔挑战，同时也担任着管理魔界秩序的一些杂务
@interface TizaChatDetail ()
@property (strong,nonatomic) TizaMgr *tizaMgr;

@end

@implementation TizaChatDetail

static NSString *choice = @"Choice";
static NSString *tizaChat = @"TizaChat";
static TizaChatDetail *tizaChatDetail = nil;

+ (instancetype)tizaChatDetail {
    if (tizaChatDetail  == nil) {
        tizaChatDetail = [[TizaChatDetail alloc] init];
    }
    return tizaChatDetail;
}

- (instancetype)init {
    if (self = [super init]) {
        self.tizaMgr = [TizaMgr defaultMgr];
        self.previousStep = self.tizaMgr.previousStep;
        self.finished = self.tizaMgr.finished;
    }
    return self;
}

- (void)reset {
    tizaChatDetail = [[TizaChatDetail alloc] init];
}

// 每次进入视图的时候刷新当前的剧情进度
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.previousStep = self.tizaMgr.previousStep;
    self.finished = self.tizaMgr.finished;
    if (self.chatRoomMgr.showTime != TizaShowTime) {
        self.coverLabel.alpha = 1;
        self.choicesCollectionView.userInteractionEnabled = NO;
    }
    else {
        self.coverLabel.alpha = 0;
        self.choicesCollectionView.userInteractionEnabled = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tizaMgr.finishText = self.chatMessageList.lastObject.message;
}

//解析json，初始化高度
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Tiza";
    [self.chatContentTableView registerClass:[BaseChatTableViewCell class] forCellReuseIdentifier:tizaChat];
}

- (void)setupBackgroundImage {
    self.tableBackgroundView.image = [UIImage imageNamed:@"tizaBG"];
}

////tiza恶魔通过
//- (void)setfinished:(NSUInteger)finished {
//    self.finished = 100;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tizaChat forIndexPath:indexPath];
    BaseChatModel *model = [self.chatMessageList objectAtIndex:indexPath.row];
    model.devil = @"tiza";
    [cell updateWithModel:model];
    self.tizaMgr.finishText = model.message;
    return cell;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BaseChoiceCollectionViewCell *cell = [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroudImageView.image = [UIImage imageNamed:@"tizaCastle"];
    return cell;
}

//玩家做出选择之后的处理
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    self.tizaMgr.previousStep = self.previousStep;
    self.tizaMgr.finished = self.finished;
}

#pragma cards
//添加卡牌
- (void)addCards:(NSUInteger)sequence {
    NSNumber *card = [NSNumber numberWithInteger:sequence];
    [self.tizaMgr saveCardInfo:card];
}

@end
