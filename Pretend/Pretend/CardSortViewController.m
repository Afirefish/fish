//
//  CardSortViewController.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/11/2.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "CardSortViewController.h"
#import "CardCell.h"
#import "CardDetailViewController.h"

#define ITEM_WIDTH 68
#define ITEM_HEIGHT 96

@interface CardSortViewController ()
@property (strong,nonatomic) UICollectionView *cardCollect;

@end

@implementation CardSortViewController

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
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //layout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 20);
    CGFloat height = (self.view.bounds.size.height - 60 - 64) / 2 + 20;
    CGFloat width = height * ITEM_WIDTH / ITEM_HEIGHT + 4;
    layout.itemSize = CGSizeMake(width, height);
    self.cardCollect = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
    self.cardCollect.backgroundColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0];
    self.cardCollect.delegate = self;
    self.cardCollect.dataSource = self;
    [self.view addSubview:self.cardCollect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 60;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *card = @"devilCard";
    [self.cardCollect registerClass:[CardCell class] forCellWithReuseIdentifier:card];
    CardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:card forIndexPath:indexPath];
    cell.cardImage.image = [UIImage imageNamed:@"p1.png"];
    cell.cardName.text = @"霜月";
    cell.cardName.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CardDetailViewController *cardDetail = [[CardDetailViewController alloc] init];
    cardDetail.cardImage = [UIImage imageNamed:@"p1.png"];
    cardDetail.navigationItem.title = @"霜月";
    [self.navigationController pushViewController:cardDetail animated:YES];
}

@end
