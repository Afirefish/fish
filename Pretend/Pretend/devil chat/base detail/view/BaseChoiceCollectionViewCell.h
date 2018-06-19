//
//  BaseChoiceCollectionViewCell.h
//  Pretend
//
//  Created by 戴曦嘉 on 2017/11/7.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import "UIColor+PRCustomColor.h"

// 玩家选项的cell

@interface BaseChoiceCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *messageLabel;            // 选项内容
@property (strong, nonatomic) UIImageView *backgroudImageView;  // 背景图片

@end
