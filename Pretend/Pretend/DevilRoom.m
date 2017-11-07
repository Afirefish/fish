//
//  DevilRoom.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/27.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "DevilRoom.h"
#import "CardCraftMgr.h"
#import "DevilRoomMgr.h"
#import "DevilCastleViewController.h"

@interface DevilRoom ()
@property (strong,nonatomic) UIButton *considerBtn;
@property (strong, nonatomic) UIButton *betaryBtn;
@property (strong, nonatomic) UIButton *sincereBtn;
@property (strong,nonatomic) UITextView *considerView;
@property (strong,nonatomic) DevilRoomMgr *devilRoomMgr;

@end

@implementation DevilRoom

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Devil Room";
    self.view.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    CardCraftMgr *cardMgr = [CardCraftMgr defaultMgr];
    if (cardMgr.craftFinished) {
        self.considerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.considerBtn.frame = CGRectMake(self.view.bounds.size.width * 0.2, self.view.bounds.size.height * 0.2, self.view.bounds.size.width * 0.6, self.view.bounds.size.height * 0.2);
        self.considerBtn.backgroundColor = [UIColor clearColor];
        [self.considerBtn setTitle:@"Consider" forState:UIControlStateNormal];
        self.considerBtn.titleLabel.font = [UIFont systemFontOfSize:24];
        self.considerBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.considerBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.view addSubview:self.considerBtn];
    } else {
        NSLog(@"you haven't finish the card craft");
    }
    if (self.devilRoomMgr.betary == YES) {
        [self.considerBtn setTitle:@"Castle" forState:UIControlStateNormal];
        [self.considerBtn addTarget:self action:@selector(enterCastle) forControlEvents:UIControlEventTouchUpInside];
    } else if (self.devilRoomMgr.sincere == YES) {
        [self.considerBtn setTitle:@"Truth" forState:UIControlStateNormal];
    } else {
        [self.considerBtn addTarget:self action:@selector(showHesitate) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showHesitate {//准备选择
    UIAlertController *considerAlert = [UIAlertController alertControllerWithTitle:@"对当前状况考虑" message:@"分析当前的情形，做出你的选择" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *considerComfirmAction = [UIAlertAction actionWithTitle:@"开始分析" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self startConsider];
    }];
    [considerAlert addAction:considerComfirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [considerAlert addAction:cancelAction];
    [self presentViewController:considerAlert animated:YES completion:nil];
}

- (void)startConsider {//分析
    self.devilRoomMgr = [DevilRoomMgr defaultMgr];
    [self.considerBtn removeFromSuperview];
    self.considerView = [[UITextView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 0.2, self.view.bounds.size.height * 0.3, self.view.bounds.size.width * 0.6, self.view.bounds.size.height * 0.7)];
    self.considerView.textColor = [UIColor blackColor];
    self.considerView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    self.considerView.font = [UIFont systemFontOfSize:20];
    self.considerView.textAlignment = NSTextAlignmentCenter;
    self.considerView.editable = NO;
    self.considerView.selectable = NO;
    self.considerView.alpha = 0;
    [self.view addSubview:self.considerView];
    //一个显示剧情的动画
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (NSUInteger __block i = 0; i < [self.devilRoomMgr.considerArr count];) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.4 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.considerView.alpha = 0;
                } completion:^(BOOL finished) {
                    self.considerView.text = [self.devilRoomMgr considerMessage:i];
                    [UIView animateWithDuration:0.4 animations:^{
                        self.considerView.alpha = 1;
                    }];
                }];
            });
            sleep(3);
            i++;
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addChooseBtn];
//            UIAlertController *choiceAlert = [UIAlertController alertControllerWithTitle:@"决定" message:@"是继续信任他们，还是自己主动抓住机会？" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *betaryAction = [UIAlertAction actionWithTitle:@"寻找钥匙" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [self betary];
//            }];
//            [choiceAlert addAction:betaryAction];
//            UIAlertAction *sincereAction = [UIAlertAction actionWithTitle:@"信任他们" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [self sincere];
//            }];
//            [choiceAlert addAction:sincereAction];
//            [self presentViewController:choiceAlert animated:YES completion:nil];
        });
    });
}

- (void)addChooseBtn {//增加选择的按钮
    self.betaryBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.betaryBtn.frame = CGRectMake(self.view.bounds.size.width * 0.1, self.view.bounds.size.height * 0.7, self.view.bounds.size.width * 0.3, self.view.bounds.size.height * 0.2);
    self.betaryBtn.backgroundColor = [UIColor clearColor];
    [self.betaryBtn setTitle:@"betary" forState:UIControlStateNormal];
    self.betaryBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    self.betaryBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.betaryBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.betaryBtn addTarget:self action:@selector(betary) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.betaryBtn];
    
    self.sincereBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.sincereBtn.frame = CGRectMake(self.view.bounds.size.width * 0.6, self.view.bounds.size.height * 0.7, self.view.bounds.size.width * 0.3, self.view.bounds.size.height * 0.2);
    self.sincereBtn.backgroundColor = [UIColor clearColor];
    [self.sincereBtn setTitle:@"sincere" forState:UIControlStateNormal];
    self.sincereBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    self.sincereBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.sincereBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.sincereBtn addTarget:self action:@selector(sincere) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sincereBtn];

}

- (void)betary {//背叛
    self.devilRoomMgr.betary = YES;
    self.devilRoomMgr.roomFinish = YES;//记得以后要修改这里在真正通关之后才设置
    [self.considerView removeFromSuperview];
    [self.betaryBtn removeFromSuperview];
    [self.sincereBtn removeFromSuperview];
    [self.considerBtn setTitle:@"Castle" forState:UIControlStateNormal];
    [self.considerBtn removeTarget:self action:@selector(showHesitate) forControlEvents:UIControlEventTouchUpInside];
    [self.considerBtn addTarget:self action:@selector(enterCastle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.considerBtn];
    NSLog(@"betary");
    [self enterCastle];
}

- (void)enterCastle {//进入城堡
    DevilCastleViewController *castle = [[DevilCastleViewController alloc] init];
    [self.navigationController pushViewController:castle animated:YES];
}

- (void)sincere {//真诚
    self.devilRoomMgr.sincere = YES;
    self.devilRoomMgr.roomFinish = YES;
    [self.considerView removeFromSuperview];
    [self.betaryBtn removeFromSuperview];
    [self.sincereBtn removeFromSuperview];
    [self.considerBtn setTitle:@"Truth" forState:UIControlStateNormal];
    self.considerBtn.userInteractionEnabled = NO;
    [self.view addSubview:self.considerBtn];
    NSLog(@"sincere");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tabBarController.selectedIndex = 3;
    });
}

@end
