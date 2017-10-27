//
//  ChooseRespondToDevil.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/29.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "ChooseRespondToDevil.h"

@interface ChooseRespondToDevil()

@end

@implementation ChooseRespondToDevil

//初始化选择条，设置颜色和按钮
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
        self.chooseRespond = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self.chooseRespond setTitle:@"Responder?" forState:UIControlStateNormal];
        [self.chooseRespond setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:self.chooseRespond];
    }
    return self;
}



@end
