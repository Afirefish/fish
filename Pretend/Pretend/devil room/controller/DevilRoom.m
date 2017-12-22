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
#import "UIColor+PRCustomColor.h"
#import <Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@interface DevilRoom ()
@property (strong, nonatomic) UIButton *considerBtn;
@property (strong, nonatomic) UIButton *betaryBtn;
@property (strong, nonatomic) UIButton *sincereBtn;
@property (strong, nonatomic) UITextView *considerView;
@property (strong, nonatomic) DevilRoomMgr *devilRoomMgr;

@end

@implementation DevilRoom

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Devil Room";
    self.view.backgroundColor = [UIColor warmGrayColor];
    [self setupSubviews];
}


- (void)setupSubviews {
    //设置背景图片
    UIImageView *backgroudImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageNamed:@"room"];
        imageView;
    });
    [self.view addSubview:backgroudImageView];
    [self.view bringSubviewToFront:backgroudImageView];
    [backgroudImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    //设置考虑的btn
    CardCraftMgr *cardMgr = [CardCraftMgr defaultMgr];
    if (cardMgr.craftFinished) {
        self.considerBtn = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.backgroundColor = [UIColor clearColor];
            [button setTitle:@"Consider" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:24];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button;
        });
        //        self.considerBtn.frame = CGRectMake(self.view.bounds.size.width * 0.2, self.view.bounds.size.height * 0.2, self.view.bounds.size.width * 0.6, self.view.bounds.size.height * 0.2);
        [self.view addSubview:self.considerBtn];
        [self setupConsiderBtn];
    } else {
        NSLog(@"you haven't finish the card craft");
    }
    //根据不同的决定刷新btn的样式和响应事件
    if (self.devilRoomMgr.betary == YES) {
        [self.considerBtn setTitle:@"Castle" forState:UIControlStateNormal];
        [self.considerBtn addTarget:self action:@selector(enterCastle) forControlEvents:UIControlEventTouchUpInside];
    } else if (self.devilRoomMgr.sincere == YES) {
        [self.considerBtn setTitle:@"Truth" forState:UIControlStateNormal];
    } else {
        [self.considerBtn addTarget:self action:@selector(showHesitate) forControlEvents:UIControlEventTouchUpInside];
    }
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
    self.considerView = ({
        UITextView *textView = [[UITextView alloc] init];
        textView.textColor = [UIColor whiteColor];
        textView.backgroundColor = [UIColor clearColor];
        textView.font = [UIFont systemFontOfSize:20];
        textView.textAlignment = NSTextAlignmentCenter;
        textView.editable = NO;
        textView.selectable = NO;
        textView.alpha = 0;
        textView;
    });
//    self.considerView = [[UITextView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 0.2, self.view.bounds.size.height * 0.3, self.view.bounds.size.width * 0.6, self.view.bounds.size.height * 0.7)];
    [self.view addSubview:self.considerView];
    [self.considerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_centerY).offset(-80.0);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@250.0);
        make.height.equalTo(@200.0);
    }];
    
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

- (void)setupConsiderBtn {
    [self.considerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.width.equalTo(@100.0);
        make.height.equalTo(@30.0);
    }];
}

- (void)addChooseBtn {//增加选择的按钮
    //背叛
    self.betaryBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:@"betary" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:20];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button;
    });
//    button.frame = CGRectMake(self.view.bounds.size.width * 0.1, self.view.bounds.size.height * 0.7, self.view.bounds.size.width * 0.3, self.view.bounds.size.height * 0.2);
    [self.betaryBtn addTarget:self action:@selector(betary) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.betaryBtn];
    [self.betaryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10.0);
        make.right.equalTo(self.view.mas_centerX).offset(-10.0);
        make.height.equalTo(@30);
        make.top.equalTo(self.view.mas_centerY).offset(40.0);
    }];
    
    //信任
    self.sincereBtn = ({
       UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:@"sincere" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:20];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button;
    });
//    self.sincereBtn.frame = CGRectMake(self.view.bounds.size.width * 0.6, self.view.bounds.size.height * 0.7, self.view.bounds.size.width * 0.3, self.view.bounds.size.height * 0.2);
    [self.sincereBtn addTarget:self action:@selector(sincere) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sincereBtn];
    [self.sincereBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(self.betaryBtn);
        make.left.equalTo(self.view.mas_centerX).offset(10.0);
    }];
}

- (void)betary {//背叛
    self.devilRoomMgr.betary = YES;
    self.devilRoomMgr.roomFinish = YES;//记得以后要修改这里在真正通关之后才设置
    [self.sincereBtn removeFromSuperview];
    [self.betaryBtn removeFromSuperview];
    [self.considerView removeFromSuperview];
    [self.considerBtn setTitle:@"Castle" forState:UIControlStateNormal];
    [self.considerBtn removeTarget:self action:@selector(showHesitate) forControlEvents:UIControlEventTouchUpInside];
    [self.considerBtn addTarget:self action:@selector(enterCastle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.considerBtn];
    [self setupConsiderBtn];
    //NSLog(@"betary");
    [self enterCastle];
}

- (void)enterCastle {//进入城堡
    DevilCastleViewController *castle = [[DevilCastleViewController alloc] init];
    [self.navigationController pushViewController:castle animated:YES];
}

- (void)sincere {//真诚
    self.devilRoomMgr.sincere = YES;
    self.devilRoomMgr.roomFinish = YES;
    [self.sincereBtn removeFromSuperview];
    [self.betaryBtn removeFromSuperview];
    [self.considerView removeFromSuperview];
    [self.considerBtn setTitle:@"Truth" forState:UIControlStateNormal];
    self.considerBtn.userInteractionEnabled = NO;
    [self.view addSubview:self.considerBtn];
    [self setupConsiderBtn];
    //NSLog(@"sincere");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tabBarController.selectedIndex = 3;
    });
}

@end

NS_ASSUME_NONNULL_END
