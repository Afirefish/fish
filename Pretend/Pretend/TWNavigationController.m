//
//  TWNavigationController.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/11/1.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "TWNavigationController.h"

@interface TWNavigationController ()

@end

@implementation TWNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBar setTintColor: [UIColor blackColor]];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Courier" size:20],NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.tabBarItem.image = [[UIImage imageNamed:@"trueWorld"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.selectedImage = [[UIImage imageNamed:@"trueWorld"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.title = [NSString stringWithFormat:@"Truth"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {//隐藏tabbar
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
