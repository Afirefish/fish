//
//  PufuChatDetail.h
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/30.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

//pufu恶魔的具体聊天控制
#import "BaseChatDetail.h"

@interface PufuChatDetail : BaseChatDetail

@property (readonly,assign,nonatomic) NSUInteger pufuFinished;
+ (instancetype)pufuChatDetail;

@end
