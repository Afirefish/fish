//
//  FirstCommunication+UI.m
//  Pretend
//
//  Created by daixijia on 2017/12/6.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "FirstCommunication+UI.h"
#import <Masonry.h>

@implementation FirstCommunication (UI)

- (void)setUpSkipButton {
    self.skipButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:@"skip" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [button.titleLabel setTextAlignment:NSTextAlignmentRight];
        button;
    });
//    self.skipButton.frame = CGRectMake(self.view.bounds.size.width * 0.8, self.view.bounds.size.height * 0.5, self.view.bounds.size.width * 0.2, self.view.bounds.size.height * 0.1);
    [self.view addSubview:self.skipButton];
    [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10.0);
        make.centerY.equalTo(self.view);
        make.height.equalTo(@20.0);
        make.width.equalTo(@50.0);
    }];
}

- (void)setUpStartLabel {
    UILabel *startLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"Pretend";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Courier-BoldOblique" size:48];
        label.backgroundColor = [UIColor clearColor];
        label;
    });
    //    UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 0.15, self.view.bounds.size.height * 0.2, self.view.bounds.size.width * 0.7, self.view.bounds.size.height * 0.2)];
    [self.view addSubview:startLabel];
    [startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@50.0);
        make.bottom.equalTo(self.view.mas_centerY).offset(-80.0);
    }];
}

- (void)setUpStartTipLabel {
    UILabel *startTipLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"touch anywhere to start";
        label.font = [UIFont fontWithName:@"Courier" size:16];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label;
    });
    //    UILabel *startTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 0.15, self.view.bounds.size.height * 0.7, self.view.bounds.size.width * 0.7, self.view.bounds.size.height * 0.2)];
    [self.view addSubview:startTipLabel];
    [startTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_centerY).offset(100.0);
        make.height.equalTo(@20.0);
    }];
}


@end

