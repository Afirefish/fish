//
//  CardDetailViewController.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/11/2.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "CardDetailViewController.h"

@interface CardDetailViewController ()
@property (nonatomic,strong) UIImageView *cardDetail;

@end

@implementation CardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0];
    CGFloat width = (self.view.bounds.size.height - 64) * 68 / 96;
    CGFloat height = self.view.bounds.size.width * 96 / 68;
    if (width <= self.view.bounds.size.width) {
        height = self.view.bounds.size.height - 64;
    } else if (height <= self.view.bounds.size.height - 64) {
        width = self.view.bounds.size.width;
    } else {
        NSLog(@"图片适配失败");
    }
    //NSLog(@"height %f width %f nap %f",height,width,(self.view.bounds.size.height - height - 64)/2);
    self.cardDetail = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - width)/2, (self.view.bounds.size.height - height - 64)/2 + 64, width, height)];
    [self.view addSubview:self.cardDetail];
}

- (void)viewWillAppear:(BOOL)animated {//在这里处理可以使动画很平滑
    [super viewWillAppear:animated];
    self.cardDetail.image = self.cardImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
