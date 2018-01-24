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

@end

@implementation TizaChatDetail

static NSString *choice = @"Choice";
static NSString *tizaChat = @"TizaChat";

- (instancetype)init {
    if (self = [super init]) {
        self.chatMgr = [TizaMgr defaultMgr];
    }
    return self;
}

// 每次进入视图的时候刷新当前的剧情进度
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([ChatRoomMgr defaultMgr].showTime != TizaShowTime) {
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
    self.chatMgr.finishText = self.chatMgr.chatMessageList.lastObject.message;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tizaChat forIndexPath:indexPath];
    BaseChatModel *model = [self.chatMgr.chatMessageList objectAtIndex:indexPath.row];
    model.devil = @"tiza";
    [cell updateWithModel:model];
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
}

#pragma cards
//添加卡牌
- (void)addCards:(NSUInteger)sequence {
    NSNumber *card = [NSNumber numberWithInteger:sequence];
    [self.chatMgr saveCardInfo:card];
}

@end
