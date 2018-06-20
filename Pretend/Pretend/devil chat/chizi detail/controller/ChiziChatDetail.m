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

@end

@implementation ChiziChatDetail

static NSString *choice = @"Choice";
static NSString *chiziChat = @"ChiziChat";

- (instancetype)init {
    if (self = [super init]) {
        self.chatMgr = [ChiziMgr defaultMgr];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([ChatRoomMgr defaultMgr].showTime != ChiziShowTime) {
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
    self.navigationItem.title = @"Chizi";
    [self.chatContentTableView registerClass:[BaseChatTableViewCell class] forCellReuseIdentifier:chiziChat];
}

- (void)setupBackgroundImage {
    self.tableBackgroundView.image = [UIImage imageNamed:@"chiziBG"];
    [self.controlsView.fastPlayBtn setImage:[UIImage imageNamed:@"fast_play_chizi"] forState:UIControlStateNormal];
    [self.controlsView.autoPlayBtn setImage:[UIImage imageNamed:@"auto_play_chizi"] forState:UIControlStateNormal];
    [self.controlsView.nextBtn setImage:[UIImage imageNamed:@"next_chizi"] forState:UIControlStateNormal];
}

- (void)playBGM {
    PRBGMPlayer *bgmPlayer = [PRBGMPlayer defaultPlayer];
    [bgmPlayer playWithFileURL:[[NSBundle mainBundle] URLForResource:@"ChiziChat" withExtension:@"mp3"]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chiziChat forIndexPath:indexPath];
    BaseChatModel *model = [self.chatMgr.chatMessageList objectAtIndex:indexPath.row];
    model.devil = @"chizi";
    [cell updateWithModel:model];
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
}

#pragma cards
//添加卡牌
- (void)addCards:(NSUInteger)sequence {
    NSNumber *card = [NSNumber numberWithInteger:sequence];
    [self.chatMgr saveCardInfo:card];
}

@end
