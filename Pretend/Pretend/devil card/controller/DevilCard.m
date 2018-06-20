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
#import "BaseCardCraftViewController.h"
#import "UIColor+PRCustomColor.h"
#import <Masonry.h>

#import "CardSortTestViewController.h"

@interface DevilCard ()

@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *enterBtn;
@property (nonatomic, strong) UIButton *sortBtn;
@property (nonatomic, strong) UIImageView *backgroudImageView;

@end

@implementation DevilCard

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Devil Card";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    self.view.backgroundColor = [UIColor smokeWhiteColor];
    [self setupBackgroudImage];
    [self setupSubviews];
}

// 设置背景图片
- (void)setupBackgroudImage {
    self.backgroudImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageNamed:@"feast"];
        imageView;
    });
    [self.view addSubview:self.backgroudImageView];
    [self.view bringSubviewToFront:self.backgroudImageView];
    [self.backgroudImageView mas_makeConstraints:^(MASConstraintMaker *make) {
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
}

- (void)setupSubviews {
    // 卡牌整理
    self.sortBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:@"Card Sort" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:24];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button;
    });
//    enterBtn.frame = CGRectMake(self.view.bounds.size.width * 0.4, self.view.bounds.size.height * 0.4, self.view.bounds.size.width * 0.2, self.view.bounds.size.height * 0.2);
    [self.sortBtn addTarget:self action:@selector(sortCard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sortBtn];
    [self.sortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backgroudImageView).offset(100.0);
        make.top.equalTo(self.backgroudImageView).offset(100.0);
        make.width.equalTo(@100.0);
        make.height.equalTo(@30.0);
    }];

    // 进入会场
    self.enterBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:@"Enter" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:24];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button;
    });
//    sortBtn.frame = CGRectMake(self.view.bounds.size.width * 0.2, self.view.bounds.size.height * 0.7, self.view.bounds.size.width * 0.6, self.view.bounds.size.height * 0.2);
    [self.enterBtn addTarget:self action:@selector(enterCardFeast) forControlEvents:UIControlEventTouchUpInside];
    //[sortBtn addTarget:self action:@selector(sortCardTest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.enterBtn];
    [self.enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backgroudImageView).offset(40.0);
        make.width.equalTo(@100.0);
        make.top.equalTo(self.sortBtn.mas_bottom).offset(100);
        make.height.equalTo(@30.0);
    }];
}

- (void)sortCard {
    CardSortViewController *cardSort = [[CardSortViewController alloc] init];
    [self.navigationController pushViewController:cardSort animated:YES];
}

//- (void)sortCardTest {
//    CardSortTestViewController *cardSort = [[CardSortTestViewController alloc] init];
//    [self.navigationController pushViewController:cardSort animated:YES];
//}

- (void)enterCardFeast { // 第一个游戏结束，整理卡牌之后进入
    ChatRoomMgr *chatRoomMgr = [ChatRoomMgr defaultMgr];
    if ([chatRoomMgr checkComplete]) { // 判断第一个游戏是否结束
        if (self.tipLabel != nil) {
            [self.tipLabel removeFromSuperview];
            self.tipLabel = nil;
        }
        BaseCardCraftViewController *devilCraft = [[BaseCardCraftViewController alloc] initWithDevilID:0];
        [self.navigationController pushViewController:devilCraft animated:YES];
    }
    else {
        if (self.tipLabel == nil) {
            [self setupTipLabel];
        }
    }
}

- (void)setupTipLabel {
    self.tipLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"你还没有通关第一个游戏";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.backgroundColor = [UIColor clearColor];
        label;
    });
//    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 0.1,self.view.bounds.size.height * 0.5, self.view.bounds.size.width * 0.8, self.view.bounds.size.height * 0.2)];
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.backgroudImageView);
        make.top.equalTo(self.sortBtn.mas_bottom).offset(10.0);
        make.bottom.equalTo(self.enterBtn.mas_top).offset(10.0);
    }];
}

@end
