//
//  CardDetailViewController.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/11/2.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "CardDetailViewController.h"
#import <Masonry.h>

@interface CardDetailViewController ()
@property (nonatomic,strong) UIImageView *cardDetail;

@end

@implementation CardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.cardDetail = [[UIImageView alloc] init];
    self.cardDetail.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.cardDetail];
    [self.cardDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        }
        else {
            make.edges.equalTo(self.view);
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated { // 在这里处理可以使动画很平滑
    [super viewWillAppear:animated];
    self.cardDetail.image = self.cardImage;
}

@end
