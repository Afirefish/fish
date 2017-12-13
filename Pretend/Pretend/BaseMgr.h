//
//  BaseMgr.h
//  Pretend
//
//  Created by daixijia on 2017/12/13.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatRoomMgr.h"

@interface BaseMgr : NSObject
@property (strong, nonatomic) NSMutableSet *cards;// 恶魔的卡牌
@property (assign, nonatomic) NSUInteger finished;//当前的进度
@property (strong, nonatomic) NSString *finishText;//上一句剧情
@property (assign, nonatomic) NSUInteger previousStep;//上一步的进度

+ (instancetype)defaultMgr;
- (void)saveCardInfo:(id)arg1;
- (void)saveStep:(NSUInteger)arg1;
- (void)savePreviousStep:(NSUInteger)arg1;
- (void)saveToFile;
- (void)reset;

@end
