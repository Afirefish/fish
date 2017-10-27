//
//  ChatRoomCleared.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/25.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "ChatRoomCleared.h"

@interface ChatRoomCleared ()

@end

@implementation ChatRoomCleared

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    self.title = @"DevilChat";
    self.view.backgroundColor = [UIColor whiteColor];
    //结束的标签
    UILabel *finishLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 0.15, self.view.bounds.size.height * 0.2, self.view.bounds.size.width * 0.7, self.view.bounds.size.height * 0.2)];
    finishLabel.text = @"Devil Chat Cleared!";
    finishLabel.font = [UIFont fontWithName:@"Courier-BoldOblique" size:24];
    finishLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:finishLabel];
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
