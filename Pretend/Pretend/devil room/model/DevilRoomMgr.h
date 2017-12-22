//
//  DevilRoomMgr.h
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/31.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DevilRoomMgr : NSObject
@property (strong,nonatomic) NSArray *considerArr;//考虑的数组
@property (assign,nonatomic) BOOL betary;//背叛
@property (assign,nonatomic) BOOL sincere;//信任
@property (assign,nonatomic) BOOL roomFinish;//第三个场景完成
+ (instancetype)defaultMgr;
- (NSString *)considerMessage:(NSUInteger)index;
@end
