//
//  CardFeastViewController.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/30.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

/*这里不太好用图片实现，于是考虑用一个类似树状图的UIView来实现，Button点击来出发相应 的人物的战斗，直到决出最后胜负*/

#import "CardFeastViewController.h"
#import "CardFeastViewController+UI.h"
#import "CardCrafterCell.h"
#import "UIColor+PRCustomColor.h"
#import "FeastView.h"
#import "BaseCardCraftViewController.h"
#import <Masonry.h>

NSString *cardCrafter = @"cardCrafter";

@interface CardFeastViewController ()
@property (nonatomic,strong) FeastView *feastView;

@end

@implementation CardFeastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Card Feast";
    self.view.backgroundColor = [UIColor smokeWhiteColor];
//    //宴会的场面
//    self.feastView = [[FeastView alloc] init];
//    [self.view addSubview:self.feastView];
//    [self.feastView mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (@available(iOS 11.0, *)) {
//            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
//            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
//            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
//            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
//        }
//        else {
//            make.edges.equalTo(self.view);
//        }
//    }];
    // 设置底部的对战名单视图
    [self setupCollectionView];
    // 设置对战进展视图
    [self setupScrollView];
    // 为视图添加响应的图片 目前默认图片
    [self showQuarterFinal];
    [self.collectionView registerClass:[CardCrafterCell class] forCellWithReuseIdentifier:cardCrafter];
    //[self addBtnTarget];
}

// 这里将会对应设置每个cell的对战状况，玩家从一侧开始战斗，另一侧同玩家一起计算出对战的结果 目前暂定为默认图片
- (void)showQuarterFinal {
    for (UIImageView *view in self.quarterFinalView) {
        view.image = [UIImage imageNamed:@"chiziCrafter"];
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(craftWithCurrentDevil)];
        tapGesture.numberOfTapsRequired = 1;
        [view addGestureRecognizer:tapGesture];
    }
    for (UIImageView *view in self.semiFinalView) {
        view.image = [UIImage imageNamed:@"chiziCrafter"];
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(craftWithCurrentDevil)];
        tapGesture.numberOfTapsRequired = 1;
        [view addGestureRecognizer:tapGesture];
    }
    self.championView.image = [UIImage imageNamed:@"chiziCrafter"];
    self.championView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(craftWithCurrentDevil)];
    tapGesture.numberOfTapsRequired = 1;
    [self.championView addGestureRecognizer:tapGesture];
}

#pragma mark - collectionView delegate

// 底部的卡牌选择之后的响应，目前没有任何事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cell select");
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark - collectionView data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

// 这里将要通过传入一个对战名单来决定每个cell的样子，固定之后一般不会改变
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CardCrafterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cardCrafter forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"chiziCrafter"];
    return cell;
}

- (void)craftWithCurrentDevil {
    NSString *devil = @"santa";
    NSLog(@"%@ CRAFT",devil);
    BaseCardCraftViewController *devilCraft = [[BaseCardCraftViewController alloc] initWithDevilID:0];
//    devilCraft.navigationItem.title = devil;
    [self.navigationController pushViewController:devilCraft animated:YES];
}

#pragma mark - deprecated

- (void)addBtnTarget {
    [self.feastView.yuiBtn addTarget:self action:@selector(yuiCraft) forControlEvents:UIControlEventTouchUpInside];
    [self.feastView.kiritoBtn addTarget:self action:@selector(kiritoCraft) forControlEvents:UIControlEventTouchUpInside];
    [self.feastView.asunaBtn addTarget:self action:@selector(asunaCraft) forControlEvents:UIControlEventTouchUpInside];
    [self.feastView.leafaBtn addTarget:self action:@selector(leafaCraft) forControlEvents:UIControlEventTouchUpInside];
    [self.feastView.silicaBtn addTarget:self action:@selector(silicaCraft) forControlEvents:UIControlEventTouchUpInside];
    [self.feastView.agilBtn addTarget:self action:@selector(agilCraft) forControlEvents:UIControlEventTouchUpInside];
    [self.feastView.kleinBtn addTarget:self action:@selector(kleinCraft) forControlEvents:UIControlEventTouchUpInside];
    [self.feastView.lisbethBtn addTarget:self action:@selector(lisbethCraft) forControlEvents:UIControlEventTouchUpInside];
}

- (void)yuiCraft {
    NSLog(@"YUI CRAFT");
    BaseCardCraftViewController *yuiCraft = [[BaseCardCraftViewController alloc] initWithDevilID:0];
    yuiCraft.navigationItem.title = @"Yui";
    [self.navigationController pushViewController:yuiCraft animated:YES];
}

- (void)kiritoCraft {
    NSLog(@"KIRITO CRAFT");
    BaseCardCraftViewController *kiritoCraft = [[BaseCardCraftViewController alloc] initWithDevilID:0];
    kiritoCraft.navigationItem.title = @"Kirito";
    [self.navigationController pushViewController:kiritoCraft animated:YES];
}

- (void)asunaCraft {
    NSLog(@"ASUNA CRAFT");
    BaseCardCraftViewController *asunaCraft = [[BaseCardCraftViewController alloc] initWithDevilID:0];
    asunaCraft.navigationItem.title = @"Asuna";
    [self.navigationController pushViewController:asunaCraft animated:YES];
}

- (void)leafaCraft {
    NSLog(@"LEAFA CRAFT");
    BaseCardCraftViewController *leafaCraft = [[BaseCardCraftViewController alloc] initWithDevilID:0];
    leafaCraft.navigationItem.title = @"Leafa";
    [self.navigationController pushViewController:leafaCraft animated:YES];
}

- (void)silicaCraft {
    NSLog(@"SILICA CRAFT");
    BaseCardCraftViewController *silicaCraft = [[BaseCardCraftViewController alloc] initWithDevilID:0];
    silicaCraft.navigationItem.title = @"Silica";
    [self.navigationController pushViewController:silicaCraft animated:YES];
}

- (void)agilCraft {
    NSLog(@"AGIL CRAFT");
    BaseCardCraftViewController *agilCraft = [[BaseCardCraftViewController alloc] initWithDevilID:0];
    agilCraft.navigationItem.title = @"Agil";
    [self.navigationController pushViewController:agilCraft animated:YES];
}

- (void)kleinCraft {
    NSLog(@"KLEIN CRAFT");
    BaseCardCraftViewController *kleinCraft = [[BaseCardCraftViewController alloc] initWithDevilID:0];
    kleinCraft.navigationItem.title = @"Klein";
    [self.navigationController pushViewController:kleinCraft animated:YES];
}

- (void)lisbethCraft {
    NSLog(@"LISBETH CRAFT");
    BaseCardCraftViewController *lisbethCraft = [[BaseCardCraftViewController alloc] initWithDevilID:0];
    lisbethCraft.navigationItem.title = @"Lisbeth";
    [self.navigationController pushViewController:lisbethCraft animated:YES];
}

@end
