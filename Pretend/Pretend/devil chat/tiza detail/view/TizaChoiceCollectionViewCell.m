//
//  TizaChoiceCollectionViewCell.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/11/8.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "TizaChoiceCollectionViewCell.h"

@implementation TizaChoiceCollectionViewCell

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroudImageView.image = [UIImage imageNamed:@"tizaCastle"];
    }
    return self;
}


@end
