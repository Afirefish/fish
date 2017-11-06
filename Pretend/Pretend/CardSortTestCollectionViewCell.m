//
//  CardSortTestCollectionViewCell.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/11/6.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "CardSortTestCollectionViewCell.h"
#import "CardSelectedBackground.h"

@implementation CardSortTestCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.cardImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.cardName = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 18, self.frame.size.width, 18)];
        [self.contentView addSubview:self.cardName];
        [self.contentView addSubview:self.cardImage];
        CardSelectedBackground *cardSelected = [[CardSelectedBackground alloc] initWithFrame:CGRectZero];
        self.selectedBackgroundView = cardSelected;
    }
    return self;
}

@end
