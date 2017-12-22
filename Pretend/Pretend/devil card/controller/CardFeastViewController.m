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
#import "FeastView.h"
#import "BaseCardCraftViewController.h"
#import <Masonry.h>

@interface CardFeastViewController ()
@property (nonatomic,strong) FeastView *feastView;

@end

@implementation CardFeastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Card Feast";
    //宴会的场面
    self.feastView = [[FeastView alloc] init];
    [self.view addSubview:self.feastView];
    [self.feastView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        }
        else {
            make.edges.equalTo(self.view);
        }
    }];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yuiCraft)];
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
    //[self addBtnTarget];
}

#pragma mark - collectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"text" forIndexPath:indexPath];
    return cell;
}

#pragma mark - collectionView data source

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cell select");
}

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
    BaseCardCraftViewController *yuiCraft = [[BaseCardCraftViewController alloc] initWithName:@"Yui"];
    yuiCraft.navigationItem.title = @"Yui";
    [self.navigationController pushViewController:yuiCraft animated:YES];
}

- (void)kiritoCraft {
    NSLog(@"KIRITO CRAFT");
    BaseCardCraftViewController *kiritoCraft = [[BaseCardCraftViewController alloc] initWithName:@"Kirito"];
    kiritoCraft.navigationItem.title = @"Kirito";
    [self.navigationController pushViewController:kiritoCraft animated:YES];
}

- (void)asunaCraft {
    NSLog(@"ASUNA CRAFT");
    BaseCardCraftViewController *asunaCraft = [[BaseCardCraftViewController alloc] initWithName:@"Asuna"];
    asunaCraft.navigationItem.title = @"Asuna";
    [self.navigationController pushViewController:asunaCraft animated:YES];
}

- (void)leafaCraft {
    NSLog(@"LEAFA CRAFT");
    BaseCardCraftViewController *leafaCraft = [[BaseCardCraftViewController alloc] initWithName:@"Leafa"];
    leafaCraft.navigationItem.title = @"Leafa";
    [self.navigationController pushViewController:leafaCraft animated:YES];
}

- (void)silicaCraft {
    NSLog(@"SILICA CRAFT");
    BaseCardCraftViewController *silicaCraft = [[BaseCardCraftViewController alloc] initWithName:@"Silica"];
    silicaCraft.navigationItem.title = @"Silica";
    [self.navigationController pushViewController:silicaCraft animated:YES];
}

- (void)agilCraft {
    NSLog(@"AGIL CRAFT");
    BaseCardCraftViewController *agilCraft = [[BaseCardCraftViewController alloc] initWithName:@"Agil"];
    agilCraft.navigationItem.title = @"Agil";
    [self.navigationController pushViewController:agilCraft animated:YES];
}

- (void)kleinCraft {
    NSLog(@"KLEIN CRAFT");
    BaseCardCraftViewController *kleinCraft = [[BaseCardCraftViewController alloc] initWithName:@"Klein"];
    kleinCraft.navigationItem.title = @"Klein";
    [self.navigationController pushViewController:kleinCraft animated:YES];
}

- (void)lisbethCraft {
    NSLog(@"LISBETH CRAFT");
    BaseCardCraftViewController *lisbethCraft = [[BaseCardCraftViewController alloc] initWithName:@"Lisbeth"];
    lisbethCraft.navigationItem.title = @"Lisbeth";
    [self.navigationController pushViewController:lisbethCraft animated:YES];
}

@end
