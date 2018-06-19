//
//  DevilCardInfo.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/26.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "DevilCardInfo.h"

@implementation DevilCardInfo

- (instancetype)initWithCardSequence:(NSUInteger)cardSequence {
    if (self = [super init]) {
        self.cardSequence = cardSequence;
        self.cardName = [NSString stringWithFormat:@"卡牌%td",cardSequence];
        self.cardType = RoleCard;
        self.cardLP = 4;
        self.cardFunction = @"暂时没有卡牌效果";
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"card seq : %td, card name : %@, card type : %td, card lp : %td, card attack : %td, card image %@",
            self.cardSequence, self.cardName, self.cardType, self.cardLP, self.cardAttack, self.cardImage];
}

@end
