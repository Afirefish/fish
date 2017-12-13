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

@interface TrueWorld ()

@end

@implementation TrueWorld

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightBlueColor];
    DevilRoomMgr *devilRoomMgr = [DevilRoomMgr defaultMgr];
    if (devilRoomMgr.roomFinish && devilRoomMgr.sincere) {
        self.navigationItem.title = @"True World";
    } else if (devilRoomMgr.roomFinish && devilRoomMgr.betary){
        self.navigationItem.title = @"Happy End";
    } else {
        self.navigationItem.title = @"End";
    }
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
