//
//  CardCraftMgr.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/26.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "CardCraftMgr.h"
#import "ChatRoomMgr.h"
#import "Devil.h"
#import "Puri.h"
#import "DevilCardInfo.h"

@implementation CardCraftMgr

+ (instancetype)defaultMgr {
    static CardCraftMgr *cardCraft = nil;
    if (cardCraft == nil) {
        cardCraft = [[CardCraftMgr alloc] initWithFile];
    }
    return cardCraft;
}

- (instancetype)initWithFile {//从文件中加载数据，初始化主角的卡牌
    if (self = [super init]) {
        [self loadFromFile];
        self.craftFinished = YES;
        self.PuriCrafter = [[Puri alloc] init];
    }
    return self;
}

- (void)loadFromFile {//从文件中加载战局信息？以及主角卡牌信息,以及恶魔的特殊卡牌信息
    //load crafters PuriCards
}

- (void)presentCardInfo:(NSUInteger)sequence {//显示卡牌的信息
    
}

- (void)BattleStart:(NSUInteger)devilID {//开始对战
    [self loadDevilCard:devilID];
}


- (void)loadDevilCard:(NSInteger)devilID {//选定对手后加载对手的卡牌
    for (Devil *devil in self.crafters) {
        if (devil.devilID == devilID) {
            self.devilCards = devil.cards;
        }
    }
    //还要加一些随机生成的卡牌
}

@end
