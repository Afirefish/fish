//
//  ChiziChatDetail.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/30.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "ChiziChatDetail.h"
#import "ChiziMgr.h"

#define kCellGap 20

//设定为比较残忍的人，和santa很合得来，拥有最强大的近战攻击力
@interface ChiziChatDetail ()
@property (strong,nonatomic) ChiziMgr *chiziMgr;

@end

@implementation ChiziChatDetail

static NSString *choice = @"Choice";
static NSString *chiziChat = @"ChiziChat";
static ChiziChatDetail *chiziChatDetail = nil;

+ (instancetype)chiziChatDetail {
    if (chiziChatDetail  == nil) {
        chiziChatDetail = [[ChiziChatDetail alloc] init];
    }
    return chiziChatDetail;
}

- (instancetype)init {
    if (self = [super init]) {
        self.chiziMgr = [ChiziMgr defaultMgr];
        self.previousStep = self.chiziMgr.previousStep;
        self.finished = self.chiziMgr.finished;
    }
    return self;
}

- (void)reset {
    chiziChatDetail = [[ChiziChatDetail alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.previousStep = self.chiziMgr.previousStep;
    self.finished = self.chiziMgr.finished;
    if (self.chatRoomMgr.showTime != ChiziShowTime) {
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
    self.chiziMgr.finishText = self.chatMessageList.lastObject.message;
}

//解析json，初始化高度
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Chizi";
    [self.chatContentTableView registerClass:[BaseChatTableViewCell class] forCellReuseIdentifier:chiziChat];
}

- (void)setupBackgroundImage {
    self.tableBackgroundView.image = [UIImage imageNamed:@"chiziBG"];
}

////pufu恶魔通过
//- (void)setfinished:(NSUInteger)finished {
//    self.finished = 100;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chiziChat forIndexPath:indexPath];
    BaseChatModel *model = [self.chatMessageList objectAtIndex:indexPath.row];
    model.devil = @"chizi";
    [cell updateWithModel:model];
    self.chiziMgr.finishText = model.message;
    return cell;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BaseChoiceCollectionViewCell *cell = [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroudImageView.image = [UIImage imageNamed:@"chiziCastle"];
    return cell;
}

//玩家做出选择之后的处理
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    self.chiziMgr.previousStep = self.previousStep;
    self.chiziMgr.finished = self.finished;
}

#pragma cards
//添加卡牌
- (void)addCards:(NSUInteger)sequence {
    NSNumber *card = [NSNumber numberWithInteger:sequence];
    [self.chiziMgr saveCardInfo:card];
}

@end
