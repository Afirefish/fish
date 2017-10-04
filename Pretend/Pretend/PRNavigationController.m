//
//  PRNavigationController.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/28.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

//第一个视图的导航控制器
#import "PRNavigationController.h"

@interface PRNavigationController ()

@end

@implementation PRNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarItem.image = [[UIImage imageNamed:@"firstCommunication"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.selectedImage = [[UIImage imageNamed:@"firstCommunication"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.title = [NSString stringWithFormat:@"Fall"];
    [self.navigationBar setTintColor: [UIColor colorWithRed:252.0/255 green:230.0/255 blue:201.0/255 alpha:1.0]];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Courier" size:20],NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}


@end
