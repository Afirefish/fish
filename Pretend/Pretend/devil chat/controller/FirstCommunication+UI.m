//
//  FirstCommunication+UI.m
//  Pretend
//
//  Created by daixijia on 2017/12/6.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "FirstCommunication+UI.h"
#import <Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@implementation FirstCommunication (UI)

- (void)setupSubview {
    self.backgroudImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageNamed:@"startCastle"];
        imageView;
    });
    [self.view addSubview:self.backgroudImageView];
    [self.view bringSubviewToFront:self.backgroudImageView];
    [self.backgroudImageView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    self.skipButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:@"skip" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [button.titleLabel setTextAlignment:NSTextAlignmentRight];
        button;
    });
    [self.view addSubview:self.skipButton];
    [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backgroudImageView).offset(-40.0);
        make.centerY.equalTo(self.backgroudImageView);
        make.height.equalTo(@20.0);
        make.width.equalTo(@50.0);
    }];
    
    self.animateButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        [button setTitle:@"animate" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [button.titleLabel setTextAlignment:NSTextAlignmentRight];
        button;
    });
    [self.view addSubview:self.animateButton];
    [self.animateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backgroudImageView).offset(40.0);
        make.centerY.equalTo(self.backgroudImageView);
        make.height.equalTo(@20.0);
        make.width.equalTo(@50.0);
    }];
    
    UILabel *startLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"Pretend";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"Zapfino" size:48];
        label.backgroundColor = [UIColor clearColor];
        label;
    });
    [self.view addSubview:startLabel];
    [startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.backgroudImageView);
        make.height.equalTo(@100.0);
        make.bottom.equalTo(self.backgroudImageView.mas_centerY).offset(-40.0);
    }];
    
    UILabel *startTipLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"touch anywhere to start";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"Courier" size:16];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label;
    });
    [self.view addSubview:startTipLabel];
    [startTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.backgroudImageView);
        make.top.equalTo(self.backgroudImageView.mas_centerY).offset(100.0);
        make.height.equalTo(@20.0);
    }];
}

@end

NS_ASSUME_NONNULL_END
