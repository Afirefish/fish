//
//  ChatRoomMgr.h
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/26.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatRoomMgr : NSObject
@property (assign,nonatomic) BOOL chatFinished;
@property (strong,nonatomic) NSMutableSet *cards;
@property (strong,nonatomic) NSArray *playerMessages;//玩家的回复数据包
@property (strong,nonatomic) NSArray *devilMessages;//devil的回复数据包

+ (instancetype)defaultMgr;
- (void)writeToFile;
- (void)messageJson:(NSString *)devil;
- (void)saveAllCards;
- (void)chatComplete;
- (BOOL)checkComplete;
- (void)reSet;
@end
