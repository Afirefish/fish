//
//  PretendedViewController.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/27.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "PretendedViewController.h"
#import "ChatRoomMgr.h"
#import "PRNavigationController.h"
#import "FirstCommunication.h"
#import "ChatRoomCleared.h"
#import "DCNavigationController.h"
#import "DevilCard.h"
#import "DevilRoom.h"
#import "TrueWorld.h"

@interface PretendedViewController ()

@end

@implementation PretendedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBar.tintColor = [UIColor blackColor];
    NSMutableArray *childViewControllers = [[NSMutableArray alloc] init];
    //NSLog(@"file path %@",[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatRoom.txt"]);
    //第一个视图
    ChatRoomMgr *chatMgr = [ChatRoomMgr defaultMgr];
    NSLog(@"chat finish %@",chatMgr.chatFinished?@"yes":@"no");
    if (chatMgr.chatFinished == YES) {
        ChatRoomCleared *chatCleared = [[ChatRoomCleared alloc] init];
        PRNavigationController *fall = [[PRNavigationController alloc] initWithRootViewController:chatCleared];
        [childViewControllers addObject:fall];
    } else {
        FirstCommunication *firstCommunication = [FirstCommunication initWithFirstSence];
        PRNavigationController *fall = [[PRNavigationController alloc] initWithRootViewController:firstCommunication];
        [childViewControllers addObject:fall];
    }
    //第二个视图
    DevilCard *devilCard = [[DevilCard alloc] init];
    DCNavigationController *dcNC = [[DCNavigationController alloc] initWithRootViewController:devilCard];
    [childViewControllers addObject:dcNC];
    //第三个视图
    DevilRoom *devilRoom = [[DevilRoom alloc] init];
    [devilRoom loadViewIfNeeded];
    devilRoom.view.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    devilRoom.tabBarItem.image = [[UIImage imageNamed:@"devilRoom"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    devilRoom.tabBarItem.selectedImage = [[UIImage imageNamed:@"devilRoom"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    devilRoom.tabBarItem.title = [NSString stringWithFormat:@"Room"];
    [childViewControllers addObject:devilRoom];
    //第四个视图
    TrueWorld *trueWorld  = [[TrueWorld alloc] init];
    [trueWorld loadViewIfNeeded];
    trueWorld.view.backgroundColor = [UIColor colorWithRed:225.0/255 green:225.0/255 blue:225.0/255 alpha:1.0];
    trueWorld.tabBarItem.image = [[UIImage imageNamed:@"trueWorld"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    trueWorld.tabBarItem.selectedImage = [[UIImage imageNamed:@"trueWorld"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    trueWorld.tabBarItem.title = [NSString stringWithFormat:@"Truth"];
    [childViewControllers addObject:trueWorld];
    self.viewControllers = childViewControllers;
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
