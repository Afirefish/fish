//
//  Devil.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/26.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "Devil.h"

@implementation Devil

- (instancetype)initWithDevilID:(NSUInteger)ID withHardMode:(DevilMode)mode{
    if (self = [super init]) {
        self.devilID = ID;
        self.name = [NSString stringWithFormat:@"devil%td",ID];
        self.mode = mode;
        self.appearance = [UIImage imageNamed:@"chiziCrafter"];
        self.cards = [[NSMutableSet alloc] init];
        self.lifePoint = 10;
        self.isDefeated = NO;
        self.crafterInfo = @"恶魔，人类，区别在哪里呢？人类也可能比恶魔更像恶魔";
    }
    return self;
}

@end
