//
//  Puri.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/26.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "Puri.h"

@implementation Puri

static Puri *puri = nil;

+ (instancetype)commonPuri {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        puri = [[Puri alloc] init];
    });
    return puri;
}

- (instancetype)init {
    if (self = [super init]) {
        self.name = @"Puri";
        self.lifePoint = 10;
        self.isDefeated = NO;
        self.crafterInfo = @"puri 经历过了恶魔们的考验，获得了进入卡牌对战的资格，等待他的将会是什么?";
        self.defeatedCrafterCount = 0;
        [self loadStatus];
    }
    return self;
}

// 从上次的文件记录中加载puri的数据
- (void)loadStatus {
    
}

@end
