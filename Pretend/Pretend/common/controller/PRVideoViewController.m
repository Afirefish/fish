//
//  PRVideoViewController.m
//  Pretend
//
//  Created by daixijia on 2018/2/7.
//  Copyright © 2018年 戴曦嘉. All rights reserved.
//

#import "PRSlider.h"
#import "PRVideoViewController.h"
#import "FeatureViewController.h"

NS_ASSUME_NONNULL_BEGIN

static CGFloat kRoundSize = 4.0;
static CGFloat kControlSpaceS = 5.0;
static CGFloat kButtonHeight = 40.0;

static int PRKVOContext = 0;

/**
 用于判断  是否横屏模式
 */
static inline BOOL PRIsHorizontalUI(id<UITraitEnvironment> traitEnvironment) {
    return !(traitEnvironment.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact
             && traitEnvironment.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular);
}

@interface PRVideoViewController ()

@property (nonatomic, assign) BOOL isOpeningAnimate;

@property (nonatomic, strong, nullable) AVPlayer *player;
@property (nonatomic, strong, nullable) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) NSURL *musicURL;

@property (nonatomic, strong) UIView *playControlsView;
@property (nonatomic, strong) UIView *playerView;
@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, strong) UIButton *exitBtn;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) PRSlider *slider;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *fullScreenBtn;

@property (nonatomic, assign) CGFloat durationSeconds;
@property (nonatomic, strong) NSString *currentTime;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, assign) BOOL isFinish;
@property (nonatomic, assign) BOOL isFull;
@property (nonatomic, assign) BOOL isHide;
@property (nonatomic, assign) BOOL isPlayWhenEnterBackgroud;

@property (nonatomic, strong) CADisplayLink *link;

@end

@implementation PRVideoViewController

- (instancetype)initWithOpeningAnimate:(BOOL)isOpeningAnimate {
    if (self = [super init]) {
        self.isOpeningAnimate = isOpeningAnimate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupPlayer];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (!self.isOpeningAnimate) {
        [self removeNotify];
        [self removeAllObserver];
    }
    [super viewWillDisappear:animated];
}

#pragma mark - subviews

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat statusBarHeight = MAX(20.0, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame));
    
    // 播放控件视图
    self.playControlsView = [[UIView alloc] init];
    [self.view addSubview:self.playControlsView];
    [self.playControlsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 播放视图
    self.playerView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    [self.playControlsView addSubview:self.playerView];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.playControlsView);
        make.top.equalTo(self.playControlsView).offset(statusBarHeight);
        make.height.equalTo(@(screenWidth));
    }];
    
    // 如果是开场动画，则不需要其他控制
    if (self.isOpeningAnimate) {
        return;
    }
    
    // 退出按钮
    self.exitBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.backgroundColor = [UIColor blackColor];
        button.layer.cornerRadius = kRoundSize;
        button.clipsToBounds = YES;
        [button setImage:[UIImage imageNamed:@"exit"] forState:UIControlStateNormal];
        button;
    });
    [self.playControlsView addSubview:self.exitBtn];
    [self.exitBtn addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [self.exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.playerView).offset(- kControlSpaceS);
        make.top.equalTo(self.playerView).offset(kControlSpaceS);
        make.width.height.equalTo(@(kButtonHeight));
    }];
    
    self.overlayView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor blackColor];
        view;
    });
    [self.playControlsView addSubview:self.overlayView];
    [self.overlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(kButtonHeight));
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.playerView).offset(- kControlSpaceS);
    }];
    
    // 播放暂停按钮
    self.playBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.backgroundColor = [UIColor clearColor];
        button.layer.cornerRadius = kRoundSize;
        button.clipsToBounds = YES;
        [button setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
        button.selected = NO;
        button;
    });
    self.isPlay = NO;
    self.isFinish = NO;
    [self.playControlsView addSubview:self.playBtn];
    [self.playBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playerView).offset(kControlSpaceS);
        make.bottom.equalTo(self.playerView).offset(- kControlSpaceS);
        make.width.height.equalTo(@(kButtonHeight));
    }];
    
    // 全屏按钮
    self.fullScreenBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.backgroundColor = [UIColor clearColor];
        button.layer.cornerRadius = kRoundSize;
        button.clipsToBounds = YES;
        [button setImage:[UIImage imageNamed:@"fullscreen"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"window"] forState:UIControlStateSelected];
        button.selected = NO;
        button;
    });
    self.isFull = NO;
    [self.playControlsView addSubview:self.fullScreenBtn];
    [self.fullScreenBtn addTarget:self action:@selector(playWithFullOrWindowScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.playerView).offset(- kControlSpaceS);
        make.width.height.equalTo(@(kButtonHeight));
    }];
    
    // 时间标签
    self.timeLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor whiteColor];
        label.text = @"当前时间/总时间";
        label.font = [UIFont systemFontOfSize:16.0];
        label.adjustsFontSizeToFitWidth = YES;
        label.layer.cornerRadius = kRoundSize;
        label.clipsToBounds = YES;
        label;
    });
    [self.playControlsView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.fullScreenBtn.mas_left).offset(- kControlSpaceS);
        make.top.equalTo(self.fullScreenBtn);
        make.width.equalTo(@(2 * kButtonHeight));
        make.height.equalTo(@(kButtonHeight));
    }];
    
    // 播放进度滑块
    self.slider = ({
        PRSlider *slider = [[PRSlider alloc] init];
        slider.backgroundColor = [UIColor clearColor];
        slider.minimumTrackTintColor = [UIColor orangeColor];
        slider.maximumTrackTintColor = [UIColor grayColor];
        slider.continuous = YES;
        slider;
    });
    [self.playControlsView addSubview:self.slider];
    [self.slider addTarget:self action:@selector(seekTime) forControlEvents:UIControlEventValueChanged];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playBtn.mas_right).offset(kControlSpaceS * 2.0);
        make.right.equalTo(self.timeLabel.mas_left).offset(- kControlSpaceS);
        make.top.equalTo(self.fullScreenBtn.mas_centerY);
        make.height.equalTo(@(2.0));
    }];
    
    self.isHide = NO;
}

// 每次调用update会改变全屏的状态
- (void)updateViewWithFullScreen:(BOOL)isFull {
    CGFloat statusBarHeight = MAX(20.0, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame));
    // 旋转之后的界面如果是竖直的，就设置为全屏
    if (isFull) {
        self.isFull = YES;
        self.fullScreenBtn.selected = YES;
    }
    // 旋转之后的界面如果是水平的，设置为窗口
    else {
        self.isFull = NO;
        self.fullScreenBtn.selected = NO;
    }
    if (isFull) {
        self.playerLayer.frame = self.view.frame;
        [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.playControlsView);
        }];
        if (!self.isOpeningAnimate) {
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideControls)];
            [self.view addGestureRecognizer:gesture];
        }
    }
    else {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        self.playerLayer.frame = CGRectMake(0, 0, width, width);
        [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.playControlsView);
            make.top.equalTo(self.playControlsView).offset(statusBarHeight);
            make.height.equalTo(@(width));
        }];
        if (!self.isOpeningAnimate) {
            for (UIGestureRecognizer *gesture in self.view.gestureRecognizers.copy) {
                if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
                    [self.view removeGestureRecognizer:gesture];
                }
            }
            [self showAllControls];
        }
    }
}

#pragma mark - observer

- (void)addAllObserver {
    [self addObserver:self forKeyPath:@"player.currentItem.duration" options:NSKeyValueObservingOptionNew context:&PRKVOContext];
    
    //     对于不支持kvo的当前时间，用nstimer或者CADisplayLink来刷新
    
    // 这个是通过加入runloop之中，与屏幕刷新频率同步来刷新数据
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateCurrentTime)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    //  一、这个是个block的方式创建了一个nstimer，通过这个来刷新播放当前时间
    //        __weak __typeof(self) weakSelf = self;
    //        [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1)
    //                                                  queue:dispatch_get_main_queue()
    //                                             usingBlock:^(CMTime time) {
    //                                                 //当前播放的时间
    //                                                 __strong __typeof(self) strongSelf = weakSelf;
    //                                                 CGFloat newCurrentSeconds = CMTimeGetSeconds(time);
    //                                                 NSInteger wholeMinutes = (NSInteger)trunc(newCurrentSeconds / 60);
    //                                                 strongSelf.currentTime = [NSString stringWithFormat:@"%02ld:%02ld", (long)wholeMinutes, (NSInteger)trunc(newCurrentSeconds) - wholeMinutes * 60];
    //                                                 strongSelf.timeLabel.text = [NSString stringWithFormat:@"%@/%@", strongSelf.currentTime, strongSelf.duration];
    //                                             }];
    
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey,id> *)change context:(nullable void *)context {
    if (context != &PRKVOContext) {
        // KVO isn't for us.
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    // 总时长
    if ([keyPath isEqualToString:@"player.currentItem.duration"]) {
        NSValue *newDurationAsValue = change[NSKeyValueChangeNewKey];
        CMTime newDuration = [newDurationAsValue isKindOfClass:[NSValue class]] ? newDurationAsValue.CMTimeValue : kCMTimeZero;
        BOOL hasValidDuration = CMTIME_IS_NUMERIC(newDuration) && newDuration.value != 0;
        CGFloat newDurationSeconds = hasValidDuration ? CMTimeGetSeconds(newDuration) : 0.0;
        self.durationSeconds = newDurationSeconds;
        self.slider.maximumValue = newDurationSeconds;
        NSInteger wholeMinutes = (NSInteger)trunc(newDurationSeconds / 60);
        self.duration = [NSString stringWithFormat:@"%02ld:%02ld", (long)wholeMinutes, (unsigned long)trunc(newDurationSeconds) - wholeMinutes * 60];
        if (!self.currentTime) {
            self.currentTime = @"00:00";
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.timeLabel.text = [NSString stringWithFormat:@"%@/%@", self.currentTime, self.duration];
        });
    }
    //系统的播放器的当前时间不支持kvo
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)removeAllObserver {
    [self removeObserver:self forKeyPath:@"player.currentItem.duration" context:&PRKVOContext];
}

#pragma mark - Notification

- (void)addNotify {
    if (self.isOpeningAnimate) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDidStop) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseWhenEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseWhenEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeWhenEnterForegrund) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeWhenEnterForegrund) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateViewConstraints) name:UIDeviceOrientationDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinish) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
}

- (void)removeNotify {
    if (self.isOpeningAnimate) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    }
}

- (void)pauseWhenEnterBackground {
    self.isPlayWhenEnterBackgroud = self.isPlay;
    if (self.isPlay) {
        [self.player pause];
    }
}

- (void)resumeWhenEnterForegrund {
    self.isPlay = self.isPlayWhenEnterBackgroud;
    if (self.isPlay) {
        [self.player play];
    }
}

#pragma mark - player

// 初始化播放器
- (void)setupPlayer {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.videoURL = [[NSBundle mainBundle] URLForResource:@"video" withExtension:@"mp4"];
    self.playerItem = [AVPlayerItem playerItemWithURL:self.videoURL];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = CGRectMake(0, 0, width, width);
    [self.playerView.layer addSublayer:self.playerLayer];
    [self addNotify];
    if (self.isOpeningAnimate) {
        [self playVideo];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playDidStop)];
        [self.view addGestureRecognizer:gesture];
    }
    else {
        [self addAllObserver];
    }
}

// 播放视频
- (void)playVideo {
    if (self.isFinish) {
        self.isFinish = NO;
        self.slider.value = 0;
        [self seekTime];
    }
    if (self.isPlay) {
        [self.player pause];
        self.isPlay = NO;
        self.playBtn.selected = NO;
    }
    else {
        [self.player play];
        self.isPlay = YES;
        self.playBtn.selected = YES;
    }
}

- (void)playFinish {
    self.playBtn.selected = NO;
    self.isPlay = NO;
    self.isFinish = YES;
}

- (void)playDidStop {
    if([self.parentViewController isKindOfClass:[FeatureViewController class]]) {
        __weak typeof(self) weakSelf = self;
        [(FeatureViewController *)self.parentViewController stopPlay:^{
            __strong __typeof(self) strongSelf = weakSelf;
            [strongSelf.player pause];
            strongSelf.player = nil;
            strongSelf.playerItem = nil;
            [strongSelf.link invalidate];
            [strongSelf.playerView removeFromSuperview];
            [strongSelf willMoveToParentViewController:nil]; // 1
            [strongSelf.view removeFromSuperview]; // 2
            [strongSelf removeFromParentViewController]; // 3
        }];
    }
}

- (void)hideControls {
    self.isHide = !self.isHide;
    self.overlayView.hidden = self.isHide;
    self.playBtn.hidden = self.isHide;
    self.exitBtn.hidden = self.isHide;
    self.fullScreenBtn.hidden = self.isHide;
    self.timeLabel.hidden = self.isHide;
    self.slider.hidden = self.isHide;
}

- (void)showAllControls {
    self.isHide = NO;
    self.overlayView.hidden = NO;
    self.playBtn.hidden = NO;
    self.exitBtn.hidden = NO;
    self.fullScreenBtn.hidden = NO;
    self.timeLabel.hidden = NO;
    self.slider.hidden = NO;
}

- (void)exit {
    [self.player pause];
    self.player = nil;
    self.playerItem = nil;
    [self.link invalidate];
    [self.playerView removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 跳转到某个时间点
- (void)seekTime {
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        if (self.isFinish) {
            self.isFinish = NO;
        }
        CGFloat value = self.slider.value;
        CMTime time = CMTimeMake(value, 1);
        __weak __typeof(self) weakSelf = self;
        [self.player seekToTime:time completionHandler:^(BOOL finished) {
            __strong __typeof(self) strongSelf = weakSelf;
            [strongSelf updateCurrentTime];
        }];
    }
}

// 更新当前时间
- (void)updateCurrentTime {
    CGFloat newCurrentSeconds = CMTimeGetSeconds(self.player.currentItem.currentTime);
    NSInteger wholeMinutes = (NSInteger)trunc(newCurrentSeconds / 60);
    self.currentTime = [NSString stringWithFormat:@"%02ld:%02ld", (long)wholeMinutes, (unsigned long)trunc(newCurrentSeconds) - wholeMinutes * 60];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.timeLabel.text = [NSString stringWithFormat:@"%@/%@", self.currentTime, self.duration];
        if (self.durationSeconds) {
            self.slider.value = newCurrentSeconds;
        }
    });
}

// 全屏或者非全屏播放按钮点击之后的布局
- (void)playWithFullOrWindowScreen {
    BOOL isHorizontal = PRIsHorizontalUI(self);
    if (isHorizontal) {
        [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
    }
    else {
        [[UIDevice currentDevice] setValue:@(UIDeviceOrientationLandscapeRight) forKey:@"orientation"];
    }
    [self updateViewConstraints];
}

// 这里是旋转通知导致的更新布局
- (void)updateViewConstraints {
    BOOL isHorizontal = PRIsHorizontalUI(self);
    [self updateViewWithFullScreen:isHorizontal];
    [super updateViewConstraints];
}

#pragma mark - status bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - rotate control

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end

NS_ASSUME_NONNULL_END
