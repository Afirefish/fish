//
//  CardFeastViewController.h
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/30.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardFeastViewController : UIViewController<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;//会场对战流程的视图
@property (nonatomic, strong) UICollectionView *collectionView;//所有的对手的视图

@end
