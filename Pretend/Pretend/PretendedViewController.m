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
        PRNavigationController *prNC = [[PRNavigationController alloc] initWithRootViewController:chatCleared];
        [childViewControllers addObject:prNC];
    } else {
        FirstCommunication *firstCommunication = [FirstCommunication initWithFirstSence];
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
