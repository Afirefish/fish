//
//  BaseChatControlsView.m
//  Pretend
//
//  Created by daixijia on 2018/6/15.
//  Copyright © 2018年 戴曦嘉. All rights reserved.
//

#import "BaseChatControlsView.h"
#import "UIColor+PRCustomColor.h"
#import <Masonry.h>

@implementation BaseChatControlsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor warmShellColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self addSubview:self.nextBtn];
    [self addSubview:self.autoPlayBtn];
    [self addSubview:self.fastPlayBtn];
    [self addSubview:self.tipLabel];
    
    [self.autoPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.3);
        make.height.equalTo(self).multipliedBy(0.6);
    }];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10.0);
        make.width.equalTo(self).multipliedBy(0.15);
        make.height.equalTo(self).multipliedBy(0.4);
        make.centerY.equalTo(self);
    }];
    [self.fastPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10.0);
        make.width.equalTo(self).multipliedBy(0.15);
        make.height.equalTo(self).multipliedBy(0.3);
        make.centerY.equalTo(self);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@20.0);
    }];
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        _nextBtn = button;
    }
    return _nextBtn;
}

- (UIButton *)autoPlayBtn {
    if (!_autoPlayBtn) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"auto_play"] forState:UIControlStateNormal];
        _autoPlayBtn = button;
    }
    return _autoPlayBtn;
}

- (UIButton *)fastPlayBtn {
    if (!_fastPlayBtn) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"fast_play"] forState:UIControlStateNormal];
        _fastPlayBtn = button;
    }
    return _fastPlayBtn;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor orangeColor];
        label.text = @"普通模式中...";
        label.font = [UIFont systemFontOfSize:17.0];
        CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(-15 * (CGFloat)M_PI / 180), 1, 0, 0);
        label.transform = matrix;
        label.backgroundColor = [UIColor clearColor];
        _tipLabel = label;
    }
    return _tipLabel;
}



@end
