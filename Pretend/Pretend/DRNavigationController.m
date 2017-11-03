//
//  DRNavigationController.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/31.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "DRNavigationController.h"

@interface DRNavigationController ()

@end

@implementation DRNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBar setTintColor: [UIColor blackColor]];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Courier" size:20],NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.tabBarItem.image = [[UIImage imageNamed:@"devilRoom"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.selectedImage = [[UIImage imageNamed:@"devilRoom"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.title = [NSString stringWithFormat:@"Room"];
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
