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

@property (nonatomic,strong) UICollectionView *handCardCollectionView;                      // 玩家手牌视图
@property (nonatomic, strong) UICollectionView *tableCardCollectionView;                    // 桌面卡牌对战视图
@property (assign, nonatomic) NSInteger handCardCount;                                      // 手牌数量
@property (assign, nonatomic) NSInteger tableCardCount;                                     // 桌面卡牌数量
@property (strong, nonatomic) NSString *crafterName;                                        // 对战者名字
@property (strong, nonatomic) UILabel *crafterLabel;                                        // 对战者的label
@property (strong, nonatomic) UILabel *crafterLP;                                           // 对战者的生命值
@property (strong, nonatomic) UILabel *PuriLP;                                              // puri的生命值
// 桌面卡牌数组，添加或者删除来控制 桌面局势
@property (strong, nonatomic) NSMutableArray<UIImage *> *tableCards;
// puri手牌卡组
@property (strong, nonatomic) NSMutableArray<UIImage *> *handCards;

@end

@implementation BaseCardCraftViewController

- (instancetype)initWithName:(NSString *)name {
    if (self = [super init]) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@ craft",name];
        self.crafterName = name;
        [self loadStartCards];
    }
    return self;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubviews];
}

-(void)setupSubviews {
    //使用手牌的布局 不能兼容旋转
    PuriHandCardLayout *puriLayout = [[PuriHandCardLayout alloc] init];
    self.handCardCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:puriLayout];
    self.handCardCollectionView.delegate = self;
    self.handCardCollectionView.dataSource = self;
    self.handCardCollectionView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0];
    self.handCardCollectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.handCardCollectionView];
    [self.handCardCollectionView registerClass:[PuriHandCardCell class] forCellWithReuseIdentifier:puriCard];
    [self.handCardCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }
        else {
            make.bottom.left.right.equalTo(self.view);
        }
        make.height.equalTo(@(CGRectGetHeight([UIScreen mainScreen].bounds) * 0.3));
    }];
    
    //桌面卡牌 不能兼容旋转
    UICollectionViewFlowLayout *tableLayout = [[UICollectionViewFlowLayout alloc] init];
    [tableLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    CGFloat height = (CGRectGetHeight(self.view.frame) - 60.0) / 4.0 ;
    CGFloat width = height * ITEM_WIDTH / ITEM_HEIGHT + 4.0;
    tableLayout.itemSize = CGSizeMake(width, height);
    self.tableCardCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:tableLayout];
    self.tableCardCollectionView.backgroundColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0];
    self.tableCardCollectionView.delegate = self;
    self.tableCardCollectionView.dataSource = self;
    [self.view addSubview:self.tableCardCollectionView];
    [self.tableCardCollectionView registerClass:[TableCardCollectionViewCell class] forCellWithReuseIdentifier:tableCard];
    [self.tableCardCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        }
        else {
            make.right.left.equalTo(self.view);
        }
        make.bottom.equalTo(self.handCardCollectionView.mas_top);
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
        make.bottom.equalTo(self.tableCardCollectionView.mas_top).offset(-10.0);
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

#pragma mark - card craft

- (void)loadStartCards {
    self.handCards = [[NSMutableArray alloc] init];
    self.tableCards = [[NSMutableArray alloc] init];
    self.handCardCount = 6;
    self.tableCardCount = 8;
    for (NSInteger i = 0; i < self.handCardCount; i++) {
        [self.handCards addObject:[UIImage imageNamed:[NSString stringWithFormat:@"p%td", i+1]]];
    }
}

#pragma mark - collection view

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.handCardCollectionView) {
        return self.handCards.count;
    }
    else if (collectionView == self.tableCardCollectionView) {
        return self.tableCardCount;
    }
    else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.handCardCollectionView) {
        if (self.tableCards.count >= self.tableCardCount) {
            UIAlertController *confirm = [UIAlertController alertControllerWithTitle:@"桌面卡牌已满" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
            [confirm addAction:confirmAction];
            [self presentViewController:confirm animated:YES completion:nil];
        }
        else {
            UIImage *image = [self.handCards objectAtIndex:indexPath.row];
            [self.handCards removeObjectAtIndex:indexPath.row];
            [self.tableCards addObject:image];
            [self.handCardCollectionView reloadData];
            [self.tableCardCollectionView reloadData];
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.handCardCollectionView) {
        PuriHandCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:puriCard forIndexPath:indexPath];
        UIImage *image = nil;
        if (self.handCards.count && self.handCards.count > indexPath.row) {
            image = [self.handCards objectAtIndex:indexPath.row];
        }
        if (image) {
            cell.cardImage.image = image;
            cell.cardName.text = [NSString stringWithFormat:@"霜月%td", indexPath.row] ;
        }
        return cell;
    }
    else {
        TableCardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:tableCard forIndexPath:indexPath];
        UIImage *image = nil;
        if (self.tableCards.count && self.tableCards.count > indexPath.row) {
            image = [self.tableCards objectAtIndex:indexPath.row];
        }
        if (image) {
            cell.cardImage.image = image;
        }
        else {
            cell.cardImage.image = nil;
        }
        return cell;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

@end
