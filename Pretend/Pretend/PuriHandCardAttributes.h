//
//  PuriHandCardAttributes.h
//  Pretend
//
//  Created by 戴曦嘉 on 2017/11/3.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

//重载了attributes，增加旋转中心和角度的属性
#import <UIKit/UIKit.h>

@interface PuriHandCardAttributes : UICollectionViewLayoutAttributes
@property (assign,nonatomic) CGPoint anchorPoint;
@property (assign,nonatomic) CGFloat angle;

@end
