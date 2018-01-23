//
//  PufuMgr.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/26.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//


#import "PufuMgr.h"

@implementation PufuMgr

static PufuMgr *defaultDevilMgr = nil;

+ (instancetype)defaultMgr {
    if (defaultDevilMgr == nil) {
        defaultDevilMgr = [[PufuMgr alloc] init];
    }
    return defaultDevilMgr;
}

- (void)reset {
    [super reset];
    defaultDevilMgr = nil;
    defaultDevilMgr = [[PufuMgr alloc] init];
}

@end
