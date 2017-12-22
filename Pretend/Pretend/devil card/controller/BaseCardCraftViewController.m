//
//  BaseCardCraftViewController.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/31.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "BaseCardCraftViewController.h"
#import "PuriHandCardCell.h"
#import "PuriLayout.h"
#import "PuriHandCardLayout.h"
#import "TableCardCollectionViewCell.h"
#import <Masonry.h>

#define SCREEN_SIZE ([UIScreen mainScreen].bounds.size)
#define SCREEN_WIDTH SCREEN_SIZE.width
#define SCREEN_HEIGHT SCREEN_SIZE.height
#define ITEM_WIDTH 34
#define ITEM_HEIGHT 48

static NSString *puriCard = @"PuriCard";
static NSString *tableCard = @"TableCard";

@interface BaseCardCraftViewController ()

@property (nonatomic,strong) UICollectionView *handCard;//玩家手牌
@property (nonatomic, strong) UICollectionView *tableCardCraft;//桌面卡牌对战
@property (assign, nonatomic) NSInteger handCardCount;// 手牌数量
@property (assign, nonatomic) NSInteger tableCardCount;//桌面卡牌数量
@property (strong, nonatomic) NSString *crafterName;//对战者名字
@property (strong, nonatomic) UILabel *crafterLabel;//对战者的label
@property (strong, nonatomic) UILabel *crafterLP;//对战者的生命值
@property (strong, nonatomic) UILabel *PuriLP;//puri的生命值

@end

@implementation BaseCardCraftViewController

- (instancetype)initWithName:(NSString *)name {
    if (self = [super init]) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@ craft",name];
        self.crafterName = name;
    }
    return self;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.handCardCount = 6;
    self.tableCardCount = 8;
    self.view.backgroundColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0];
    [self setupSubviews];
}

-(void)setupSubviews {
    //使用手牌的布局 不能兼容旋转
    PuriHandCardLayout *puriLayout = [[PuriHandCardLayout alloc] init];
    self.handCard = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:puriLayout];
    self.handCard.delegate = self;
    self.handCard.dataSource = self;
    self.handCard.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0];
    self.handCard.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.handCard];
    [self.handCard registerClass:[PuriHandCardCell class] forCellWithReuseIdentifier:puriCard];
    [self.handCard mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }
        else {
            make.bottom.left.right.equalTo(self.view);
        }
        make.height.equalTo(@(CGRectGetHeight(self.view.frame) * 0.3));
    }];
    
    //桌面卡牌 不能兼容旋转
    UICollectionViewFlowLayout *tableLayout = [[UICollectionViewFlowLayout alloc] init];
    [tableLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    CGFloat height = (CGRectGetHeight(self.view.frame) - 60.0) / 4.0 ;
    CGFloat width = height * ITEM_WIDTH / ITEM_HEIGHT + 4.0;
    tableLayout.itemSize = CGSizeMake(width, height);
    self.tableCardCraft = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:tableLayout];
    self.tableCardCraft.backgroundColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0];
    self.tableCardCraft.delegate = self;
    self.tableCardCraft.dataSource = self;
    [self.view addSubview:self.tableCardCraft];
    [self.tableCardCraft registerClass:[TableCardCollectionViewCell class] forCellWithReuseIdentifier:tableCard];
    [self.tableCardCraft mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        }
        else {
            make.right.left.equalTo(self.view);
        }
        make.bottom.equalTo(self.handCard.mas_top);
        make.height.equalTo(@(CGRectGetHeight(self.view.frame) * 0.5));
    }];
    
    //对战对手的label
    self.crafterLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = self.crafterName;
        label.font = [UIFont systemFontOfSize:30.0];
        label.layer.cornerRadius = 8.0;
        label.clipsToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        label;
    });
//    self.crafterLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - SCREEN_HEIGHT / 9) / 2, 64, SCREEN_HEIGHT / 9, SCREEN_HEIGHT / 9)];
    [self.view addSubview:self.crafterLabel];
    [self.crafterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.tableCardCraft.mas_top).offset(-10.0);
        make.height.equalTo(@30.0);
        make.width.equalTo(@((SCREEN_WIDTH - 40) / 3));
    }];
    
    //puri的lifePoint
    self.PuriLP = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"Puri:10";
        label.layer.cornerRadius = 8.0;
        label.clipsToBounds = YES;
        label.font = [UIFont systemFontOfSize:30.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        label;
    });
//    self.PuriLP = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH + SCREEN_HEIGHT / 9) / 2 + (SCREEN_WIDTH - SCREEN_HEIGHT / 9) * 0.2 / 2, 64, (SCREEN_WIDTH - SCREEN_HEIGHT / 9) * 0.8 / 2, SCREEN_HEIGHT / 9)];
    [self.view addSubview:self.PuriLP];
    [self.PuriLP mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.height.equalTo(self.crafterLabel);
        if (@available(iOS 11.0, *)) {
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-10.0);
        }
        else {
            make.right.equalTo(self.view).offset(-10.0);
        }
    }];
    
    //对手的lifepoint
    self.crafterLP = ({
        UILabel *label = [[UILabel alloc] init];
        label.layer.cornerRadius = 8.0;
        label.clipsToBounds = YES;
        label.text = [NSString stringWithFormat:@"%@:10",self.crafterName];
        label.font = [UIFont systemFontOfSize:30.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        label;
    });
//    self.crafterLP = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, (SCREEN_WIDTH - SCREEN_HEIGHT / 9) * 0.8 / 2, SCREEN_HEIGHT / 9)];
    [self.view addSubview:self.crafterLP];
    [self.crafterLP mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.height.equalTo(self.crafterLabel);
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(10.0);
        }
        else {
            make.left.equalTo(self.view).offset(10.0);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.handCard) {
        return self.handCardCount;
    } else if (collectionView == self.tableCardCraft) {
        return self.tableCardCount;
    } else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.handCard) {
        PuriHandCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:puriCard forIndexPath:indexPath];
        cell.cardImage.image = [UIImage imageNamed:@"p1.png"];
        cell.cardName.text = @"霜月";
        cell.cardName.textAlignment = NSTextAlignmentCenter;
        return cell;
    } else if (collectionView == self.tableCardCraft) {
        TableCardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:tableCard forIndexPath:indexPath];
        cell.cardImage.image = [UIImage imageNamed:@"p1.png"];
        return cell;
    }
    return nil;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

@end
