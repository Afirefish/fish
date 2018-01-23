//
//  BaseChatModel.h
//  Pretend
//
//  Created by daixijia on 2018/1/23.
//  Copyright © 2018年 戴曦嘉. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseChatModel : NSObject

@property (nonatomic, strong, readonly) NSString *message;
@property (nonatomic, assign, readonly) BOOL isDevil;
@property (nonatomic, assign, readonly) BOOL isChoice;
@property (nonatomic, assign, nullable) NSString *devil;

- (instancetype)initWithMsg:(NSString *)message isDevil:(BOOL)isDevil isChoice:(BOOL)isChoice;

@end

NS_ASSUME_NONNULL_END
