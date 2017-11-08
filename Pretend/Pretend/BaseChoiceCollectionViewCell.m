//
//  BaseChoiceCollectionViewCell.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/11/7.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "BaseChoiceCollectionViewCell.h"

@implementation BaseChoiceCollectionViewCell

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height/4, self.bounds.size.width, self.bounds.size.height/2)];
        self.messageLabel.backgroundColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0];
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.messageLabel];
    }
    return self;
}

@end
