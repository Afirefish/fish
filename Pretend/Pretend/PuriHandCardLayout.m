//
//  PuriHandCardLayout.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/11/2.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "PuriHandCardLayout.h"
#import <math.h>

#define ITEM_SIZE 70

@interface PuriHandCardLayout()
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) NSInteger cellCount;


@end


@implementation PuriHandCardLayout


- (void)prepareLayout {
    [super prepareLayout];
    CGSize size = self.collectionView.frame.size;
    _cellCount = [[self collectionView] numberOfItemsInSection:0];
    _center = CGPointMake(size.width / 2.0, size.height / 2.0);
    _radius = MIN(size.width, size.height) / 2.5;
}

- (CGSize)collectionViewContentSize {//返回collectionView的内容的尺寸
    //CGSize contentSize = CGSizeMake([self.collectionView numberOfItemsInSection:0] * self.cardWidth, self.collectionView.bounds.size.height);
    return [self collectionView].frame.size;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path {
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];
    attributes.size = CGSizeMake(ITEM_SIZE, ITEM_SIZE);
    attributes.center = CGPointMake(_center.x + _radius * cosf(2 * path.item * M_PI / _cellCount),
                                    _center.y + _radius * sinf(2 * path.item * M_PI / _cellCount));
    return attributes;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger i=0 ; i < self.cellCount; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;
}




























//- (void)setRadius:(CGFloat)radius {//每次设置值刷新
//    self.radius = radius;
//    [self invalidateLayout];
//}
//
//- (CGFloat)anglePerItem {
//    return atan(self.itemSize.width/radius);
//}

//- (void)prepareLayout {//准备方法被自动调用，以保证layout实例的正确。
//    self.itemCount = [self.collectionView numberOfItemsInSection:0];
//    self.center = CGPointMake(self.collectionView.bounds.size.width / 2, self.collectionView.bounds.size.height / 2);
//    self.radius = 500;
//    CGFloat height = self.collectionView.bounds.size.height;
//    CGFloat width = height * 68 / 96;
//    self.itemSize = CGSizeMake(height, width);
//    self.anglePerItem = atan(self.itemSize.width / self.radius);
//    
//}
//
//
//- (CGSize)collectionViewContentSize {//返回collectionView的内容的尺寸
//    CGSize contentSize = CGSizeMake([self.collectionView numberOfItemsInSection:0] * self.itemSize.width, self.collectionView.bounds.size.height);
//    return contentSize;
//}
//
//- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {//返回的是包含UICollectionViewLayoutAttributes的NSArray
//    NSMutableArray *arr = [NSMutableArray array];
//    for (NSInteger i = 0; i < self.itemCount; i ++) {
//        [arr addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]];
//    }
//    return arr;
//}
//
//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {//返回对应于indexPath的位置的cell的布局属性
//    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//
//    //    self.anchorPoint = CGPointMake(0.5, 0.5);
////    self.angle = angle;
////    attr.zIndex  = angle * 1000000;
////    self.transform = CGAffineTransformMakeRotation(angle);
//    
//    CGFloat angele = 2 * M_PI /self.itemCount * indexPath.row + M_PI_2 * self.originAngle;
//    CGFloat x = self.center.x + cos(angele) * self.radius;
//    CGFloat y = self.center.y - sin(angele) * self.radius;
//    attr.center = CGPointMake(x, y);
//
//    attr.size = self.itemSize;
//    return attr;
//}

@end
