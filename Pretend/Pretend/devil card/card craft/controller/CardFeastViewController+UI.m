//
//  CardFeastViewController+UI.m
//  Pretend
//
//  Created by daixijia on 2017/12/22.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "CardFeastViewController+UI.h"
#import <Masonry.h>

@implementation CardFeastViewController (UI)

//设置集合视图
- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    CGFloat height = 100.0;
    CGFloat width = height;
    layout.itemSize = CGSizeMake(width, height);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }
        else {
            make.left.right.bottom.equalTo(self.view);
        }
        make.height.equalTo(@(height + 20.0));
    }];
}

- (void)setupScrollView {
    CGFloat screenWidth = (CGRectGetWidth([UIScreen mainScreen].bounds) < CGRectGetHeight([UIScreen mainScreen].bounds))?CGRectGetWidth([UIScreen mainScreen].bounds) : CGRectGetHeight([UIScreen mainScreen].bounds);
    CGFloat itemWidth = (screenWidth - 50) / 2;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 120.0)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    //self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    //self.scrollView.alwaysBounceVertical = YES;
    //self.scrollView.alwaysBounceHorizontal = YES;
    self.scrollView.contentSize = CGSizeMake(screenWidth * 2, itemWidth * 3 + 80.0);
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        }
        else {
            make.left.right.top.equalTo(self.view);
        }
        make.bottom.equalTo(self.collectionView.mas_top);
    }];
    
    //决赛视图
    self.championView = [[UIImageView alloc] init];
    [self.scrollView addSubview:self.championView];
    [self.championView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(screenWidth - itemWidth / 2);
        make.top.equalTo(self.scrollView).offset(20.0);
        make.height.width.equalTo(@(itemWidth));
    }];
    
    //半决赛视图
    UIImageView *firstOfSemiFinal = [[UIImageView alloc] init];
    [self.scrollView addSubview:firstOfSemiFinal];
    [firstOfSemiFinal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(itemWidth / 2 + 20);
        make.top.equalTo(self.championView.mas_bottom).offset(20.0);
        make.height.width.equalTo(self.championView);
    }];
    
    UIImageView *secondOfSemiFinal = [[UIImageView alloc] init];
    [self.scrollView addSubview:secondOfSemiFinal];
    [secondOfSemiFinal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(firstOfSemiFinal).offset(screenWidth);
        make.top.height.width.equalTo(firstOfSemiFinal);
    }];
    self.semiFinalView = @[firstOfSemiFinal, secondOfSemiFinal];
    
    //四强视图
    UIImageView *firstOfQuarterFinal = [[UIImageView alloc] init];
    [self.scrollView addSubview:firstOfQuarterFinal];
    [firstOfQuarterFinal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(20.0);
        make.top.equalTo(firstOfSemiFinal.mas_bottom).offset(20.0);
        make.height.width.equalTo(@(itemWidth));
    }];

    UIImageView *secondOfQuarterFinal = [[UIImageView alloc] init];
    [self.scrollView addSubview:secondOfQuarterFinal];
    [secondOfQuarterFinal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(firstOfQuarterFinal.mas_right).offset(10.0);
        make.height.width.top.equalTo(firstOfQuarterFinal);
    }];

    UIImageView *thirdOfQuarterFinal = [[UIImageView alloc] init];
    [self.scrollView addSubview:thirdOfQuarterFinal];
    [thirdOfQuarterFinal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(secondOfQuarterFinal.mas_right).offset(40.0);
        make.height.width.top.equalTo(firstOfQuarterFinal);
    }];

    UIImageView *fourthOfQuarterFinal = [[UIImageView alloc] init];
    [self.scrollView addSubview:fourthOfQuarterFinal];
    [fourthOfQuarterFinal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(thirdOfQuarterFinal.mas_right).offset(10.0);
        make.height.width.top.equalTo(firstOfQuarterFinal);
    }];
    self.quarterFinalView = @[firstOfQuarterFinal, secondOfQuarterFinal, thirdOfQuarterFinal, fourthOfQuarterFinal];
}

@end
