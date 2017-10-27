//
//  BaseChoice.h
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/29.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

//玩家的选项
#import <UIKit/UIKit.h>

@interface BaseChoice : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier message:(NSString *)message;

@end
