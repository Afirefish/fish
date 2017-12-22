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

- (void)setupScrollView {
    
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    CGFloat height = CGRectGetHeight(self.collectionView.frame) - 20;
    CGFloat width = height;
    layout.itemSize = CGSizeMake(width, height);
    
    self.collectionView =  [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@(CGRectGetHeight(self.view.frame) * 0.4));
    }];
}

@end
