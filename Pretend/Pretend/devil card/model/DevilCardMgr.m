//
//  DevilCardMgr.m
//  Pretend
//
//  Created by daixijia on 2018/6/18.
//  Copyright © 2018年 戴曦嘉. All rights reserved.
//

#import "DevilCardMgr.h"
#import "PRDBManager.h"
#import "PRConstantSQL.h"

@interface DevilCardMgr ()

@property (nonatomic, strong) PRDBManager *dbMgr;

@end

@implementation DevilCardMgr

+ (instancetype)defaultMgr {
    static DevilCardMgr *cardMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cardMgr = [[DevilCardMgr alloc] init];
    });
    return cardMgr;
}

- (instancetype)init {
    if (self = [super init]) {
        self.dbMgr = [[PRDBManager alloc] init];
        self.dbMgr.databasePath = self.dbMgr.cardDBPath;
    }
    return self;
}

- (void)saveBaseCardToDB {

    [self.dbMgr createDB:createCardsSQL];
    [self.dbMgr saveCardDB:updateCardsSQL sequence:1 name:@"小精灵" type:0 lifePoint:1 attack:1 function:@"" image:@"p1" available:0 deprecated:0];
    [self.dbMgr saveCardDB:updateCardsSQL sequence:2 name:@"雪鳍企鹅" type:0 lifePoint:1 attack:1 function:@"" image:@"p2" available:0 deprecated:0];
    [self.dbMgr saveCardDB:updateCardsSQL sequence:3 name:@"持盾卫士" type:0 lifePoint:4 attack:0 function:@"" image:@"p3" available:0 deprecated:0];
    [self.dbMgr saveCardDB:updateCardsSQL sequence:4 name:@"狼人渗透者" type:0 lifePoint:1 attack:2 function:@"" image:@"p4" available:0 deprecated:0];
    [self.dbMgr saveCardDB:updateCardsSQL sequence:5 name:@"石牙野猪" type:0 lifePoint:1 attack:1 function:@"" image:@"p5" available:0 deprecated:0];
    [self.dbMgr saveCardDB:updateCardsSQL sequence:6 name:@"魔法乌鸦" type:0 lifePoint:2 attack:2 function:@"" image:@"p6" available:0 deprecated:0];
}

- (NSMutableArray<DevilCardInfo *> *)presentCards {
    if (!_presentCards) {
        _presentCards = [[NSMutableArray alloc] init];
        for (NSInteger i = 1; i <= 6 ; i++) {
            DevilCardInfo *card = [self.dbMgr loadCardInfo:queryCardsSQL sequence:(int)i];
            NSLog(@"card %td info %@:", i, [card description]);
            if (card.isAvailable) {
                [_presentCards addObject:card];
            }
        }
    }
    return  _presentCards;

}

- (void)updateCard:(NSUInteger)sequence available:(BOOL)available {
    PRDBManager *dbMgr = [[PRDBManager alloc] init];
    dbMgr.databasePath = dbMgr.cardDBPath;
    DevilCardInfo *card1 = [dbMgr updateCardDB:updateCardAvailable sequence:(int)sequence available:available?1:0];
    NSLog(@"card update %@",[card1 description]);
    BOOL flag = NO;
    DevilCardInfo *target = nil;
    for (DevilCardInfo *card in self.presentCards) {
        if (card.cardSequence == sequence) {
            flag = YES;
            target = card;
        }
    }
    if (available && !flag) {
        target = [dbMgr loadCardInfo:queryCardsSQL sequence:(int)sequence];
        [self.presentCards addObject:target];
    }
    if (!available && flag && target) {
        [self.presentCards removeObject:target];
    }
   
}

- (void)savecard:(DevilCardInfo *)card {
    
}

@end
