//
//  PRProgressBaseView.m
//  Pretend
//
//  Created by daixijia on 2018/5/28.
//  Copyright © 2018年 戴曦嘉. All rights reserved.
//

#import "PRProgressBaseView.h"

@implementation PRProgressBaseView

#pragma mark -
- (void)originate {
    [self generateOriginalStyle];
}

- (void)start {
    [self generateReadyStyle];
}
- (void)run {
    [self generateRunningStyle];
}

- (void)fail {
    [self generateFailStyle];
}

#pragma mark - state

- (void)generateOriginalStyle {
    self.progressState = PRProgressStateOringin;
}

- (void)generateReadyStyle {
    self.progressState = PRProgressStateReady;
}

- (void)generateRunningStyle {
    self.progressState = PRProgressStateRunning;
}

- (void)generateFailStyle {
    self.progressState = PRProgressStatefailAnim;
}

- (void)setProgress:(CGFloat)progress {
    self.currentProgress = progress;
}

#pragma mark - getter and setter
- (void)setProgressState:(ProgressState)progressState {
    if (!_progressState || _progressState != progressState) {
        _progressState = progressState;
        if ([self.delegate respondsToSelector:@selector(progressView:changedState:)]) {
            [self.delegate progressView:self changedState:progressState];
        }
    }
}

@end
