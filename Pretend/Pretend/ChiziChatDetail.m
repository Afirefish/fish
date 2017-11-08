//
//  ChiziChatDetail.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/30.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "ChiziChatDetail.h"
#import "ChiziMgr.h"
#import "ChiziChatTableView.h"
#import "ChiziChatTableViewCell.h"
#import "ChiziChoiceCollectionView.h"
#import "ChiziChoiceCollectionViewCell.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define kCellGap 20

//设定为比较残忍的人，和santa很合得来，拥有最强大的近战攻击力
@interface ChiziChatDetail ()
@property (strong,nonatomic) ChiziMgr *chiziMgr;

@end

@implementation ChiziChatDetail

static NSString *choice = @"Choice";

+ (instancetype)chiziChatDetail {
    static ChiziChatDetail *chiziChatDetail = nil;
    if (chiziChatDetail  == nil) {
        chiziChatDetail = [[ChiziChatDetail alloc] init];
    }
    return chiziChatDetail;
}

//解析json，初始化高度
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Chizi";
    self.chiziMgr = [ChiziMgr defaultMgr];
    self.previousStep = self.chiziMgr.previousStep;
    self.finished = self.chiziMgr.chiziFinished;
    [self jsonData:@"chizi"];
    self.allCellHeight = [[NSMutableArray alloc] init];
    [self.choicesCollectionView registerClass:[ChiziChoiceCollectionViewCell class] forCellWithReuseIdentifier:choice];
}

//重写子视图设置的方法
- (void)setSubViews {
    self.chatContent = [[ChiziChatTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.7)];
    self.choicesCollectionView = [[ChiziChoiceCollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.7, SCREEN_WIDTH, SCREEN_HEIGHT * 0.3) collectionViewLayout:self.layout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////pufu恶魔通过
//- (void)setChiziFinished:(NSUInteger)chiziFinished {
//    self.finished = 100;
//}

//聊天记录的视图在获得高度的时候就有数据源了，不过在处理玩家的选择的视图的时候，还是要重新设置数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.chatContent) {
        NSString *chiziChat = [NSString stringWithFormat:@"ChiziChat%ld",(long)indexPath.section];
        ChiziChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chiziChat];
        if(cell == nil){
            cell = [[ChiziChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chiziChat isDevil:self.isDevil message:self.playerChoice respond:self.devilRespondContent devilName:@"chizi"];
        }
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
