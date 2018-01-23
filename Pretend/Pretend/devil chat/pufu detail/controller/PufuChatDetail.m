//
//  PufuChatDetail.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/30.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "PufuChatDetail.h"
#import "PufuMgr.h"

#define kCellGap 20

//似乎是比较温和的女性恶魔，拥有时光之力？？强大的实力毋庸置疑
@interface PufuChatDetail ()

@property (strong,nonatomic) PufuMgr *pufuMgr;

@end

@implementation PufuChatDetail

static NSString *choice = @"Choice";
static NSString *pufuChat = @"PufuChat";
static PufuChatDetail *pufuChatDetail = nil;

+ (instancetype)pufuChatDetail {
    if (pufuChatDetail == nil) {
        pufuChatDetail = [[PufuChatDetail alloc] init];
    }
    return pufuChatDetail;
}

- (instancetype)init {
    if (self = [super init]) {
        self.pufuMgr = [PufuMgr defaultMgr];
        self.previousStep = self.pufuMgr.previousStep;
        self.finished = self.pufuMgr.finished;
    }
    return self;
}

- (void)reset {
    pufuChatDetail = [[PufuChatDetail alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.previousStep = self.pufuMgr.previousStep;
    self.finished = self.pufuMgr.finished;
    if (self.chatRoomMgr.showTime != PufuShowTime) {
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
    self.pufuMgr.finishText = self.chatMessageList.lastObject.message;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Pufu";
    [self.chatContentTableView registerClass:[BaseChatTableViewCell class] forCellReuseIdentifier:pufuChat];
}

- (void)setupBackgroundImage {
    self.tableBackgroundView.image = [UIImage imageNamed:@"pufuBG"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pufuChat forIndexPath:indexPath];
    BaseChatModel *model = [self.chatMessageList objectAtIndex:indexPath.row];
    model.devil = @"pufu";
    [cell updateWithModel:model];
    return cell;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BaseChoiceCollectionViewCell *cell = [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroudImageView.image = [UIImage imageNamed:@"pufuCastle"];
    return cell;
}

//玩家做出选择之后的处理
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    self.pufuMgr.previousStep = self.previousStep;
    self.pufuMgr.finished = self.finished;
}

#pragma cards

//添加卡牌
- (void)addCards:(NSUInteger)sequence {
    NSNumber *card = [NSNumber numberWithInteger:sequence];
    [self.pufuMgr saveCardInfo:card];
}


@end
