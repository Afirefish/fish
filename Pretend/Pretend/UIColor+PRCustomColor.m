//
//  UIColor+PRCustomColor.m
//  Pretend
//
//  Created by daixijia on 2017/12/13.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "UIColor+PRCustomColor.h"

@implementation UIColor (PRCustomColor)

+ (instancetype)warmGrayColor {
    return [self colorWithRed:225.0/255 green:225.0/255 blue:225.0/255 alpha:1.0];
}

+ (instancetype)warmShellColor {
    return [self colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
}

+ (instancetype)lightBlueColor {
    return [self colorWithRed:240.0/255 green:248.0/255 blue:255.0/255 alpha:1.0];
}

+ (instancetype)smokeWhiteColor {
    return [self colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0];
}

@end
