//
//  ChatRoomMgr.h
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/26.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DevilShowTime) {
    SantaShowTime = 0,
    PufuShowTime = 1,
    ChiziShowTime = 2,
    TizaShowTime = 3,
};

@interface ChatRoomMgr : NSObject
@property (assign,nonatomic) BOOL chatFinished;
@property (strong,nonatomic) NSMutableSet *cards;
@property (strong,nonatomic) NSArray *playerMessages;//玩家的回复数据包
@property (strong,nonatomic) NSArray *devilMessages;//devil的回复数据包
@property (assign,nonatomic) NSUInteger step;//当前剧情的进度
@property (assign,nonatomic) DevilShowTime showTime;//剧情处于的恶魔模块

+ (instancetype)defaultMgr;
- (void)writeToFile;
- (void)messageJson:(NSString *)devil;
- (void)saveAllCards;
- (void)chatComplete;
- (BOOL)checkComplete;
- (void)reSet;
@end
