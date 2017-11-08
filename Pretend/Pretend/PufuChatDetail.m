//
//  PufuChatDetail.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/30.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "PufuChatDetail.h"
#import "PufuMgr.h"
#import "PufuChatTableView.h"
#import "PufuChatTableViewCell.h"
#import "PufuChoiceCollectionView.h"
#import "PufuChoiceCollectionViewCell.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define kCellGap 20

//似乎是比较温和的女性恶魔，拥有时光之力？？强大的实力毋庸置疑
@interface PufuChatDetail ()

@property (strong,nonatomic) PufuMgr *pufuMgr;

@end

@implementation PufuChatDetail

static NSString *choice = @"Choice";

+ (instancetype)pufuChatDetail {
    static PufuChatDetail *pufuChatDetail = nil;
    if (pufuChatDetail == nil) {
        pufuChatDetail = [[PufuChatDetail alloc] init];
    }
    return pufuChatDetail;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Pufu";
    self.pufuMgr = [PufuMgr defaultMgr];
    self.previousStep = self.pufuMgr.previousStep;
    self.finished = self.pufuMgr.pufuFinished;
    [self jsonData:@"pufu"];
    self.allCellHeight = [[NSMutableArray alloc] init];
    [self.choicesCollectionView registerClass:[PufuChoiceCollectionViewCell class] forCellWithReuseIdentifier:choice];
}

//重写子视图设置的方法
- (void)setSubViews {
    self.chatContent = [[PufuChatTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.7)];
    self.choicesCollectionView = [[PufuChoiceCollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.7, SCREEN_WIDTH, SCREEN_HEIGHT * 0.3) collectionViewLayout:self.layout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////pufu恶魔通过
//- (void)setPufuFinished:(NSUInteger)pufuFinished {
//    self.finished = 100;
//}

//聊天记录的视图在获得高度的时候就有数据源了，不过在处理玩家的选择的视图的时候，还是要重新设置数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.chatContent) {
        NSString *pufuChat = [NSString stringWithFormat:@"PufuChat%ld",(long)indexPath.section];
        PufuChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pufuChat];
        if(cell == nil){
            cell = [[PufuChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pufuChat isDevil:self.isDevil message:self.playerChoice respond:self.devilRespondContent devilName:@"pufu"];
        }
        return cell;
    }
    return nil;
}

//玩家做出选择之后的处理
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    [self.pufuMgr savePreviousStep:self.previousStep];
    [self.pufuMgr saveStep:self.finished];
}

#pragma cards

//添加卡牌
- (void)addCards:(NSUInteger)sequence {
    NSNumber *card = [NSNumber numberWithInteger:sequence];
    [self.pufuMgr saveCardInfo:card];
}


@end
