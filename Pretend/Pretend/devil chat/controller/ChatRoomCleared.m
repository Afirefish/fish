//
//  ChatRoomCleared.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/25.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "ChatRoomCleared.h"
#import "ChatRoomMgr.h"
#import "FirstCommunication.h"
#import "SantaChatDetail.h"
#import "PufuChatDetail.h"
#import "ChiziChatDetail.h"
#import "TizaChatDetail.h"
#import <Masonry.h>

@interface ChatRoomCleared ()

@end

@implementation ChatRoomCleared

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    self.tabBarController.tabBar.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Chat Cleared";
    [self setupSubviews];

}

- (void)setupSubviews {

    //设置背景图片
    UIImageView *backgroudImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageNamed:@"endCastle"];
        imageView;
    });
    [self.view addSubview:backgroudImageView];
    [backgroudImageView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    //结束的标签
    UILabel *finishLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"Chat Cleared!";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"Zapfino" size:24];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label;
    });
//    UILabel *finishLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 0.2, self.view.bounds.size.height * 0.2, self.view.bounds.size.width * 0.6, self.view.bounds.size.height * 0.2)];
    [self.view addSubview:finishLabel];
    [finishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backgroudImageView);
        make.height.equalTo(@50.0);
        make.bottom.equalTo(backgroudImageView.mas_centerY).offset(-80.0);
    }];
    
    //重新开始
    UIButton *reStartButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:@"ReStart" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [button addTarget:self action:@selector(reStart) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
//    reStartButton.frame = CGRectMake(self.view.bounds.size.width * 0.4, self.view.bounds.size.height * 0.6, self.view.bounds.size.width * 0.2, self.view.bounds.size.height * 0.2);
    [self.view addSubview:reStartButton];
    [reStartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backgroudImageView);
        make.height.equalTo(@20.0);
        make.top.equalTo(finishLabel.mas_bottom).offset(100);
    }];
}

- (void)reStart {//重新开始和恶魔的聊天
    UIAlertController *reStartAlert = [UIAlertController alertControllerWithTitle:@"重新开始和恶魔的聊天吗？" message:@"重新开始将会清空所有获得的卡牌！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *reStartComfirmAction = [UIAlertAction actionWithTitle:@"重新开始" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ChatRoomMgr *chatRoomMgr = [ChatRoomMgr defaultMgr];
        [chatRoomMgr reSet];
        //NSLog(@"root %@",[self.navigationController.viewControllers firstObject]);
        FirstCommunication *firstSence = [[FirstCommunication alloc] initWithFirstSence];
        [self.navigationController pushViewController:firstSence animated:YES];
        [self removeFromParentViewController];
    }];
    [reStartAlert addAction:reStartComfirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [reStartAlert addAction:cancelAction];
    [self presentViewController:reStartAlert animated:YES completion:nil];

}

@end
