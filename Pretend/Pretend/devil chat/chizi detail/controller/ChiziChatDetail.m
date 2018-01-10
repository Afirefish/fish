//
//  ChiziChatDetail.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/30.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "ChiziChatDetail.h"
#import "ChatRoomMgr.h"
#import "ChiziMgr.h"
#import "ChiziChatTableView.h"
#import "ChiziChatTableViewCell.h"
#import "ChiziChoiceCollectionView.h"
#import "ChiziChoiceCollectionViewCell.h"

#define kCellGap 20

//设定为比较残忍的人，和santa很合得来，拥有最强大的近战攻击力
@interface ChiziChatDetail ()
@property (strong,nonatomic) ChiziMgr *chiziMgr;

@end

@implementation ChiziChatDetail

static NSString *choice = @"Choice";
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
        [self jsonData:@"chizi"];
    }
    return self;
}

- (void)reset {
    chiziChatDetail = [[ChiziChatDetail alloc] init];
}

//解析json，初始化高度
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Chizi";
}

//重写子视图设置的方法
- (void)setupContentViewsType {
    self.chatContentTableView = [[ChiziChatTableView alloc] init];
    self.choicesCollectionView = [[ChiziChoiceCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    [self.choicesCollectionView registerClass:[ChiziChoiceCollectionViewCell class] forCellWithReuseIdentifier:choice];
}

- (void)setupBackgroundImage {
    self.tableBackgroundView.image = [UIImage imageNamed:@"chiziBG"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////pufu恶魔通过
//- (void)setfinished:(NSUInteger)finished {
//    self.finished = 100;
//}

//聊天记录的视图在获得高度的时候就有数据源了，不过在处理玩家的选择的视图的时候，还是要重新设置数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.chatContentTableView) {
        NSString *chiziChat = [NSString stringWithFormat:@"ChiziChat%ld",(long)indexPath.section];
        ChiziChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chiziChat];
        if(cell == nil){
            cell = [[ChiziChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chiziChat isDevil:self.isDevil message:self.playerChoice respond:self.devilRespondContent devilName:@"chizi"];
        }
        self.chiziMgr.finishText = self.devilRespondContent;
        [ChatRoomMgr defaultMgr].showTime = ChiziShowTime;
        return cell;
    }
    return nil;
}

//玩家做出选择之后的处理
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    [self.chiziMgr savePreviousStep:self.previousStep];
    [self.chiziMgr saveStep:self.finished];
}

#pragma cards
//添加卡牌
- (void)addCards:(NSUInteger)sequence {
    NSNumber *card = [NSNumber numberWithInteger:sequence];
    [self.chiziMgr saveCardInfo:card];
}

@end
