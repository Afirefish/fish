//
//  PRCalendarCell.m
//  Pretend
//
//  Created by xijia dai on 2019/12/11.
//  Copyright © 2019 戴曦嘉. All rights reserved.
//

#import <Masonry.h>

#import "PRCalendarCell.h"

@interface PRCalendarCell ()

@property (nonatomic) UILabel *numberLabel;

@end

@implementation PRCalendarCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self makeSubviewsAndConstraints];
    }
    return self;
}

- (void)makeSubviewsAndConstraints {
    self.backgroundColor = [UIColor whiteColor];
    self.numberLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)updateNumber:(NSInteger)number enable:(BOOL)enable {
    self.numberLabel.text = [NSString stringWithFormat:@"%td", number];
    self.numberLabel.textColor = enable ? [UIColor blackColor] : [UIColor grayColor];
}

@end
