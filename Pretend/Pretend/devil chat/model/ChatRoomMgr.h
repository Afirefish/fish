//
//  ChatRoomMgr.h
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/26.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/*
 *目前定义好的四个章节
 */
typedef NS_ENUM(NSInteger, DevilShowTime) {
    SantaShowTime = 0,
    PufuShowTime = 1,
    ChiziShowTime = 2,
    TizaShowTime = 3,
};

@interface ChatRoomMgr : NSObject
@property (strong, nonatomic, nullable) NSMutableSet *cards;    // 为第二个卡牌游戏准备，可选
@property (strong, nonatomic) NSArray *playerMessages;          // 玩家的回复数据包
@property (strong, nonatomic) NSArray *devilMessages;           // 对方的回复数据包
@property (assign, nonatomic) NSUInteger step;                  // 当前剧情的进度
@property (assign, nonatomic) DevilShowTime showTime;           // 剧情处于的章节模块

+ (instancetype)defaultMgr; // 单例

// 新的文本控制方式
@property (strong, nonatomic) NSArray *plainMessages;   // 平常的文本
- (void)loadPlainFile;                                  // 加载普通文本
 /*
  *加载某个章节的某个分支，
  file是分支名，
  devil是章节名（目前一般用主要人物名作为章节名），
  这些需要和特殊格式里面的一致
  */
- (void)loadChatFile:(NSString *)file withDevil:(NSString *)devil;
- (void)updateStep:(NSUInteger)step;                // 更新所有章节的状态

- (void)writeToFile;                                // 保存当前剧情进度
- (void)saveAllCards;                               // 保存卡牌的状态
- (void)chatComplete;                               // 设置聊天完成
- (BOOL)checkComplete;                              // 检测聊天是否完成
- (void)reSet;                                      // 重置

@end

NS_ASSUME_NONNULL_END
