//
//  BaseChatCell.h
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/29.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

//聊天的cell的基类
#import <UIKit/UIKit.h>

@interface BaseChatCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier devil:(BOOL)isDevil message:(NSString *)message respond:(NSString *)respond;//重写的cell的初始化函数

@end
