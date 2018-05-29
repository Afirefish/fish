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
#import "PRProgressIndicator.h"
#import "PRProgressBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeatureViewController ()<PRProgressDelegate> {
    CGFloat progress;
}

@property (nonatomic, strong, nullable) CADisplayLink *displayLink;
@property (nonatomic, strong) PRProgressIndicator *indicator;
@property (nonatomic, strong) PRProgressBar *progressBar;

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
        imageView.backgroundColor = [UIColor cyanColor];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView;
    });
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    self.progressBar = [[PRProgressBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, 50, 80)];
    self.progressBar.offsetY = 20;
    self.progressBar.delegate = self;
    [self.view addSubview:self.progressBar];
    
    self.indicator = [[PRProgressIndicator alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 90, 48, 60)];
    self.indicator.offsetY = 30;
    self.indicator.delegate = self;
    [self.view addSubview:self.indicator];
    
    [self.progressBar generateReadyStyle];
    [self.indicator generateReadyStyle];
    
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

}

- (void)transform {
    [self.progressBar generateRunningStyle];
    [self.indicator generateRunningStyle];
    
    PRTxtTransform *trans = [[PRTxtTransform alloc] init];
    
    if ([trans transNovelToMyTxt]) {
        [trans transTXTToPlist];
    }
    else {
        [self.progressBar generateFailStyle];
        [self.indicator generateFailStyle];
    }

}

- (void)progressView:(PRProgressBaseView *)progressView changedState:(ProgressState)state {
    // 仅当bar时更新state
    if (progressView == self.progressBar) {
        [self stateDidChanged:state];
    }
}

// 刷新进度条
- (void)stateDidChanged:(ProgressState)state {
    // 当当前是运行状态的时候，开始进度条的动画
    if (state == PRProgressStateRunning) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(setProgress:) ];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    // 当加载失败，成功的时候，移除设置进度条的操作
    else if (state == PRProgressStatefailAnim || state == PRProgressStateSuccess) {
        if (self.displayLink) {
            [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            self.displayLink = nil;
        }
    }
}

// 设置当前进度
-(void)setProgress:(id)sender{
    if (progress > 100.f) {
        [self.indicator setProgress:1];
        [self.progressBar setProgress:1];
        [sender removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        progress = 0;
        
        PRVideoViewController *videoVC = [[PRVideoViewController alloc] initWithOpeningAnimate:YES];
        [self addChildViewController:videoVC]; // 1
        [self.view addSubview:videoVC.view]; // 2
        [videoVC didMoveToParentViewController:self]; // 3
        
        return;
    }
    [self.indicator setProgress:progress/100.f];
    [self.progressBar setProgress:progress/100.f];
    if (progress < 10) {
        progress += 1;
    }
    else if (progress>=10 && progress <20) {
        progress += 1;
    }
    else if (progress>=20 && progress <30) {
        progress += 0.2;
    }
    else if (progress>=30 && progress <40) {
        progress += 0.2;
    }
    else if (progress>=40 && progress <50) {
        progress += 1.5;
    }
    else if (progress>=50 && progress <60) {
        progress += 1.5;
    }
    else if (progress>=60 && progress <70) {
        progress += 1.5;
    }
    else if (progress>=70 && progress <80) {
        progress += 1.5;
    }
    else if (progress>=80 && progress <90) {
        progress += 1.5;
    }
    else {
        progress += 1.5;
    }
}

- (void)stopPlay:(void (^ __nullable)(void))completion {
    PretendedViewController *rootVC = [[PretendedViewController alloc] init];
    [self presentViewController:rootVC animated:YES completion:^{
        [self removeFromParentViewController];
        if (completion) {
            completion();
        }
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
    return UIInterfaceOrientationLandscapeRight;
}

@end

NS_ASSUME_NONNULL_END
