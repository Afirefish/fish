//
//  FeatureViewController.m
//  Pretend
//
//  Created by daixijia on 2018/1/24.
//  Copyright © 2018年 戴曦嘉. All rights reserved.
//

#import "FeatureViewController.h"
#import "PretendedViewController.h"
#import "PRVideoViewController.h"
#import "PRTxtTransform.h"
#import <Masonry.h>

@interface FeatureViewController ()

@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation FeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *bundleVersionKey = (NSString *)kCFBundleVersionKey;
    NSString *bundleVersion = [NSBundle mainBundle].infoDictionary[bundleVersionKey];
    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:bundleVersionKey];
    if ([bundleVersion isEqualToString:saveVersion]) {
        // 直接播放开场动画
        PRVideoViewController *videoVC = [[PRVideoViewController alloc] initWithOpeningAnimate:YES];
        [self addChildViewController:videoVC]; // 1
        [self.view addSubview:videoVC.view]; // 2
        [videoVC didMoveToParentViewController:self]; // 3
    }
    else {
        [[NSUserDefaults  standardUserDefaults] setObject:bundleVersion forKey:bundleVersionKey];
        [[NSUserDefaults  standardUserDefaults] synchronize];
        [self setupViews];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self transform];
        });
    }
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
        UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        progressView.backgroundColor = [UIColor grayColor];
        progressView.progressTintColor = [UIColor blackColor];
        progressView.trackTintColor = [UIColor grayColor];
        progressView;
    });
    [self.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-60.0);
        make.height.equalTo(@10.0);
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
            PRVideoViewController *videoVC = [[PRVideoViewController alloc] initWithOpeningAnimate:YES];
            [self addChildViewController:videoVC]; // 1
            [self.view addSubview:videoVC.view]; // 2
            [videoVC didMoveToParentViewController:self]; // 3
        });
    });
}

- (void)stopPlay {
    PretendedViewController *rootVC = [[PretendedViewController alloc] init];
    [self presentViewController:rootVC animated:YES completion:^{
        [self removeFromParentViewController];
    }];
}

#pragma mark - rotate control

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
}

@end
