//
//  TizaChatDetail.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/30.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "TizaChatDetail.h"
#import "TizaMgr.h"
#import "TizaChatTableView.h"
#import "TizaChatTableViewCell.h"
#import "TizaChoiceCollectionView.h"
#import "TizaChoiceCollectionViewCell.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define kCellGap 20

//排名最后的恶魔，因为实力不济经常被其他低阶恶魔挑战，同时也担任着管理魔界秩序的一些杂务
@interface TizaChatDetail ()
@property (strong,nonatomic) TizaMgr *tizaMgr;

@end

@implementation TizaChatDetail

static NSString *choice = @"Choice";

+ (instancetype)tizaChatDetail {
    static TizaChatDetail *tizaChatDetail = nil;
    if (tizaChatDetail  == nil) {
        tizaChatDetail = [[TizaChatDetail alloc] init];
    }
    return tizaChatDetail;
}

//解析json，初始化高度
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Tiza";
    self.tizaMgr = [TizaMgr defaultMgr];
    self.previousStep = self.tizaMgr.previousStep;
    self.finished = self.tizaMgr.tizaFinished;
    [self jsonData:@"tiza"];
    self.allCellHeight = [[NSMutableArray alloc] init];
    [self.choicesCollectionView registerClass:[TizaChoiceCollectionViewCell class] forCellWithReuseIdentifier:choice];

}


//重写子视图设置的方法
- (void)setSubViews {
    self.chatContent = [[TizaChatTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.7)];
    self.choicesCollectionView = [[TizaChoiceCollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.7, SCREEN_WIDTH, SCREEN_HEIGHT * 0.3) collectionViewLayout:self.layout];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////tiza恶魔通过
//- (void)setTizaFinished:(NSUInteger)tizaFinished {
//    self.finished = 100;
//}

//聊天记录的视图在获得高度的时候就有数据源了，不过在处理玩家的选择的视图的时候，还是要重新设置数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.chatContent) {
        NSString *tizaChat = [NSString stringWithFormat:@"TizaChat%ld",(long)indexPath.section];
        TizaChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tizaChat];
        if(cell == nil){
            cell = [[TizaChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tizaChat isDevil:self.isDevil message:self.playerChoice respond:self.devilRespondContent devilName:@"tiza"];
        }
        return cell;
    }
    return nil;
}

//玩家做出选择之后的处理
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    [self.tizaMgr savePreviousStep:self.previousStep];
    [self.tizaMgr saveStep:self.finished];
}

#pragma cards
//添加卡牌
- (void)addCards:(NSUInteger)sequence {
    NSNumber *card = [NSNumber numberWithInteger:sequence];
    [self.tizaMgr saveCardInfo:card];
}

@end
