//
//  DCNavigationController.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/30.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "DCNavigationController.h"

@interface DCNavigationController ()

@end

@implementation DCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBar setTintColor: [UIColor blackColor]];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Courier" size:20],NSForegroundColorAttributeName:[UIColor blackColor]}];
    //一些tabbar的基础设置
    self.tabBarItem.image = [[UIImage imageNamed:@"devilCard"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.selectedImage = [[UIImage imageNamed:@"devilCard"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.title = [NSString stringWithFormat:@"Card"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {//隐藏tabbar
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
//    if ([viewController isKindOfClass:NSClassFromString(@"CardFeastViewController")]) {
//        viewController.hidesBottomBarWhenPushed = NO;
//    }
    [super pushViewController:viewController animated:animated];
}

@end
