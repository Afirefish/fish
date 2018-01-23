//
//  ChatRoomMgr.h
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/26.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DevilShowTime) {
    SantaShowTime = 0,
    PufuShowTime = 1,
    ChiziShowTime = 2,
    TizaShowTime = 3,
};

@interface ChatRoomMgr : NSObject
@property (assign, nonatomic) BOOL chatFinished;
@property (strong, nonatomic, nullable) NSMutableSet *cards;
@property (strong, nonatomic) NSArray *playerMessages; // 玩家的回复数据包
@property (strong, nonatomic) NSArray *devilMessages; // devil的回复数据包
@property (assign, nonatomic) NSUInteger step; // 当前剧情的进度
@property (assign, nonatomic) DevilShowTime showTime; // 剧情处于的恶魔模块

// 新的文本控制方式test
@property (strong, nonatomic) NSArray *plainMessages;//平常的文本
- (void)loadPlainFile;
- (void)loadChatFile:(NSString *)prefix withDevil:(NSString *)devil;
- (void)updateStep:(NSUInteger)step;


+ (instancetype)defaultMgr;
- (void)writeToFile;
- (void)saveAllCards;
- (void)chatComplete;
- (BOOL)checkComplete;
- (void)reSet;

//- (void)messageJson:(NSString *)devil;

@end

NS_ASSUME_NONNULL_END
