//
//  PuriHandCardCell.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/11/5.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

//对战时的手牌cell
#import "PuriHandCardCell.h"
#import "CardSelectedBackground.h"
#import "PuriHandCardAttributes.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define ITEM_WIDTH 136
#define ITEM_HEIGHT 192

@implementation PuriHandCardCell

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


-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {//重写cell的一些布局属性
    [super applyLayoutAttributes:layoutAttributes];
    CGFloat radius = 500;
    CGFloat anchorPointY = ((ITEM_HEIGHT / 2.0) + radius) / ITEM_HEIGHT;
    CGPoint anchorPoint = CGPointMake(0.5, anchorPointY);//设置cell的旋转中心为cell高度的一半加上半径，除以cell高度（因为在这个坐标系为1*1）
    self.layer.anchorPoint = anchorPoint;
    CGPoint center = self.center;
    center.y += (anchorPoint.y - 0.5) * self.bounds.size.height ;//设定cell的中心点为cell的当前高度加上半径
    self.center = center;
}


@end
