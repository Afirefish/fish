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

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

static NSString *card = @"PuriCard";

@interface BaseCardCraftViewController ()

@property (nonatomic,strong) UICollectionView *handCard;//实现成轮转式的view
@property (assign,nonatomic) NSInteger cellCount;// 卡牌数量

@end


@implementation BaseCardCraftViewController

- (instancetype)initWithName:(NSString *)name {
    if (self = [super init]) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@ craft",name];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.cellCount = 6;
    self.view.backgroundColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0];
    [self setPuriHandCardLayout];
}


-(void)setPuriHandCardLayout{//使用手牌的布局
//    PuriLayout *layout = [[PuriLayout alloc] init];
//    CGFloat startAngle = M_PI * 5/6;
//    CGFloat endAngle = M_PI / 3;
//    CGFloat radius = SCREEN_WIDTH/2 - ITEM_WIDTH/2;
//    CGFloat angularSpacing = 1;
//    CGFloat circumference = ABS(startAngle - endAngle)*radius;//圆弧长度
//    NSInteger maxNoOfCellsInCircle =  (NSInteger)(circumference/(MAX(ITEM_WIDTH, ITEM_HEIGHT) + angularSpacing/2));//卡牌的最大数量
//    self.cellCount = maxNoOfCellsInCircle + 2;
//    [layout initWithCentre:CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 3 - ITEM_WIDTH * 0.7) radius:radius itemSize:CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT) andAngularSpacing:angularSpacing];//这个的中心点的位置是相对于collectionview来说的
//    [layout setStartAngle:startAngle endAngle:endAngle];
//    layout.mirrorX = NO;
//    layout.mirrorY = NO;
//    layout.rotateItems = YES;
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    PuriHandCardLayout *layout = [[PuriHandCardLayout alloc] init];
    //self.handCard = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
    self.handCard = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 2 / 3, SCREEN_WIDTH, SCREEN_HEIGHT / 3) collectionViewLayout:layout];
    NSLog(@"handCard frame %@",self.handCard);
    self.handCard.delegate = self;
    self.handCard.dataSource = self;
    self.handCard.backgroundColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0];
    self.handCard.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.handCard];
    [self.handCard registerClass:[PuriHandCardCell class] forCellWithReuseIdentifier:card];
    //[self.handCard reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellCount;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PuriHandCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:card forIndexPath:indexPath];
    cell.cardImage.image = [UIImage imageNamed:@"p1.png"];
    cell.cardName.text = @"霜月";
    cell.cardName.textAlignment = NSTextAlignmentCenter;
    return cell;
}


@end
