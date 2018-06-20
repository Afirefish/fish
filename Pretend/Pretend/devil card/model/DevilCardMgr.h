//
//  DevilCardMgr.h
//  Pretend
//
//  Created by daixijia on 2018/6/18.
//  Copyright © 2018年 戴曦嘉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DevilCardInfo.h"

@interface DevilCardMgr : NSObject

@property (nonatomic, strong) NSMutableArray<DevilCardInfo *> *presentCards;
+ (instancetype)defaultMgr;
- (void)saveBaseCardToDB;
- (void)updateCard:(NSUInteger)sequence available:(BOOL)available;
- (void)savecard:(DevilCardInfo *)card;

@end
