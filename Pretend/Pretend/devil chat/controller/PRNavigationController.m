//
//  PRNavigationController.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/28.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "PRNavigationController.h"

@interface PRNavigationController ()

@end

@implementation PRNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Courier" size:20],NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.tabBarItem.image = [[UIImage imageNamed:@"littleDevil"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.selectedImage = [[UIImage imageNamed:@"littleDevil"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.title = [NSString stringWithFormat:@"Chat"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {//隐藏tabbar
    if ([viewController isKindOfClass:NSClassFromString(@"BaseChatDetail")] || [viewController isKindOfClass:NSClassFromString(@"DevilChatRoom")]) {
        viewController.hidesBottomBarWhenPushed = YES;
    } else {
        viewController.hidesBottomBarWhenPushed = NO;
    }
    [super pushViewController:viewController animated:animated];
}

@end
