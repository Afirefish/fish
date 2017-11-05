//
//  CardCell.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/11/2.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

//收集整理卡牌的cell
#import "CardCell.h"
#import "CardSelectedBackground.h"

@implementation CardCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.cardImage= [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, self.frame.size.width - 4, self.frame.size.height - 20)];
        self.cardName = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 18, self.frame.size.width, 18)];
        [self.contentView addSubview:self.cardName];
        [self.contentView addSubview:self.cardImage];
        CardSelectedBackground *cardSelected = [[CardSelectedBackground alloc] initWithFrame:CGRectZero];
        self.selectedBackgroundView = cardSelected;
    }
    return self;
}

@end
