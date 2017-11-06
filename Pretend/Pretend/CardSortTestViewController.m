//
//  CardSortTestViewController.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/11/6.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "CardSortTestViewController.h"
#import "CardCell.h"
#import "CardMasonryLayout.h"
#import "PuriLayout.h"
#import "CardCoverFlowLayout.h"
#import "CardSortTestCollectionViewCell.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define ITEM_WIDTH 68
#define ITEM_HEIGHT 96

@interface CardSortTestViewController ()
@property (strong,nonatomic) UICollectionView *cardCollect;

@end

@implementation CardSortTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Card Sort";
    //保存当前卡牌设置,暂未实现
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    saveBtn.frame = CGRectMake(0, 0, 44, 44);
    [saveBtn setTitle:@"save" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    //[saveBtn addTarget:self action:@selector(saveToFile) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = saveItem;
    //    //流布局
    //    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //    CGFloat height = (self.view.bounds.size.height - 60 - 64) / 2 + 20;
    //    CGFloat width = height * 68 / 96 + 4;
    //    layout.itemSize = CGSizeMake(width, height);
    
    //CardMasonryLayout *layout = [[CardMasonryLayout alloc] init];//随机流布局。。。有点不好用
    
//    PuriLayout *layout = [[PuriLayout alloc] init];//圆形布局
//    CGFloat startAngle = M_PI;
//    CGFloat endAngle = 0;
//    CGFloat radius = SCREEN_WIDTH/2 - ITEM_WIDTH/2;
//    CGFloat angularSpacing = 1;
//    [layout initWithCentre:CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2) radius:radius itemSize:CGSizeMake(ITEM_WIDTH*2, ITEM_HEIGHT*2) andAngularSpacing:angularSpacing];//这个的中心点的位置是相对于collectionview来说的
//    [layout setStartAngle:startAngle endAngle:endAngle];
//    layout.mirrorX = NO;
//    layout.mirrorY = NO;
//    layout.rotateItems = YES;
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    CardCoverFlowLayout *layout = [[CardCoverFlowLayout alloc] init];//3d封面布局
    
    self.cardCollect = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
    self.cardCollect.backgroundColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0];
    self.cardCollect.delegate = self;
    self.cardCollect.dataSource = self;
    [self.view addSubview:self.cardCollect];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 26;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *card = @"devilCard";
    [self.cardCollect registerClass:[CardSortTestCollectionViewCell class] forCellWithReuseIdentifier:card];
    CardSortTestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:card forIndexPath:indexPath];
    [cell.cardImage setContentMode:UIViewContentModeScaleAspectFit];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",(long)indexPath.item]];
    cell.cardImage.image = image;
    cell.cardName.text = [NSString stringWithFormat:@"%ld",(long)indexPath.item];
    cell.cardName.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
