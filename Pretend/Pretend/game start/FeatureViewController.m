//
//  FeatureViewController.m
//  Pretend
//
//  Created by daixijia on 2018/1/24.
//  Copyright © 2018年 戴曦嘉. All rights reserved.
//

#import "FeatureViewController.h"
#import "PretendedViewController.h"
#import "PRTxtTransform.h"
#import <Masonry.h>

@interface FeatureViewController ()
@property (nonatomic, strong)UIProgressView *progressView;

@end

@implementation FeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupViews];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self transform];
    });
}

- (void)setupViews {
    UIImageView *imageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView;
    });
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    UILabel *stateLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.text = @"正在为初次启动转换文本，请稍候";
        label.font = [UIFont systemFontOfSize:17];
        label.adjustsFontSizeToFitWidth = YES;
        label;
    });
    [self.view addSubview:stateLabel];
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.height.equalTo(@30.0);
    }];
    self.progressView = ({
        UIProgressView *progressView = [[UIProgressView alloc] init];
        progressView;
    });
    [self.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-60.0);
        make.height.equalTo(@40.0);
    }];
}

- (void)transform {
    PRTxtTransform *trans = [[PRTxtTransform alloc] init];
    [trans transNovelToMyTxt];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.progressView.progress = 0.5;
        [trans transTXTToPlist];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.progressView.progress = 1.0;
            [self presentViewController:[[PretendedViewController alloc] init] animated:YES completion:nil];
        });
    });
}

@end
