//
//  PRProgressIndicator.m
//  Pretend
//
//  Created by daixijia on 2018/5/28.
//  Copyright © 2018年 戴曦嘉. All rights reserved.
//

#import "PRProgressIndicator.h"

#define kReadyAnimateDuration 0.5
#define kIndicatorWidth self.frame.size.width
#define kIndicatorHeight self.frame.size.height
#define kSmallConrnerRadius kIndicatorWidth / 10
#define kLargeCornerRadius kIndicatorHeight / 10
#define kSmallSpace kIndicatorWidth / 5
#define kMediumSpace kIndicatorHeight / 3
#define kLargeSpace 60.0

@interface PRProgressIndicator () <POPAnimationDelegate>

@property (nonatomic, assign) CGFloat moveLength; // 进度条可以移动的距离
@property (nonatomic, strong) CALayer *topLayer; // 箭头
@property (nonatomic, strong) CAShapeLayer *bottomLayer; // 箭尾
@property (nonatomic, strong) UILabel *percentageLabel; // 加载进度百分比的数值标签
//@property (nonatomic, strong) CADisplayLink *displayLink; // 刷新循环
@property (nonatomic, assign) CGFloat lastCenterX; // x中心
@property (nonatomic, assign) CGFloat currentVelocity; // 当前的倾斜角度

@end

@implementation PRProgressIndicator

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self generateOriginalStyle];
    }
    return self;
}

/**
 这里初始化了一个图形，目前是一个箭头，可以改变
 箭头和箭尾各占一半高度，箭尾宽度为视图的一半
 */
- (void)generateOriginalStyle {
    [super generateOriginalStyle];
    self.topLayer = [CALayer layer];
    self.topLayer.backgroundColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
    self.topLayer.position = CGPointMake(kIndicatorWidth / 2.0, kIndicatorHeight / 4.0);
    self.topLayer.bounds = CGRectMake(0, 0, kIndicatorWidth / 2.0, kIndicatorHeight / 2.0);
    self.topLayer.cornerRadius = kSmallConrnerRadius;
    [self.layer addSublayer:self.topLayer];
    
    self.bottomLayer = [CAShapeLayer layer];
    UIBezierPath *bottomBezierPath = [UIBezierPath bezierPath];
    [bottomBezierPath moveToPoint:CGPointMake(0, kIndicatorHeight / 2.0 - kSmallSpace)];
    [bottomBezierPath addLineToPoint:CGPointMake(kIndicatorWidth, kIndicatorHeight / 2.0 - kSmallSpace)];
    [bottomBezierPath addLineToPoint:CGPointMake(kIndicatorWidth / 2.0, kIndicatorHeight)];
    [bottomBezierPath closePath];
    self.bottomLayer.path = bottomBezierPath.CGPath;
    self.bottomLayer.fillColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
    [self.layer addSublayer:self.bottomLayer];
    
    self.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.moveLength = [UIScreen mainScreen].bounds.size.width - kStartSpace * 2;
}

// !!!:展示一个开始的动画
- (void)generateReadyStyle {
    [super generateReadyStyle];
    [self startReadyAnimate];
}

// !!!:展示一个运行的动画
- (void)generateRunningStyle {
    [super generateRunningStyle];
    [self startRunningAnimate];
}

// !!!:加载失败的动画
- (void)generateFailStyle {
    [super generateFailStyle];
    [self startFailAnimate];
}

#pragma mark - animate

- (void)startReadyAnimate {
    // top layer size 的变化的动画，箭尾转换成进度框样式，高度缩小为视图的三分之一
    POPBasicAnimation *topScaleAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerSize];
    topScaleAnim.toValue = [NSValue valueWithCGSize:CGSizeMake(kIndicatorWidth - kStartSpace, kIndicatorHeight / 3.0)];
    topScaleAnim.duration = kReadyAnimateDuration;
    [self.topLayer pop_addAnimation:topScaleAnim forKey:@"IndiReadyStyleTopScaleAnim"];
    
    // top layer position 的变化的动画，位置纵坐标偏移，确保与箭头连接
    POPBasicAnimation *topPositionAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
    topPositionAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(kIndicatorWidth / 2.0, kIndicatorHeight - kSmallSpace)];
    topPositionAnim.duration = kReadyAnimateDuration;
    [self.topLayer pop_addAnimation:topPositionAnim forKey:@"IndiReadyStyleTopPositionAnim"];
    
    // top layer corner radius 的变化动画
    POPBasicAnimation *topCornerAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerCornerRadius];
    topCornerAnim.toValue = @(kLargeCornerRadius);
    topCornerAnim.duration = kReadyAnimateDuration;
    [self.topLayer pop_addAnimation:topCornerAnim forKey:@"IndiReadyStyleTopCornerAnim"];
    
    // bottom x y 缩放比例的动画，箭头缩小成之前的四分之一
    POPBasicAnimation *bottomScaleAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    bottomScaleAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(0.25, 0.25)];
    bottomScaleAnim.duration = kReadyAnimateDuration;
    [self.bottomLayer pop_addAnimation:bottomScaleAnim forKey:@"IndiReadyStyleTopScaleAnim"];
    
    // bottom position 的动画，箭头和箭尾连接
    POPBasicAnimation *bottomPositionAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
    bottomPositionAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(kIndicatorWidth / 2.0 - kIndicatorWidth / 8.0, kIndicatorHeight - kSmallSpace)];
    bottomPositionAnim.duration = kReadyAnimateDuration;
    [self.bottomLayer pop_addAnimation:bottomPositionAnim forKey:@"IndiReadyStyleBottomPositionAnim"];
    
    // 整体视图的position动画，y轴坐标向上偏移自己frame的一半距离
    POPBasicAnimation *allPositionAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
    allPositionAnim.toValue =  [NSValue valueWithCGPoint:CGPointMake(kStartSpace, self.frame.origin.y - self.offsetY)];
    allPositionAnim.duration = kReadyAnimateDuration / 2.0;
    allPositionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    allPositionAnim.name = @"IndiReadyStyleAllPositionAnimIn";
    allPositionAnim.delegate = self;
    [self.layer pop_addAnimation:allPositionAnim forKey:@"IndiReadyStyleAllPositionYAnimIn"];
}

// 增加一个显示进度的标签
- (void)startRunningAnimate {
    self.percentageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kStartSpace / 2.0, 2 * kIndicatorHeight / 3.0, kIndicatorWidth - kStartSpace, kIndicatorHeight / 3.0)];
    [self.percentageLabel setText:@"0%"];
    [self.percentageLabel setTextAlignment:NSTextAlignmentCenter];
    [self.percentageLabel setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
    [self.percentageLabel setFont:[UIFont systemFontOfSize:11.0]];
    self.percentageLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.percentageLabel];
    
    self.lastCenterX = kStartSpace;
}

// 更新进度条,刷新标签的值，刷新标签倾斜度
-(void)setProgress:(CGFloat)progress{
    [super setProgress:progress];
    [self.percentageLabel setText:[NSString stringWithFormat:@"%d%%",(int)(100 * progress)]];
    [self setCenter:CGPointMake(kStartSpace + self.moveLength * progress, self.center.y)];
    // 当前速度转化成倾斜度的动画
    CGFloat velocity = (self.center.x - self.lastCenterX) / self.moveLength;
    self.currentVelocity = velocity;
    POPSpringAnimation *shakeAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    CGFloat factor = 0.2 < self.currentVelocity * 10 ? 0.2 : self.currentVelocity * 10;
    shakeAnim.toValue = @(- M_PI * factor);
    shakeAnim.springBounciness = 20;
    [self.layer pop_addAnimation:shakeAnim forKey:@"IndiRunStyleShakeAnim"];
    self.lastCenterX = self.center.x;
    
    // 当加载进度为1的时候，移除刷新循环，显示成功的动画
    if (progress == 1) {
        [self.layer pop_removeAnimationForKey:@"IndiRunStyleShakeAnim"];
        POPSpringAnimation *successShakeAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
        successShakeAnim.toValue = @0;
        successShakeAnim.springSpeed = 8;
        successShakeAnim.springBounciness = 18;
        [self.layer pop_addAnimation:successShakeAnim forKey:@"IndiSuccessStyleShakeAnim"];
        [successShakeAnim setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
            self.progressState = PRProgressStateSuccess;
        }];
    }
}

// 加载失败的动画
- (void)startFailAnimate {
    [self.layer pop_removeAnimationForKey:@"IndiRunStyleShakeAnim"];
    // 增加rotation动画
    POPSpringAnimation *shakeAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    shakeAnim.toValue = @0;
    shakeAnim.springBounciness = 20;
    [self.layer pop_addAnimation:shakeAnim forKey:@"IndiFailStyleShakeToMidAnim"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
        [self.percentageLabel setText:@"failed"];
        [self.percentageLabel setTextColor:[UIColor redColor]];
        [self.percentageLabel setFont:[UIFont systemFontOfSize:11.0]];
        [self startFailStyleAnimationWithCompletion:^{
            self.progressState = PRProgressStatefailed;
        }];
        
    });
}

// 失败的动画
-(void)startFailStyleAnimationWithCompletion:(void(^)(void))completion{
    POPSpringAnimation *shakeAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    shakeAnim.toValue = @(M_PI*0.11);
    shakeAnim.springSpeed = 8;
    shakeAnim.springBounciness = 18;
    [self.layer pop_addAnimation:shakeAnim forKey:@"IndiFailStyleShakeAnim"];
    [shakeAnim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

@end
