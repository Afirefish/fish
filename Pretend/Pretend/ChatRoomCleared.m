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

@interface ChatRoomCleared ()

@end

@implementation ChatRoomCleared

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    self.title = @"Devil Chat";
    //结束的标签
    UILabel *finishLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 0.2, self.view.bounds.size.height * 0.2, self.view.bounds.size.width * 0.6, self.view.bounds.size.height * 0.2)];
    finishLabel.text = @"Chat Cleared!";
    finishLabel.font = [UIFont fontWithName:@"Courier-BoldOblique" size:24];
    finishLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:finishLabel];
    //重新开始
    UIButton *reStartButton = [UIButton buttonWithType:UIButtonTypeSystem];
    reStartButton.frame = CGRectMake(self.view.bounds.size.width * 0.4, self.view.bounds.size.height * 0.6, self.view.bounds.size.width * 0.2, self.view.bounds.size.height * 0.2);
    reStartButton.backgroundColor = [UIColor clearColor]; //[UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    [reStartButton setTitle:@"ReStart" forState:UIControlStateNormal];
    [reStartButton addTarget:self action:@selector(reStart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reStartButton];
}

- (void)reStart {//重新开始和恶魔的聊天
    UIAlertController *reStartAlert = [UIAlertController alertControllerWithTitle:@"重新开始和恶魔的聊天吗？" message:@"重新开始将会清空所有获得的卡牌！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *reStartComfirmAction = [UIAlertAction actionWithTitle:@"重新开始" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ChatRoomMgr *chatRoomMgr = [ChatRoomMgr defaultMgr];
        [chatRoomMgr reSet];
        FirstCommunication *firstSence = [FirstCommunication initWithFirstSence];
        [self.navigationController pushViewController:firstSence animated:YES];
    }];
    [reStartAlert addAction:reStartComfirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [reStartAlert addAction:cancelAction];
    [self presentViewController:reStartAlert animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
