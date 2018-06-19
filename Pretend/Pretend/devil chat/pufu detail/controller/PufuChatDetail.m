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

@end

@implementation PufuChatDetail

static NSString *choice = @"Choice";
static NSString *pufuChat = @"PufuChat";

- (instancetype)init {
    if (self = [super init]) {
        self.chatMgr = [PufuMgr defaultMgr];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([ChatRoomMgr defaultMgr].showTime != PufuShowTime) {
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Pufu";
    [self.chatContentTableView registerClass:[BaseChatTableViewCell class] forCellReuseIdentifier:pufuChat];
}

- (void)setupBackgroundImage {
    self.tableBackgroundView.image = [UIImage imageNamed:@"pufuBG"];
    [self.controlsView.fastPlayBtn setImage:[UIImage imageNamed:@"fast_play_pufu"] forState:UIControlStateNormal];
    [self.controlsView.autoPlayBtn setImage:[UIImage imageNamed:@"auto_play_pufu"] forState:UIControlStateNormal];
    [self.controlsView.nextBtn setImage:[UIImage imageNamed:@"next_pufu"] forState:UIControlStateNormal];
}

- (void)playBGM {
    PRBGMPlayer *bgmPlayer = [PRBGMPlayer defaultPlayer];
    [bgmPlayer playWithFileURL:[[NSBundle mainBundle] URLForResource:@"PufuChat" withExtension:@"mp3"]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pufuChat forIndexPath:indexPath];
    BaseChatModel *model = [self.chatMgr.chatMessageList objectAtIndex:indexPath.row];
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
}

#pragma cards

//添加卡牌
- (void)addCards:(NSUInteger)sequence {
    NSNumber *card = [NSNumber numberWithInteger:sequence];
    [self.chatMgr saveCardInfo:card];
}


@end
