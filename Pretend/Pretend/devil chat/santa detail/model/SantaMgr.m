//
//  SantaMgr.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/26.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "SantaMgr.h"

@implementation SantaMgr

static SantaMgr *defaultDevilMgr = nil;

+ (instancetype)defaultMgr {
    if (defaultDevilMgr == nil) {
        defaultDevilMgr = [[SantaMgr alloc] init];
    }
    return defaultDevilMgr;
}

- (void)reset {
    [super reset];
    defaultDevilMgr = nil;
    defaultDevilMgr = [[SantaMgr alloc] init];
}

@end
