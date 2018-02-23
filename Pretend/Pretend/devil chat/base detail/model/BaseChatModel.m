//
//  BaseChatModel.m
//  Pretend
//
//  Created by daixijia on 2018/1/23.
//  Copyright © 2018年 戴曦嘉. All rights reserved.
//

#import "BaseChatModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseChatModel ()

@property (nonatomic, strong, readwrite) NSString *message;
@property (nonatomic, assign, readwrite) BOOL isDevil;
@property (nonatomic, assign, readwrite) BOOL isChoice;

@end

@implementation BaseChatModel

- (instancetype)initWithMsg:(NSString *)message isDevil:(BOOL)isDevil isChoice:(BOOL)isChoice {
    if (self = [super init]) {
        self.message = message;
        self.isDevil = isDevil;
        self.isChoice = isChoice;
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
