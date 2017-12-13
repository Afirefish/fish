//
//  ChiziMgr.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/26.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "ChiziMgr.h"

@implementation ChiziMgr
+ (instancetype)defaultMgr {
    static ChiziMgr *defaultDevilMgr = nil;
    if (defaultDevilMgr == nil) {
        defaultDevilMgr = [[ChiziMgr alloc] init];
    }
    return defaultDevilMgr;
}

@end
