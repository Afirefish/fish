//
//  PRProgressBaseView.h
//  Pretend
//
//  Created by daixijia on 2018/5/28.
//  Copyright © 2018年 戴曦嘉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <POP.h>

#define kStartSpace 20.0

typedef enum PRProgressState{
    //初始
    PRProgressStateOringin = 0,
    //进度条生成
    PRProgressStateReady,
    //进度条执行
    PRProgressStateRunning,
    //完成即100%
    PRProgressStateSuccess,
    //失败动画中
    PRProgressStatefailAnim,
    //失败
    PRProgressStatefailed,
    //恢复到初始状态
    PRProgressStateResume
} ProgressState;

@class PRProgressBaseView;

// 状态改变的委托
@protocol PRProgressDelegate <NSObject>
@optional
-(void)progressView:(PRProgressBaseView *)progressView changedState:(ProgressState)state;

@end

@interface PRProgressBaseView : UIView

@property (nonatomic, assign) ProgressState progressState;
@property (nonatomic, assign) CGFloat currentProgress;
@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, weak) id<PRProgressDelegate> delegate;

// 初始化
-(void)originate;
// ready
-(void)start;
// 运行
-(void)run;
// 失败
-(void)fail;

-(void)generateOriginalStyle;
-(void)generateReadyStyle;
-(void)generateRunningStyle;
-(void)generateFailStyle;

-(void)setProgress:(CGFloat)progress;

@end
