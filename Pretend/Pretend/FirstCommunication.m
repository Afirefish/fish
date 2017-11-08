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

@interface FirstCommunication ()
@property (strong,nonatomic) DevilChatRoom *selectChat;

@end

@implementation FirstCommunication

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//对外部类仅提供第一个场景的初始化方法
+ (instancetype)initWithFirstSence{
    return [[self alloc] initWithSence:1];
}

//实际上的初始化方法
- (instancetype)initWithSence:(NSInteger)step {
    if(self = [super init]) {
        if (step == 1) {
            self.navigationItem.hidesBackButton = YES;
            self.navigationItem.title = @"The unconscious fall";
            self.view.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
            NSLog(@"height---%f,width ----%f",self.view.bounds.size.height,self.view.bounds.size.width);
            //标题的标签
            UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 0.15, self.view.bounds.size.height * 0.2, self.view.bounds.size.width * 0.7, self.view.bounds.size.height * 0.2)];
            startLabel.text = @"Pretend";
            startLabel.font = [UIFont fontWithName:@"Courier-BoldOblique" size:48];
            startLabel.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
            [self.view addSubview:startLabel];
            //开始的提示。。
            UILabel *startTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 0.15, self.view.bounds.size.height * 0.7, self.view.bounds.size.width * 0.7, self.view.bounds.size.height * 0.2)];
            startTipLabel.text = @"touch anywhere to start";
            startTipLabel.font = [UIFont fontWithName:@"Courier" size:16];
            startTipLabel.backgroundColor = [UIColor clearColor]; //[UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
            [self.view addSubview:startTipLabel];
            //跳过。。测试用
            UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeSystem];
            skipButton.frame = CGRectMake(self.view.bounds.size.width * 0.8, self.view.bounds.size.height * 0.5, self.view.bounds.size.width * 0.2, self.view.bounds.size.height * 0.1);
            skipButton.backgroundColor = [UIColor clearColor]; //[UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
            [skipButton setTitle:@"skip" forState:UIControlStateNormal];
            [skipButton addTarget:self action:@selector(skipToEnd) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:skipButton];
        }
    }
    return self;
}

//懒人专用，跳过剧情
- (void)skipToEnd {
    //emmmmmm.....
    NSLog(@"root %@",[self.navigationController.viewControllers firstObject]);
    UIAlertController *skipAlert = [UIAlertController alertControllerWithTitle:@"确定要跳过这里吗？" message:@"点击确定则会跳过这里的剧情，将无法获得稀有卡片！!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *skipComfirmAction = [UIAlertAction actionWithTitle:@"确定跳过!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showFinishScene];
    }];
    [skipAlert addAction:skipComfirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [skipAlert addAction:cancelAction];
    [self presentViewController:skipAlert animated:YES completion:nil];
}

//通关场景
- (void)showFinishScene {
    ChatRoomMgr *mainMgr = [ChatRoomMgr defaultMgr];
    [mainMgr chatComplete];
    ChatRoomCleared *cleared = [[ChatRoomCleared alloc] init];
    [self.navigationController pushViewController:cleared animated:YES];
    [self removeFromParentViewController];
    //[self presentViewController:cleared animated:YES completion:nil];
}

//响应触摸显示场景
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSUInteger numberOfTaps = [[touches anyObject] tapCount];
    if (numberOfTaps == 1) {
        [self showFirstSence];
    }
}

//第一个场景
- (void)showFirstSence {
    NSString *firstMessage = [[NSString alloc] initWithFormat:@"大明不知道自己是怎么来到这里的，虽然不知道是哪里，但是异样的环境清楚地表明这里不是熟悉的地方..."];
    UIAlertController *firstAlert = [UIAlertController alertControllerWithTitle:@"游戏开始，你，准备好了吗？" message:firstMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstComfirmAction = [UIAlertAction actionWithTitle:@"异界之旅开始!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showChatRoom];
    }];
    [firstAlert addAction:firstComfirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"容我考虑一下" style:UIAlertActionStyleCancel handler:nil];
    [firstAlert addAction:cancelAction];
    [self presentViewController:firstAlert animated:YES completion:nil];
}

//显示具体的几个聊天房间
- (void)showChatRoom {
    self.selectChat = [DevilChatRoom devilShowUp];
    [self.navigationController pushViewController:self.selectChat animated:YES];
}


@end
