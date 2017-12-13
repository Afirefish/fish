//
//  SantaMgr.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/26.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "SantaMgr.h"

@implementation SantaMgr //读取每个恶魔的卡牌数据，和每个恶魔的剧情进行状态

+ (instancetype)defaultMgr {
    static SantaMgr *defaultDevilMgr = nil;
    if (defaultDevilMgr == nil) {
        defaultDevilMgr = [[SantaMgr alloc] init];
    }
    return defaultDevilMgr;
}

@end
