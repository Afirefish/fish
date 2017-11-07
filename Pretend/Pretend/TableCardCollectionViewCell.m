//
//  TableCardCollectionViewCell.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/11/7.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "TableCardCollectionViewCell.h"
#import "CardSelectedBackground.h"

@implementation TableCardCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.cardImage= [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, self.frame.size.width - 4, self.frame.size.height)];
        [self.contentView addSubview:self.cardImage];
        CardSelectedBackground *cardSelected = [[CardSelectedBackground alloc] initWithFrame:CGRectZero];
        self.selectedBackgroundView = cardSelected;
    }
    return self;
}

@end
