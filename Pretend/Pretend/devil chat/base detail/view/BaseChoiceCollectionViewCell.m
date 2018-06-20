//
//  BaseChoiceCollectionViewCell.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/11/7.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "BaseChoiceCollectionViewCell.h"
#import <Masonry.h>
#import "UIColor+PRCustomColor.h"

@implementation BaseChoiceCollectionViewCell

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置玩家选项内容
        self.messageLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.adjustsFontSizeToFitWidth = YES;
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = [UIColor whiteColor];
            label;
        });
//        self.messageView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self addSubview:self.messageLabel];
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        // 设置当前情景选项的背景图片
        self.backgroudImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.cornerRadius = 8.0;
            imageView.clipsToBounds = YES;
            imageView;
        });
        [self addSubview:self.backgroudImageView];
        [self sendSubviewToBack:self.backgroudImageView];
        [self.backgroudImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.messageLabel);
        }];
    }
    return self;
}

@end
