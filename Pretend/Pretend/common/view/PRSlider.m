//
//  PRSlider.m
//  Pretend
//
//  Created by daixijia on 2018/2/7.
//  Copyright © 2018年 戴曦嘉. All rights reserved.
//

#import "PRSlider.h"

NS_ASSUME_NONNULL_BEGIN

static CGFloat kExpendSize = 20;

@interface PRSlider () {
CGRect lastBounds;
}

@end

@implementation PRSlider

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    rect.origin.x = rect.origin.x;
    rect.size.width = rect.size.width ;
    CGRect result = [super thumbRectForBounds:bounds trackRect:rect value:value];
    lastBounds = result;
    return result;
}

- (nullable UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event{
    UIView *result = [super hitTest:point withEvent:event];
    if (point.x < 0 || point.x > self.bounds.size.width){
        return result;
    }
    // 如果点击范围在扩展高度之内的话，设置值，返回当前view
    if ((point.y >= -kExpendSize) && (point.y < lastBounds.size.height + lastBounds.origin.y + kExpendSize)) {
        float value = 0.0;
        value = point.x - self.bounds.origin.x;
        value = value/self.bounds.size.width;
        value = value < 0? 0 : value;
        value = value > 1? 1: value;
        value = value * (self.maximumValue - self.minimumValue) + self.minimumValue;
        [self setValue:value animated:YES];
    }
    return result;
}

// 如果点击范围在扩展区域之内的话，返回yes
- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event{
    BOOL result = [super pointInside:point withEvent:event];
    if (!result) {
        if ((point.x >= lastBounds.origin.x - kExpendSize) &&
            (point.y >= lastBounds.origin.y - kExpendSize) &&
            (point.x <= (lastBounds.origin.x + lastBounds.size.width + kExpendSize)) &&
            (point.y <= (lastBounds.origin.y + lastBounds.size.height + kExpendSize))) {
            result = YES;
        }
    }
    return result;
}

@end

NS_ASSUME_NONNULL_END
