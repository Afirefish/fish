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

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.handCardCount = 6;
    self.tableCardCount = 8;
    self.view.backgroundColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0];
    [self setPuriHandCardLayout];
}

-(void)setPuriHandCardLayout{
    //使用手牌的布局
    PuriHandCardLayout *puriLayout = [[PuriHandCardLayout alloc] init];
    self.handCard = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 2 / 3 + 64, SCREEN_WIDTH, SCREEN_HEIGHT / 3 - 64) collectionViewLayout:puriLayout];
    self.handCard.delegate = self;
    self.handCard.dataSource = self;
    self.handCard.backgroundColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0];
    self.handCard.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.handCard];
    [self.handCard registerClass:[PuriHandCardCell class] forCellWithReuseIdentifier:puriCard];
    
    //桌面卡牌
    UICollectionViewFlowLayout *tableLayout = [[UICollectionViewFlowLayout alloc] init];
    [tableLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    CGFloat height = (self.view.bounds.size.height * 1 / 2 - 64) / 2 ;
    CGFloat width = height * ITEM_WIDTH / ITEM_HEIGHT + 4;
    tableLayout.itemSize = CGSizeMake(width, height);
    self.tableCardCraft = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT / 6 + 64 - SCREEN_HEIGHT / 18, SCREEN_WIDTH, SCREEN_HEIGHT * 1 / 2) collectionViewLayout:tableLayout];
    self.tableCardCraft.backgroundColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0];
    self.tableCardCraft.delegate = self;
    self.tableCardCraft.dataSource = self;
    [self.view addSubview:self.tableCardCraft];
    [self.tableCardCraft registerClass:[TableCardCollectionViewCell class] forCellWithReuseIdentifier:tableCard];
    
    //对战对手的label
    self.crafterLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - SCREEN_HEIGHT / 9) / 2, 64, SCREEN_HEIGHT / 9, SCREEN_HEIGHT / 9)];
    self.crafterLabel.text = self.crafterName;
    self.crafterLabel.adjustsFontSizeToFitWidth = YES;
    [self.crafterLabel setTextAlignment:NSTextAlignmentCenter];
    self.crafterLabel.backgroundColor = [UIColor clearColor];
    self.crafterLabel.layer.cornerRadius = self.crafterLabel.bounds.size.width/2;
    self.crafterLabel.layer.masksToBounds = YES;
    [self.view addSubview:self.crafterLabel];
    
    //puri的lifePoint
    self.PuriLP = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH + SCREEN_HEIGHT / 9) / 2 + (SCREEN_WIDTH - SCREEN_HEIGHT / 9) * 0.2 / 2, 64, (SCREEN_WIDTH - SCREEN_HEIGHT / 9) * 0.8 / 2, SCREEN_HEIGHT / 9)];
    self.PuriLP.text = @"Puri:10";
    self.PuriLP.adjustsFontSizeToFitWidth = YES;
    [self.PuriLP setTextAlignment:NSTextAlignmentCenter];
    self.PuriLP.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.PuriLP];
    
    //对手的lifepoint
    self.crafterLP = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, (SCREEN_WIDTH - SCREEN_HEIGHT / 9) * 0.8 / 2, SCREEN_HEIGHT / 9)];
    self.crafterLP.text = [NSString stringWithFormat:@"%@:10",self.crafterName];
    self.crafterLP.adjustsFontSizeToFitWidth = YES;
    [self.crafterLP setTextAlignment:NSTextAlignmentCenter];
    self.crafterLP.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.crafterLP];
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


@end
