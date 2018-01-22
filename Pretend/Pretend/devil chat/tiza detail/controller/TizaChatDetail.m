//
//  TizaChatDetail.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/30.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "TizaChatDetail.h"
#import "ChatRoomMgr.h"
#import "TizaMgr.h"
#import "TizaChatTableView.h"
#import "TizaChatTableViewCell.h"
#import "TizaChoiceCollectionView.h"
#import "TizaChoiceCollectionViewCell.h"

#define kCellGap 20

//排名最后的恶魔，因为实力不济经常被其他低阶恶魔挑战，同时也担任着管理魔界秩序的一些杂务
@interface TizaChatDetail ()
@property (strong,nonatomic) TizaMgr *tizaMgr;

@end

@implementation TizaChatDetail

static NSString *choice = @"Choice";
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

//解析json，初始化高度
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Tiza";
}

//重写子视图设置的方法
- (void)setupContentViewsType {
    self.chatContentTableView = [[TizaChatTableView alloc] initWithFrame:CGRectZero];
    self.choicesCollectionView = [[TizaChoiceCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    [self.choicesCollectionView registerClass:[TizaChoiceCollectionViewCell class] forCellWithReuseIdentifier:choice];
}

- (void)setupBackgroundImage {
    self.tableBackgroundView.image = [UIImage imageNamed:@"tizaBG"];
}

////tiza恶魔通过
//- (void)setfinished:(NSUInteger)finished {
//    self.finished = 100;
//}

//聊天记录的视图在获得高度的时候就有数据源了，不过在处理玩家的选择的视图的时候，还是要重新设置数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tizaChat = [NSString stringWithFormat:@"TizaChat%ld",(long)indexPath.section];
    TizaChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tizaChat];
    // 如果普通文本的话，读取之后设置为玩家的话的形式显示
    if (!self.isChoice) {
        if(cell == nil){
            cell = [[TizaChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tizaChat isDevil:NO message:self.plainMsg respond:nil devilName:nil];
        }
        if (![self.plainMsg containsString:@"Begin"]) {
            self.tizaMgr.finishText = self.plainMsg;
        }
    }
    // 对话文本的话，根据是玩家还是恶魔显示不同的效果
    else {
        if(cell == nil){
            cell = [[TizaChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tizaChat isDevil:self.isDevil message:self.playerChoice respond:self.devilRespondContent devilName:@"tiza"];
        }
        self.tizaMgr.finishText = self.devilRespondContent;
    }
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
