//
//  CardCraftMgr.h
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/26.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Puri;

@interface CardCraftMgr : NSObject
@property (strong,nonatomic) NSMutableSet *devilCards;//敌人的卡牌,开始战斗的时候再加载
@property (strong,nonatomic) NSMutableSet *crafters;//敌人集合
@property (strong,nonatomic) Puri *PuriCrafter;//主角
@property (strong,nonatomic) NSMutableSet *PuriCards;//存储直接从文件中获得的主角的卡牌
@property (assign,nonatomic) BOOL craftFinished;//第二个游戏完成
+ (instancetype)defaultMgr;
- (void)presentCardInfo:(NSUInteger)sequence;//显示某一张卡牌的信息
- (void)BattleStart:(NSUInteger)devilID;//开始对战
- (void)loadDevilCard:(NSInteger)devilID;//加载恶魔的卡牌
@end
