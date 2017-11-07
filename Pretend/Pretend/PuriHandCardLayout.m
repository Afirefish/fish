//
//  PuriHandCardLayout.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/11/2.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

//手牌的布局
#import "PuriHandCardLayout.h"
#import "PuriHandCardAttributes.h"
#import <math.h>

#define COLLECTION_WIDTH self.collectionView.bounds.size.width
#define COLLECTION_HEIGHT self.collectionView.bounds.size.height
#define ITEM_WIDTH 136
#define ITEM_HEIGHT 192

@interface PuriHandCardLayout()
@property (strong, nonatomic) NSMutableArray *attributes;
@property (nonatomic, assign) CGFloat radius;//半径
@property (nonatomic, assign) NSInteger cellCount;//cell数量
@property (nonatomic, assign) CGSize itemSize;//cell的大小
@property (nonatomic, assign) CGFloat anglePerItem;//每个cell的角度
@property (nonatomic, assign) CGFloat angleAtExtreme;//最大的角度
@property (nonatomic, assign) CGFloat maxAngle;//显示cell的最大角度

@end


@implementation PuriHandCardLayout

- (void)prepareLayout {
    [super prepareLayout];
    self.itemSize = CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT);//cell的大小事先设定好
    self.radius = 500;//半径设定好
    self.anglePerItem = atan(ITEM_WIDTH  / _radius);//每个cell占有的角度，防止距离过远
    self.cellCount = [self.collectionView numberOfItemsInSection:0];//cell的数量从数据源取得
    self.angleAtExtreme = (self.cellCount > 0) ? - (self.cellCount - 1) * self.anglePerItem : 0;//最大的偏移角度为cell数量减1乘上cell的角度
    self.maxAngle = atan2(ITEM_HEIGHT / 2 + COLLECTION_WIDTH / 2 , self.radius - COLLECTION_HEIGHT);//获得视图的角度的

}

- (CGSize)collectionViewContentSize {//返回collectionView的内容的尺寸
    CGSize contentSize = CGSizeMake([self.collectionView numberOfItemsInSection:0] * ITEM_WIDTH, COLLECTION_HEIGHT);//collection view的内容宽设定为cell数量乘上cell的宽度，高度设定为collection view自身高度
    return contentSize;
}


- (NSArray<PuriHandCardAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {//返回cell的布局数组
    NSMutableArray* attributes = [NSMutableArray array];;
    for (NSInteger i=0 ; i < self.cellCount; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        PuriHandCardAttributes *attr = (PuriHandCardAttributes *)[self layoutAttributesForItemAtIndexPath:indexPath];
        if (CGRectIntersectsRect(rect, attr.frame) && attr.alpha != 0) {
            [attributes addObject:attr];
        }
    }
    return attributes;
}

- (PuriHandCardAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path {//设定每一个cell的布局
    PuriHandCardAttributes* attributes = [PuriHandCardAttributes layoutAttributesForCellWithIndexPath:path];//自定义的布局属性来初始化
    attributes.size = CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT);//cell大小为设定好的大小，这里直接赋值为_itemSize也行
    CGFloat centerX = self.collectionView.contentOffset.x + COLLECTION_WIDTH /2;//cell的中心点的横坐标设置为偏移量的横坐标（其实也只会x轴偏移）加上collection view的宽度
    attributes.center =  CGPointMake(centerX, COLLECTION_HEIGHT / 2 - ITEM_HEIGHT / 4);//cell的中心点，高度为collection view的高度的一半减去cell的四分之一大小,这样可以显示完全。。
    CGFloat angle = self.angleAtExtreme * self.collectionView.contentOffset.x / (self.collectionViewContentSize.width - COLLECTION_WIDTH);//偏移角度为最大的偏移角度乘上偏移量和最大偏移量的比值
    attributes.angle = angle + self.anglePerItem * path.item;//cell的角度为cell的索引乘以每个cell的角度加上偏移的角度
    attributes.zIndex = (NSInteger)attributes.angle * 1000000;//cell在y轴上的坐标,越来越大，后面的cell覆盖在前面的cell上面
    attributes.transform = CGAffineTransformMakeRotation(attributes.angle);//cell的样式是旋转cell的角度的样式
    //NSLog(@"%ld att %f angle %f",(long)path.item,attributes.center.x,attributes.angle );
    if (attributes.angle < -self.maxAngle || attributes.angle > self.maxAngle) {//隐藏在视图外面的cell
        attributes.alpha = 0;
    }
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {//布局改变刷新cell
    return YES;
}

//中间的cell停在正中心 成功了
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGPoint finalContentOffset = proposedContentOffset;
    CGFloat factor = - self.angleAtExtreme / (self.collectionViewContentSize.width - COLLECTION_WIDTH);//角度和内容的比率
    CGFloat proposedAngle = proposedContentOffset.x * factor;//当前偏移角度
    CGFloat ratio = proposedAngle / self.anglePerItem;//偏移角度对应的cell
    CGFloat multiplier = 0;
    if (velocity.x > 0) {//cell取整
        multiplier = ceil(ratio);
    } else if (velocity.x < 0) {
        multiplier = floor(ratio);
    } else {
        multiplier = round(ratio);
    }
    finalContentOffset.x = multiplier * self.anglePerItem / factor;//设置好新的偏移量
    return finalContentOffset;
}

//开始的cell
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForInsertedItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.alpha = 0.0;
    attributes.center = CGPointMake(COLLECTION_WIDTH / 2, COLLECTION_HEIGHT / 2 - ITEM_HEIGHT / 4);
    return attributes;
}

//结束的cell
- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDeletedItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.alpha = 0.0;
    attributes.center = CGPointMake(COLLECTION_WIDTH / 2, COLLECTION_HEIGHT / 2 - ITEM_HEIGHT / 4);
    attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
    return attributes;
}

@end
