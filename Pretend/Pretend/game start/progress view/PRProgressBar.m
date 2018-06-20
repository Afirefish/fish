//
//  PRProgressBar.m
//  Pretend
//
//  Created by daixijia on 2018/5/28.
//  Copyright © 2018年 戴曦嘉. All rights reserved.
//

#import "PRProgressBar.h"

#define kReadyAnimateDuration 0.5
#define kSmallConrnerRadius 4.0
#define kLargeCornerRadius 8.0
#define KBarColor [UIColor colorWithRed:21.0/255.0 green:53.0/255.0 blue:74.0/255.0 alpha:1.f]

@interface PRProgressBar ()

@property (nonatomic) CGFloat barLength;
@property (nonatomic ,strong) CAShapeLayer *loadlayer;
@property (nonatomic ,strong) CAShapeLayer *triangleLayer;

@end

@implementation PRProgressBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self generateOriginalStyle];
    }
    return self;
}

// 初始化
- (void)generateOriginalStyle {
    [super generateOriginalStyle];
    self.layer.backgroundColor = KBarColor.CGColor;
    self.layer.cornerRadius = kLargeCornerRadius;
    self.barLength = [UIScreen mainScreen].bounds.size.width - kStartSpace * 2;
}

// 准备状态
- (void)generateReadyStyle {
    [super generateReadyStyle];
    [self startReadyAnimate];
}

// 运行状态
- (void)generateRunningStyle {
    [super generateRunningStyle];
    [self startRunningAnimate];
}

// 失败状态
- (void)generateFailStyle {
    [super generateFailStyle];
    [self startFailAnimate];
}

#pragma mark - animate

// 准备的动画，从初始化状态变成了一个长条的状态
- (void)startReadyAnimate  {
    // 圆角变化，大圆角变成小圆角
    POPBasicAnimation *cornerAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerCornerRadius];
    cornerAnim.toValue = @(kSmallConrnerRadius);
    cornerAnim.duration= kReadyAnimateDuration;
    [self.layer pop_addAnimation:cornerAnim forKey:@"BarReadyStyleCornerAnim"];
    // size变化，大小变成bar的长度，高度变成小圆角的高度
    POPBasicAnimation *sizeAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerSize];
    sizeAnim.toValue = [NSValue valueWithCGSize:CGSizeMake(self.barLength, kLargeCornerRadius)];
    sizeAnim.duration = kReadyAnimateDuration;
    [self.layer pop_addAnimation:sizeAnim forKey:@"BarReadyStyleSizeAnim"];
    /* position变化,position是本视图在父视图中anchorPoint点的位置,这个点默认是中心点
     * position.x = frame.origin.x + anchorPoint.x * bounds.size.width；
     * position.y = frame.origin.y + anchorPoint.y * bounds.size.height；
     * 这两个值不会互相影响，但是共同决定frame的origin
     * 修改了anchorpoint，同时修改position就不会改变frame的origin
     * positionNew.x = positionOld.x + (anchorPointNew.x - anchorPointOld.x)  * bounds.size.width
     * positionNew.y = positionOld.y + (anchorPointNew.y - anchorPointOld.y)  * bounds.size.height
     * 实际使用的时候只需要在修改anchorPoint的时候，重新设置frame即可
     */
    POPBasicAnimation *positionAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAnim.toValue = [NSValue valueWithCGPoint:CGPointMake([UIScreen mainScreen].bounds.size.width / 2.0, self.frame.origin.y + self.offsetY)];
    sizeAnim.duration = kReadyAnimateDuration;
    [self.layer pop_addAnimation:positionAnim forKey:@"BarReadyStylePositionAnim"];
}

// 运行的动画，首先添加了一个加载的白色视图，然后具体的长条的大小变化由外界控制
- (void)startRunningAnimate {
    self.loadlayer = [CAShapeLayer layer];
    [self.loadlayer setFillColor:[UIColor whiteColor].CGColor];
    [self.layer addSublayer:self.loadlayer];
}

// 更新白色长条的动画
-(void)setProgress:(CGFloat)progress {
    [super setProgress:progress];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, (self.barLength)*progress, kLargeCornerRadius) byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft|UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(kSmallConrnerRadius, kSmallConrnerRadius)];
    self.loadlayer.path = [bezierPath CGPath];
    if (progress == 1) {
        self.progressState = PRProgressStateSuccess;
    }
}

// 失败动画
- (void)startFailAnimate {
    // 添加一个三角形的缺口
    CAShapeLayer *triangleLayer = [CAShapeLayer layer];
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:CGPointMake(self.barLength * self.currentProgress + kSmallConrnerRadius, kLargeCornerRadius)];
    [trianglePath addLineToPoint:CGPointMake(self.barLength * self.currentProgress - kSmallConrnerRadius, kLargeCornerRadius)];
    [trianglePath addLineToPoint:CGPointMake(self.barLength * self.currentProgress, kSmallConrnerRadius)];
    [trianglePath closePath];
    triangleLayer.path = trianglePath.CGPath;
    [triangleLayer setFillColor:[UIColor cyanColor].CGColor];
    [self.layer addSublayer:triangleLayer];
    self.triangleLayer = triangleLayer;
    // 粒子效果
    [self startFailStyleEmitterAnimationWithCompletion:^{
        [self startFailStyleLoadBarDismissAnimation];
    }];
}

// 失败时粒子引擎动画
-(void)startFailStyleEmitterAnimationWithCompletion:(void(^)(void))completion{
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    
    emitter.emitterPosition = CGPointMake(self.barLength * self.currentProgress, kLargeCornerRadius);
    emitter.emitterSize = CGSizeMake(10, 10);
    emitter.backgroundColor =  KBarColor.CGColor;
    emitter.emitterShape = kCAEmitterLayerPoint; // 这里是设置发射器的形状，具体效果和发射器的大小有关
    emitter.renderMode = kCAEmitterLayerBackToFront; // 渲染模式，定义如何将粒子合成到图层中
    emitter.emitterMode = kCAEmitterLayerPoints; // 根据发射形状创建粒子
    [self.layer addSublayer:emitter];
    
    CAEmitterCell *leftCell = [[CAEmitterCell alloc] init];
    CAEmitterCell *rightCell = [[CAEmitterCell alloc] init];
    // 创建一个0.8大小的图片，颜色填充之后保存为image对象
    CGSize imageSize = CGSizeMake(0.8, 0.8);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    [KBarColor set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    leftCell.contents = (__bridge id)image.CGImage;
    leftCell.birthRate = 2.0;  // 产生粒子数
    leftCell.lifetime = 1.0; // 生命期
    leftCell.velocity = 30; // 粒子的初始速度
    leftCell.emissionRange = M_PI / 10; // 粒子分布在这个发射角度的锥形区域
    leftCell.emissionLongitude = M_PI / 8 * 3; // 粒子在xy平面的发射角度
    
    rightCell.contents = (__bridge id)image.CGImage;
    rightCell.birthRate = 2.0;
    rightCell.lifetime = 1.0;
    rightCell.velocity = 30;
    rightCell.emissionRange = M_PI / 10;
    rightCell.emissionLongitude = M_PI / 8 * 5;
    
    emitter.emitterCells = @[leftCell,rightCell];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
        // 移除粒子发射器
        [emitter removeFromSuperlayer];
        if (completion) {
            completion();
        }
        
    });
}

// 失败的加载条的动画
-(void)startFailStyleLoadBarDismissAnimation{
    CALayer *flowLayer = [CALayer layer];
    flowLayer.anchorPoint = CGPointMake(0, 0);
    flowLayer.position = CGPointMake(self.barLength * self.currentProgress - kSmallConrnerRadius, 6);
    flowLayer.bounds = CGRectMake(0, 0, 5, 0);
    [flowLayer setBackgroundColor:[UIColor whiteColor].CGColor];
    flowLayer.cornerRadius = 2.5f;
    [self.layer addSublayer:flowLayer];
    
    // 宽度从5变成0，高度从0变成某个值
    POPBasicAnimation *sizeDownAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerSize];
    sizeDownAnim.duration = 2.4f;
    sizeDownAnim.toValue = [NSValue valueWithCGSize:CGSizeMake(0, (self.currentProgress * self.barLength + kLargeCornerRadius ) * 2 )];
    [flowLayer pop_addAnimation:sizeDownAnim forKey:@"BarFailStyleSizeFlowAnim"];
    
    // 这里将流水降低一些距离之后，移除掉layer
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
        
        POPBasicAnimation *flowAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        flowAnim.duration = 1.2f;
        flowAnim.toValue = @300;
        [flowLayer pop_addAnimation:flowAnim forKey:@"BarFailStylePositionYFlowAnim"];
        [flowAnim setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
            [flowLayer removeFromSuperlayer];
        }];
        
    });
    
    POPBasicAnimation *positionYAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionYAnim.duration = 1.2f;
    positionYAnim.toValue = @(kLargeCornerRadius);
    [self.loadlayer pop_addAnimation:positionYAnim forKey:@"BarFailStylePositionYAnim"];
    
    POPBasicAnimation *scaleYAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleY];
    scaleYAnim.duration = 1.2f;
    scaleYAnim.toValue = @0;
    [self.loadlayer pop_addAnimation:scaleYAnim forKey:@"BarFailStyleScaleYAnim"];
    [scaleYAnim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [self.loadlayer removeFromSuperlayer];
    }];
}

@end
