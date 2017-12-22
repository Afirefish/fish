//
//  CardSelectedBackground.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/11/2.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "CardSelectedBackground.h"

@implementation CardSelectedBackground

- (void)drawRect:(CGRect)rect {
    CGContextRef aRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(aRef);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:2.0f];
    bezierPath.lineWidth = 2.0f;
    [[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0] setStroke];
    UIColor *fillColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    [fillColor setFill];
    [bezierPath stroke];
    [bezierPath fill];
    CGContextRestoreGState(aRef);
}

@end
