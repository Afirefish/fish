//
//  CardMasonryLayout.h
//  Pretend
//
//  Created by 戴曦嘉 on 2017/11/6.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardMasonryLayout : UICollectionViewLayout
@property (nonatomic, assign) NSUInteger numberOfColumns;
@property (nonatomic, assign) CGFloat interItemSpacing;

@end
