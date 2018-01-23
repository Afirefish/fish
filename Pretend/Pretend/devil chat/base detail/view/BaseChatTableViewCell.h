//
//  BaseChatTableViewCell.h
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/29.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

//聊天的cell的基类
#import <UIKit/UIKit.h>
#import "BaseChatModel.h"

@interface BaseChatTableViewCell : UITableViewCell

- (void)updateWithModel:(BaseChatModel *)model;

@end
