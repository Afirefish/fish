//
//  BaseChatModel.h
//  Pretend
//
//  Created by daixijia on 2018/1/23.
//  Copyright © 2018年 戴曦嘉. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*基本聊天信息的model,分为三类，
 普通剧情文本，
 玩家对话文本，
 对方回复文本，
 对方回复文本可以提供头像
*/
@interface BaseChatModel : NSObject

@property (nonatomic, strong, readonly) NSString *message;
@property (nonatomic, assign, readonly) BOOL isDevil;
@property (nonatomic, assign, readonly) BOOL isChoice;
@property (nonatomic, assign, nullable) NSString *devil;

/*
 @param message 具体的聊天信息
 @param isDevil 如果是对方的回复，传YES
 @param isChoice 如果是对话文本传YES，普通文本传NO
 */

- (instancetype)initWithMsg:(NSString *)message isDevil:(BOOL)isDevil isChoice:(BOOL)isChoice;

@end

NS_ASSUME_NONNULL_END
