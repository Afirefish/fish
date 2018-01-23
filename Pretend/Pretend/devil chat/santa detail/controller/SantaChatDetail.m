//
//  SantaChatDetail.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/29.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "SantaChatDetail.h"
#import "ChatRoomMgr.h"
#import "SantaMgr.h"
#import "SantaChatTableView.h"
#import "SantaChatTableViewCell.h"
#import "SantaChoiceCollectionView.h"
#import "SantaChoiceCollectionViewCell.h"

#define kCellGap 20

//说话语气很凶，但是实际是个很好的家伙，没有固定的居住地，偶尔会去chizi的宫殿呆着
@interface SantaChatDetail ()
@property (strong, nonatomic) SantaMgr *santaMgr;

@end

@implementation SantaChatDetail

static NSString *choice = @"Choice";
static SantaChatDetail *santaChatDetail = nil;

+ (instancetype)santaChatDetail {
    if (santaChatDetail == nil) {
        santaChatDetail = [[SantaChatDetail alloc] init];
    }
    return santaChatDetail;
}

// 每次加载从上一步加载，如果上一步是没完成的选择的话，那么允许重新选择
- (instancetype)init {
    if (self = [super init]) {
        self.santaMgr = [SantaMgr defaultMgr];
        self.previousStep = self.santaMgr.previousStep;
        self.finished = self.santaMgr.previousStep;
    }
    return self;
}

- (void)reset {
    santaChatDetail = [[SantaChatDetail alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.previousStep = self.santaMgr.previousStep;
    self.finished = self.santaMgr.previousStep;
    if (self.chatRoomMgr.showTime != SantaShowTime) {
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
    self.navigationItem.title = @"Santa";
}

//重写设置内容视图的类型的方法
- (void)setupContentViewsType {
    self.chatContentTableView = [[SantaChatTableView alloc] init];
    self.choicesCollectionView = [[SantaChoiceCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    [self.choicesCollectionView registerClass:[SantaChoiceCollectionViewCell class] forCellWithReuseIdentifier:choice];
}

- (void)setupBackgroundImage {
    self.tableBackgroundView.image = [UIImage imageNamed:@"santaBG"];
}

////santa恶魔通过
//- (void)setfinished{
//    self.finished = 100;
//}

//聊天记录的视图在获得高度的时候就有数据源了，不过在处理玩家的选择的视图的时候，还是要重新设置数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *santaChat = [NSString stringWithFormat:@"SantaChat%ld",(long)indexPath.section];
    SantaChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:santaChat];
    // 如果普通文本的话，读取之后设置为玩家的话的形式显示
    if (!self.isChoice) {
        if(cell == nil){
            cell = [[SantaChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:santaChat isDevil:NO message:self.plainMsg respond:nil devilName:nil];
        }
        if (![self.plainMsg containsString:@"Begin"] && ![self.plainMsg containsString:@"End"]) {
            self.santaMgr.finishText = self.plainMsg;
        }
    }
    // 对话文本的话，根据是玩家还是恶魔显示不同的效果
    else {
        if(cell == nil){
            cell = [[SantaChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:santaChat isDevil:self.isDevil message:self.playerChoice respond:self.devilRespondContent devilName:@"santa"];
        }
        self.santaMgr.finishText = self.devilRespondContent;
    }
    return cell;
}

//玩家做出选择之后的处理
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    self.santaMgr.previousStep = self.previousStep;
    self.santaMgr.finished = self.finished;
}

#pragma cards

//添加卡牌
- (void)addCards:(NSUInteger)sequence {
    NSNumber *card = [NSNumber numberWithInteger:sequence];
    [self.santaMgr saveCardInfo:card];
}

@end
