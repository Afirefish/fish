//
//  SantaChatDetail.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/29.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "SantaChatDetail.h"
#import "SantaMgr.h"

#define kCellGap 20

//说话语气很凶，但是实际是个很好的家伙，没有固定的居住地，偶尔会去chizi的宫殿呆着
@interface SantaChatDetail ()

@end

@implementation SantaChatDetail

static NSString *choice = @"Choice";
static NSString *santaChat = @"SantaChat";

// 每次加载从上一步加载，如果上一步是没完成的选择的话，那么允许重新选择
- (instancetype)init {
    if (self = [super init]) {
        self.chatMgr = [SantaMgr defaultMgr];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([ChatRoomMgr defaultMgr].showTime != SantaShowTime) {
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
    self.navigationItem.title = @"Santa";
    [self.chatContentTableView registerClass:[BaseChatTableViewCell class] forCellReuseIdentifier:santaChat];
}

- (void)setupBackgroundImage {
    self.tableBackgroundView.image = [UIImage imageNamed:@"santaBG"];
}

- (void)playBGM {
    PRBGMPlayer *bgmPlayer = [PRBGMPlayer defaultPlayer];
    [bgmPlayer playWithFileURL:[[NSBundle mainBundle] URLForResource:@"SantaChat" withExtension:@"mp3"]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:santaChat forIndexPath:indexPath];
    BaseChatModel *model = [self.chatMgr.chatMessageList objectAtIndex:indexPath.row];
    model.devil = @"santa";
    [cell updateWithModel:model];
    return cell;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BaseChoiceCollectionViewCell *cell = [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroudImageView.image = [UIImage imageNamed:@"santaDesert"];
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
