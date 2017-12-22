//
//  PufuMgr.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/26.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//


#import "PufuMgr.h"

@implementation PufuMgr
+ (instancetype)defaultMgr {
    static PufuMgr *defaultDevilMgr = nil;
    if (defaultDevilMgr == nil) {
        defaultDevilMgr = [[PufuMgr alloc] init];
    }
    return defaultDevilMgr;
}

@end
