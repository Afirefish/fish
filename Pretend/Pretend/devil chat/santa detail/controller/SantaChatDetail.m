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
@property (strong, nonatomic) SantaMgr *santaMgr;

@end

@implementation SantaChatDetail

static NSString *choice = @"Choice";
static NSString *santaChat = @"SantaChat";
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
    self.finished = self.santaMgr.finished;
    if (self.chatRoomMgr.showTime != SantaShowTime) {
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
    self.santaMgr.finishText = self.chatMessageList.lastObject.message;
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

////santa恶魔通过
//- (void)setfinished{
//    self.finished = 100;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:santaChat forIndexPath:indexPath];
    BaseChatModel *model = [self.chatMessageList objectAtIndex:indexPath.row];
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
