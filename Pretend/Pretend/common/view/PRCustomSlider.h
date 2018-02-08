//
//  PRCustomSlider.h
//  Pretend
//
//  Created by daixijia on 2018/2/7.
//  Copyright © 2018年 戴曦嘉. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PRSliderDirection){
    PRSliderDirectionHorizonal  =   0,
    PRSliderDirectionVertical   =   1
};

@interface PRCustomSlider : UIControl

@property (nonatomic, assign) CGFloat minValue;//最小值
@property (nonatomic, assign) CGFloat maxValue;//最大值
@property (nonatomic, assign) CGFloat value;//滑动值
@property (nonatomic, assign) CGFloat sliderPercent;//滑动百分比
@property (nonatomic, assign) CGFloat progressPercent;//缓冲的百分比
@property (nonatomic, assign) BOOL isSliding;//是否正在滑动  如果在滑动的是偶外面监听的回调不应该设置sliderPercent progressPercent 避免绘制混乱
@property (nonatomic, assign) PRSliderDirection direction;//方向

- (id)initWithFrame:(CGRect)frame direction:(PRSliderDirection)direction;

@end
