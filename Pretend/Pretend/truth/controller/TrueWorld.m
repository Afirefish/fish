//
//  TrueWorld.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/27.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "TrueWorld.h"
#import "DevilRoomMgr.h"
#import "TruthMgr.h"
#import "UIColor+PRCustomColor.h"
#import <Masonry.h>

@interface TrueWorld ()

@end

@implementation TrueWorld

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightBlueColor];
    DevilRoomMgr *devilRoomMgr = [DevilRoomMgr defaultMgr];
    [self setupBackGroudImage];
    if (devilRoomMgr.roomFinish && devilRoomMgr.sincere) {
        self.navigationItem.title = @"True World";
    } else if (devilRoomMgr.roomFinish && devilRoomMgr.betary){
        self.navigationItem.title = @"Happy End";
    } else {
        self.navigationItem.title = @"End";
    }
}

//设置背景图片
- (void)setupBackGroudImage {
    UIImageView *backgroudImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageNamed:@"finalRiver"];
        imageView;
    });
    [self.view addSubview:backgroudImageView];
    [self.view bringSubviewToFront:backgroudImageView];
    [backgroudImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

@end
