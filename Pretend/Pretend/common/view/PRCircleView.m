//
//  PRCircleView.m
//  Pretend
//
//  Created by xijia dai on 2019/9/10.
//  Copyright © 2019 戴曦嘉. All rights reserved.
//

#import "PRCircleView.h"

@interface PRCircleView ()

@property (nonatomic) CAShapeLayer *circleLayer;
@property (nonatomic) UIColor *fillColor;
@property (nonatomic) UIColor *borderColor;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) CGFloat width;

@end

@implementation PRCircleView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithRadius:300.0 color:[UIColor redColor]];
}

- (instancetype)initWithRadius:(CGFloat)radius color:(UIColor *)color {
    if (self = [super initWithFrame:CGRectZero]) {
        self.borderColor = [UIColor whiteColor];
        self.borderWidth = 1.0;
        self.width = 40.0;
        
        self.fillColor = color;
        self.radius = radius;
        [self drawCircleLayer];
    }
    return self;
}

// TODO: 需要一个可行的数据计算方式，目前暂不去考虑
- (void)drawCircleLayer {
    self.backgroundColor = [UIColor clearColor];
    
    self.circleLayer = [CAShapeLayer layer];
    self.circleLayer.masksToBounds = YES;
    self.circleLayer.frame = CGRectMake(0.0, 0.0, self.radius, self.radius);
    self.circleLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.circleLayer.lineCap = kCALineCapRound;
    self.circleLayer.lineJoin = kCALineJoinRound;
    self.circleLayer.strokeColor = self.borderColor.CGColor;
    self.circleLayer.fillColor = self.fillColor.CGColor;
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(self.radius, 0.0)];
    [path addLineToPoint:CGPointMake(self.radius - self.width, 0.0)];
    
    [path addArcWithCenter:CGPointMake(40, -250.0) radius:self.radius - self.width startAngle:M_PI * 1 / 3 endAngle:M_PI * 2 / 3 clockwise:YES];
    
    [path moveToPoint:CGPointMake(0.0, self.radius - self.width - 200.0)];
    [path addLineToPoint:CGPointMake(0.0, self.radius - 200.0)];
    
    [path addArcWithCenter:CGPointMake(40, -250.0) radius:self.radius startAngle:M_PI * 2 / 3 endAngle:M_PI * 1 / 3 clockwise:NO];
    
    self.circleLayer.path = path.CGPath;
    [self.layer addSublayer:self.circleLayer];
}

@end
