//
//  PuriLayout.h
//  Pretend
//
//  Created by 戴曦嘉 on 2017/11/2.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PuriLayout : UICollectionViewLayout

@property (nonatomic, assign) CGPoint centre;

@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, assign) CGFloat angularSpacing;

@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

@property (nonatomic, assign) BOOL mirrorX;

@property (nonatomic, assign) BOOL mirrorY;

@property (nonatomic, assign) BOOL rotateItems;

-(void)initWithCentre:(CGPoint)centre radius:(CGFloat)radius itemSize:(CGSize)itemSize andAngularSpacing:(CGFloat)angularSpacing;

-(void)setStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle;

@end
