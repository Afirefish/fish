//
//  TizaMgr.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/26.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "TizaMgr.h"

@implementation TizaMgr

static TizaMgr *defaultDevilMgr = nil;

+ (instancetype)defaultMgr {
    if (defaultDevilMgr == nil) {
        defaultDevilMgr = [[TizaMgr alloc] init];
    }
    return defaultDevilMgr;
}

- (void)reset {
    [super reset];
    defaultDevilMgr = nil;
    defaultDevilMgr = [[TizaMgr alloc] init];
}

@end
