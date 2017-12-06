//
//  SantaChatDetail.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/29.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "SantaChatDetail.h"
#import "SantaMgr.h"
#import "SantaChatTableView.h"
#import "SantaChatTableViewCell.h"
#import "SantaChoiceCollectionView.h"
#import "SantaChoiceCollectionViewCell.h"

#define SCREEN_SIZE ([UIScreen mainScreen].bounds.size)
#define SCREEN_WIDTH (SCREEN_SIZE.width < SCREEN_SIZE.height ? SCREEN_SIZE.width : SCREEN_SIZE.height)
#define SCREEN_HEIGHT (SCREEN_SIZE.width > SCREEN_SIZE.height ? SCREEN_SIZE.width : SCREEN_SIZE.height)
#define kCellGap 20

//说话语气很凶，但是实际是个很好的家伙，没有固定的居住地，偶尔会去chizi的宫殿呆着
@interface SantaChatDetail ()

@property (strong,nonatomic) SantaMgr *santaMgr;


@end

@implementation SantaChatDetail

static NSString *choice = @"Choice";

+ (instancetype)santaChatDetail {
    static SantaChatDetail *santaChatDetail = nil;
    if (santaChatDetail == nil) {
        santaChatDetail = [[SantaChatDetail alloc] init];
    }
    return santaChatDetail;
}

//解析json，初始化高度
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Santa";
    self.santaMgr = [SantaMgr defaultMgr];
    self.previousStep = self.santaMgr.previousStep;
    self.finished = self.santaMgr.santaFinished;
    [self jsonData:@"santa"];
    self.allCellHeight = [[NSMutableArray alloc] init];

}

//重写设置内容视图的类型的方法
- (void)setUpContentViewsType {
    self.chatContentTableView = [[SantaChatTableView alloc] init];
    self.choicesCollectionView = [[SantaChoiceCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    [self.choicesCollectionView registerClass:[SantaChoiceCollectionViewCell class] forCellWithReuseIdentifier:choice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

////santa恶魔通过
//- (void)setSantaFinished{
//    self.finished = 100;
//}

//聊天记录的视图在获得高度的时候就有数据源了，不过在处理玩家的选择的视图的时候，还是要重新设置数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.chatContentTableView) {
        NSString *santaChat = [NSString stringWithFormat:@"SantaChat%ld",(long)indexPath.section];
        SantaChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:santaChat];
        if(cell == nil){
            cell = [[SantaChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:santaChat isDevil:self.isDevil message:self.playerChoice respond:self.devilRespondContent devilName:@"santa"];
        }
        return cell;
    }
    return nil;
}

//玩家做出选择之后的处理
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    [self.santaMgr savePreviousStep:self.previousStep];
    [self.santaMgr saveStep:self.finished];
}

#pragma cards

//添加卡牌
- (void)addCards:(NSUInteger)sequence {
    NSNumber *card = [NSNumber numberWithInteger:sequence];
    [self.santaMgr saveCardInfo:card];
}

@end
