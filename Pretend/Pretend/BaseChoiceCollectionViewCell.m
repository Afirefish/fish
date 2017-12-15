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
        self.messageLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.adjustsFontSizeToFitWidth = YES;
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.backgroundColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            [label setFont:[UIFont systemFontOfSize:16]];
            label;
        });
//        self.messageView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self addSubview:self.messageLabel];
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

@end
