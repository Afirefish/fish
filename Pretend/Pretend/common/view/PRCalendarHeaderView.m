//
//  PRCalendarHeaderView.m
//  Pretend
//
//  Created by xijia dai on 2019/12/10.
//  Copyright © 2019 戴曦嘉. All rights reserved.
//

#import <Masonry.h>

#import "PRCalendarHeaderView.h"

@interface PRCalendarHeaderView ()

@property (nonatomic) NSArray<NSString *> *items;
@property (nonatomic) NSMutableArray *buttons;

@end

@implementation PRCalendarHeaderView

- (instancetype)initWithItems:(NSArray *)items {
    if (self = [super initWithFrame:CGRectZero]) {
        self.items = items;
        self.buttons = [NSMutableArray new];
        [self makeSubViewAndConstraints];
    }
    return self;
}

- (void)makeSubViewAndConstraints {
    self.backgroundColor = [UIColor whiteColor];
    UIButton *last = nil;
    for (NSString *title in self.items) {
        UIButton *button = [self makeButtonsWithTitle:title];
        [self.buttons addObject:button];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.mas_width).multipliedBy(1.0 / self.items.count);
            make.top.bottom.equalTo(self);
            make.left.equalTo(last ? last.mas_right : self.mas_left);
        }];
        last = button;
    }
}

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSArray<NSNumber *> *)index {
    for (NSNumber *number in index) {
        UIButton *button = [self.buttons objectAtIndex:number.integerValue];
        if (button) {
            [button setTitle:title forState:UIControlStateNormal];
        }
    }
}

- (void)setTitleColor:(UIColor *)color forSegmentAtIndex:(NSArray<NSNumber *> *)index {
    for (NSNumber *number in index) {
        UIButton *button = [self.buttons objectAtIndex:number.integerValue];
        if (button) {
            [button setTitleColor:color forState:UIControlStateNormal];
        }
    }
}

- (UIButton *)makeButtonsWithTitle:(NSString *)title {
    UIButton *button = [UIButton new];
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    return button;
}

@end
