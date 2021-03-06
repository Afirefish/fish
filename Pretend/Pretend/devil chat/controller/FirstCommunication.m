//
//  FirstCommunication.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/27.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "FirstCommunication.h"
#import "ChatRoomMgr.h"
#import "DevilChatRoom.h"
#import "ChatRoomCleared.h"
#import "FirstCommunication+UI.h"
#import "UIColor+PRCustomColor.h"
#import "PRTxtTransform.h"
#import "PRVideoViewController.h"
#import "PRBGMPlayer.h"
//#import "PHSelectViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FirstCommunication ()

@end

@implementation FirstCommunication

- (instancetype)init {
    return [self initWithFirstSence];
}

// 对外部类仅提供第一个场景的初始化方法
- (instancetype)initWithFirstSence{
    if (self = [super init]) {
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.title = @"Pretend";
        // 重新创建一个barButtonItem
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        // 设置backBarButtonItem即可
        self.navigationItem.backBarButtonItem = backItem;
        NSLog(@"height---%f,width ----%f",self.view.bounds.size.height,self.view.bounds.size.width);
        [self setupSubview];
        [self addAction];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor warmShellColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self playBGM];
}

- (void)addAction {
    [self.skipButton addTarget:self action:@selector(skipToEnd) forControlEvents:UIControlEventTouchUpInside];
    [self.animateButton addTarget:self action:@selector(showOpeningAnimate) forControlEvents:UIControlEventTouchUpInside];
}

// 懒人专用，跳过剧情
- (void)skipToEnd {
    // emmmmmm.....
    // NSLog(@"root %@",[self.navigationController.viewControllers firstObject]);
    UIAlertController *skipAlert = [UIAlertController alertControllerWithTitle:@"确定要跳过这里吗？" message:@"点击确定则会跳过这里的剧情，将无法获得稀有卡片！!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *skipComfirmAction = [UIAlertAction actionWithTitle:@"确定跳过!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showFinishScene];
    }];
    [skipAlert addAction:skipComfirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [skipAlert addAction:cancelAction];
    [self presentViewController:skipAlert animated:YES completion:nil];
}

- (void)showOpeningAnimate {
    PRBGMPlayer *bgmPlayer = [PRBGMPlayer defaultPlayer];
    [bgmPlayer pause];
    [self presentViewController:[[PRVideoViewController alloc] init] animated:YES completion:nil];
}

- (void)playBGM {
    PRBGMPlayer *bgmPlayer = [PRBGMPlayer defaultPlayer];
    [bgmPlayer playWithFileURL:[[NSBundle mainBundle] URLForResource:@"bgm" withExtension:@"mp3"]];
}

// 通关场景
- (void)showFinishScene {
    ChatRoomMgr *mainMgr = [ChatRoomMgr defaultMgr];
    [mainMgr chatComplete];
    ChatRoomCleared *cleared = [[ChatRoomCleared alloc] init];
    [self.navigationController pushViewController:cleared animated:YES];
    [self removeFromParentViewController];
}

// 响应触摸显示场景
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    NSUInteger numberOfTaps = [[touches anyObject] tapCount];
    if (numberOfTaps == 1) {
        [self showFirstSence];
    }
}

// 第一个场景
- (void)showFirstSence {
    NSString *message = @"";
    if ([ChatRoomMgr defaultMgr].step == 1) {
        message = @"Puri不知道自己是怎么来到这里的，但是异样的环境清楚地表明这里不是熟悉的地方...";
    } else {
        message = @"继续上次保存的进度吗？";
    }
    UIAlertController *firstAlert = [UIAlertController alertControllerWithTitle:@"游戏开始" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstComfirmAction = [UIAlertAction actionWithTitle:@"进入游戏!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showChatRoom];
    }];
    [firstAlert addAction:firstComfirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"容我考虑一下" style:UIAlertActionStyleCancel handler:nil];
    [firstAlert addAction:cancelAction];
    [self presentViewController:firstAlert animated:YES completion:nil];
}

// 显示具体的几个聊天房间
- (void)showChatRoom {
    DevilChatRoom *selectChat = [DevilChatRoom defaultChatRoom];
    [self.navigationController pushViewController:selectChat animated:YES];
}

@end

NS_ASSUME_NONNULL_END
