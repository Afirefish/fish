//
//  BaseMgr.h
//  Pretend
//
//  Created by daixijia on 2017/12/13.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatRoomMgr.h"
#import "BaseChatModel.h"

typedef NS_ENUM(NSInteger, ChatStatus) {
    ChatBegin = 1000,
    ChatComplete = 1001,
    ChapterBegin = 1002,
    ChapterComplete = 1003,
    PlainChat = 1004,
    BranchBegin = 1005,
    BranchComplete = 1006,
    PlayerTime = 1007,
    DevilTime = 1008,
    OtherChapterBegin = 1009,
};

@interface BaseMgr : NSObject

// 数据存储
// 缓存数据，解决复用问题
@property (strong, nonatomic) NSMutableArray *allCellHeight;//保存聊天记录的所有视图的高度
@property (strong, nonatomic) NSMutableArray<BaseChatModel *> *chatMessageList;

@property (assign, nonatomic) BOOL isDevil;//当前节点是否是devil
//@property (assign, nonatomic) NSUInteger finished;//100代表结束
//@property (assign, nonatomic) NSUInteger previousStep;//上一步
@property (strong, nonatomic) NSArray *playerMessages;//玩家的回复数据包
@property (strong, nonatomic) NSArray *devilMessages;//devil的回复数据包

@property (nonatomic, assign) BOOL isChoice;// 当前是否是对话文本
@property (nonatomic, strong) NSString *plainMsg; //  普通文本的消息
@property (nonatomic, assign) NSInteger nextStep; // 下一步

@property (assign, nonatomic) NSInteger choiceCount;//玩家选项数量
@property (assign, nonatomic) NSUInteger choiceIndex;//玩家选择的回复的索引
@property (strong, nonatomic) NSArray *choiceArr;//玩家所有选择的数组
@property (strong, nonatomic) NSDictionary *choiceDic;//玩家所有选择数组中的元素
@property (strong, nonatomic) NSString *playerChoice;//玩家的选择

@property (strong, nonatomic) NSArray *devilArr;//santa的回复的数组
@property (strong, nonatomic) NSDictionary *devilDic;//santa回复的字典
@property (strong, nonatomic) NSString *devilRespondContent;//santa的回复的信息字符串


// 剧情控制
@property (strong, nonatomic) NSMutableSet *cards;// 恶魔的卡牌
@property (assign, nonatomic) NSUInteger finished;//当前的进度
@property (strong, nonatomic) NSString *finishText;//上一句剧情
@property (assign, nonatomic) NSUInteger previousStep;//上一步的进度

- (ChatStatus)loadNewMessage;
- (void)devilRespond;
- (ChatStatus)loadNextChoice;

- (void)saveCardInfo:(id)arg1;
- (void)saveToFile;
- (void)reset;

@end

