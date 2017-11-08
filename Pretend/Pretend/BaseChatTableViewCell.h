//
//  BaseChatTableViewCell.h
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/29.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

//聊天的cell的基类
#import <UIKit/UIKit.h>

@interface BaseChatTableViewCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isDevil:(BOOL)isDevil message:(NSString *)message respond:(NSString *)respond devilName:(NSString *)devilName;//重写的cell的初始化函数

@end
