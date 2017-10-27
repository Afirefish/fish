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
        defaultDevilMgr = [[ChiziMgr alloc] initWithFile];
    }
    return defaultDevilMgr;
}

- (instancetype)initWithFile {
    if (self = [super init]) {
        [self loadFromFile];
    }
    return self;
}

- (void)loadFromFile {
    
}

- (void)saveStep:(NSUInteger)step {
    self.chiziFinished = step;
}

- (void)saveCardInfo:(NSNumber *)card {
    [self.cards addObject:card];
}

- (void)savePreviousStep:(NSUInteger)step {
    self.previousStep = step;
}
@end
