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
#import "CardCraftMgr.h"
#import "DCNavigationController.h"
#import "DevilCard.h"
#import "DRNavigationController.h"
#import "DevilRoom.h"
#import "TWNavigationController.h"
#import "TrueWorld.h"

NS_ASSUME_NONNULL_BEGIN

@interface PretendedViewController ()

@end

@implementation PretendedViewController

- (void)viewWillAppear:(BOOL)animated {
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBar.tintColor = [UIColor blackColor];
    NSMutableArray *childViewControllers = [[NSMutableArray alloc] init];
    //NSLog(@"file path %@",[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chatRoom.txt"]);
    //第一个视图
    ChatRoomMgr *chatMgr = [ChatRoomMgr defaultMgr];
    //NSLog(@"chat finish %@",chatMgr.chatFinished?@"yes":@"no");
    if ([chatMgr checkComplete]) {//如果第一关完成了，显示结束的画面，否则显示第一个界面
        ChatRoomCleared *chatCleared = [[ChatRoomCleared alloc] init];
        PRNavigationController *prNC = [[PRNavigationController alloc] initWithRootViewController:chatCleared];
        [childViewControllers addObject:prNC];
    }
    else {
        FirstCommunication *firstCommunication = [[FirstCommunication alloc] initWithFirstSence];
        PRNavigationController *prNC = [[PRNavigationController alloc] initWithRootViewController:firstCommunication];
        [childViewControllers addObject:prNC];
    }
    //第二个视图
    CardCraftMgr *cardMgr = [CardCraftMgr defaultMgr];
    if (cardMgr.craftFinished == YES) {
        DevilCard *devilCard = [[DevilCard alloc] init];
        DCNavigationController *dcNC = [[DCNavigationController alloc] initWithRootViewController:devilCard];
        [childViewControllers addObject:dcNC];
    }
    //第三个视图
    DevilRoom *devilRoom = [[DevilRoom alloc] init];
    DRNavigationController *drNC = [[DRNavigationController alloc] initWithRootViewController:devilRoom];
    [childViewControllers addObject:drNC];
    //第四个视图
    TrueWorld *trueWorld  = [[TrueWorld alloc] init];
    TWNavigationController *twNC = [[TWNavigationController alloc] initWithRootViewController:trueWorld];
    [childViewControllers addObject:twNC];
    self.viewControllers = childViewControllers;
}

//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//   //设置当第一个导航控制器的子视图数量大于1时，禁止点击tabbar  似乎暂时没用了。。
//    if ([[(UINavigationController *)[tabBarController.viewControllers objectAtIndex:0] viewControllers] count] > 1) {
//        NSLog(@"count %lu",(unsigned long)[[(UINavigationController *)[tabBarController.viewControllers objectAtIndex:0] viewControllers] count]);
//        return  NO;
//    }
//    return YES;
//}

@end

NS_ASSUME_NONNULL_END
