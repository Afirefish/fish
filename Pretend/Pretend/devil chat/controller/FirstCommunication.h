//
//  FirstCommunication.h
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/27.
//  Copyright © 2017年 戴曦嘉. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 第一个界面，初始化文本，提供进入游戏的方法，提供跳过方法
 */

@interface FirstCommunication : UIViewController

@property (nonatomic, strong) UIButton *skipButton;
@property (nonatomic, strong) UIButton *animateButton;
@property (nonatomic, strong) UIImageView *backgroudImageView;
- (instancetype)initWithFirstSence;

@end

NS_ASSUME_NONNULL_END
