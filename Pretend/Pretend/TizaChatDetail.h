//
//  TizaChatDetail.h
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/30.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

//tiza恶魔的具体聊天控制
#import "BaseChatDetail.h"

@interface TizaChatDetail : BaseChatDetail
@property (readonly,assign,nonatomic) NSUInteger tizaFinished;
+ (instancetype)tizaChatDetail;

@end
