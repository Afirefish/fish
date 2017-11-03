//
//  BaseCardCraftViewController.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/31.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "BaseCardCraftViewController.h"
#import "CardCell.h"
#import "PuriLayout.h"
#import "PuriHandCardLayout.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define ITEM_WIDTH 68
#define ITEM_HEIGHT 96

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
    self.cellCount = 20;

    self.view.backgroundColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0];
    [self setPuriHandCardLayout];
}


-(void)setPuriHandCardLayout{
    PuriLayout *layout = [[PuriLayout alloc] init];
    [layout initWithCentre:CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height/2) radius:self.view.bounds.size.width/2 - ITEM_WIDTH/2 itemSize:CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT) andAngularSpacing:20];
    [layout setStartAngle:M_PI * 5/6 endAngle:M_PI / 6];
    layout.mirrorX = NO;
    layout.mirrorY = NO;
    layout.rotateItems = YES;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    PuriHandCardLayout *layout = [[PuriHandCardLayout alloc] init];
    self.handCard = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height * 2 / 3, self.view.bounds.size.width, self.view.bounds.size.height / 3) collectionViewLayout:layout];
    NSLog(@"handCard frame %@",self.handCard);
    self.handCard.delegate = self;
    self.handCard.dataSource = self;
    //self.handCard = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
    self.handCard.backgroundColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0];
    [self.view addSubview:self.handCard];
    [self.handCard registerClass:[CardCell class] forCellWithReuseIdentifier:card];
    [self.handCard reloadData];
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
    CardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:card forIndexPath:indexPath];
    cell.cardImage.image = [UIImage imageNamed:@"p1.png"];
    cell.cardName.text = @"霜月";
    cell.cardName.textAlignment = NSTextAlignmentCenter;
    return cell;
}


@end
