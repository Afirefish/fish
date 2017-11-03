//
//  DevilCard.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/27.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//


// 首先如果第一关没有过的话，显示一般界面，如果第一关过了的话，显示进入聚会的界面，整理卡牌，点击进入之后，显示会场内部可以挑战的恶魔的界面，点击挑战的对手之后，进入卡牌对战的房间，战斗流程。。。复杂。。。然后击败或者胜利的时候，进行判断，数据改变，然后点击回到会场内部，继续挑战，直到最后一个人。最后一个对手的胜利做特殊的场景判断，并且胜利之后会跳转到冠军界面，可以补一小段动画之后，第二个游戏通关
#import "DevilCard.h"
#import "ChatRoomMgr.h"
#import "DCNavigationController.h"
#import "CardSortViewController.h"
#import "CardFeastViewController.h"

@interface DevilCard ()

@end

@implementation DevilCard

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Devil Card";
    self.view.backgroundColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0];
    //进入会场
    UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    enterBtn.frame = CGRectMake(self.view.bounds.size.width * 0.4, self.view.bounds.size.height * 0.4, self.view.bounds.size.width * 0.2, self.view.bounds.size.height * 0.2);
    enterBtn.backgroundColor = [UIColor clearColor];
    [enterBtn setTitle:@"Enter" forState:UIControlStateNormal];
    enterBtn.titleLabel.font = [UIFont systemFontOfSize:24];
    [enterBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [enterBtn addTarget:self action:@selector(enterCardFeast) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterBtn];
    //卡牌整理
    UIButton *sortBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    sortBtn.frame = CGRectMake(self.view.bounds.size.width * 0.2, self.view.bounds.size.height * 0.7, self.view.bounds.size.width * 0.6, self.view.bounds.size.height * 0.2);
    sortBtn.backgroundColor = [UIColor clearColor];
    [sortBtn setTitle:@"Card Sort" forState:UIControlStateNormal];
    sortBtn.titleLabel.font = [UIFont systemFontOfSize:24];
    [sortBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [sortBtn addTarget:self action:@selector(sortCard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sortBtn];
}

- (void)sortCard {
    CardSortViewController *cardSort = [[CardSortViewController alloc] init];
    [self.navigationController pushViewController:cardSort animated:YES];
}

- (void)enterCardFeast {//第一个游戏结束，整理卡牌之后进入
    ChatRoomMgr *chatRoomMgr = [ChatRoomMgr defaultMgr];
    if (chatRoomMgr.chatFinished == YES) {//判断第一个游戏是否结束
        CardFeastViewController *cardFeast = [[CardFeastViewController alloc] init];
        [self.navigationController pushViewController:cardFeast animated:YES];
        //[self presentViewController:dcNC animated:YES completion:nil];
    } else {
        NSLog(@"you haven't pass the first game ");
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
