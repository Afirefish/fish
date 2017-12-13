//
//  TizaMgr.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/26.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "TizaMgr.h"

@implementation TizaMgr
+ (instancetype)defaultMgr {
    static TizaMgr *defaultDevilMgr = nil;
    if (defaultDevilMgr == nil) {
        defaultDevilMgr = [[TizaMgr alloc] init];
    }
    return defaultDevilMgr;
}

@end
