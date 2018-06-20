//
//  CardCrafterCell.m
//  Pretend
//
//  Created by daixijia on 2017/12/25.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "CardCrafterCell.h"
#import <Masonry.h>

@implementation CardCrafterCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

@end
