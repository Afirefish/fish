//
//  CardCoverFlowLayout.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/11/6.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//
//3d流水布局
#import "CardCoverFlowLayout.h"

#define ZOOM_FACTOR 0.35

@implementation CardCoverFlowLayout

-(void) prepareLayout {
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGSize size = self.collectionView.frame.size;
    //调整这里的值即可以显示风格
    self.itemSize = CGSizeMake(size.width/4.0f, (size.height - 64) * 0.35);
    self.sectionInset = UIEdgeInsetsMake(size.height * 0.05, size.height * 0.05, size.height * 0.1, size.height * 0.05);//与周围的距离
    //self.itemSize = CGSizeMake(size.width/4.0f, size.height*0.7 - 64);
    //self.sectionInset = UIEdgeInsetsMake(size.height * 0.15, size.height * 0.1 , size.height * 0.15, size.height * 0.1);//与周围的距离
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {//继承layout
    NSArray *originalArray = [super layoutAttributesForElementsInRect:rect];
    NSArray *array = [[NSArray alloc] initWithArray:originalArray copyItems:YES];
    CGRect visibleRect;//可见的rect
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    float collectionViewHalfFrame = self.collectionView.frame.size.width/2.0f;//一半的宽度
    for (UICollectionViewLayoutAttributes* attributes in array) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {//获得在rect内的cell
            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;//可见的rect的中心减去某一个cell的中心的距离s
            CGFloat normalizedDistance = distance / collectionViewHalfFrame;//距离和当前collectionview一半的比值，越远越大
            if (ABS(distance) < collectionViewHalfFrame) {//如果这个值小于一半
                CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));//放大倍数
                CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
                rotationAndPerspectiveTransform.m34 = 1.0 / -500;
                rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, (normalizedDistance) * M_PI_4, 0.0f, 1.0f, 0.0f);//y轴不为0,逆时针旋转
                CATransform3D zoomTransform = CATransform3DMakeScale(zoom, zoom, 1.0);//x y轴放大zoom倍
                attributes.transform3D = CATransform3DConcat(zoomTransform, rotationAndPerspectiveTransform);//叠加变换
                //attributes.zIndex = ABS(normalizedDistance) * 10.0f;//距离越远，值越大，z轴变大了？视图在上面,这里应该反过来
                attributes.zIndex = (1 - ABS(normalizedDistance)) * 100.0f;
                CGFloat alpha = (1 - ABS(normalizedDistance)) + 0.1;//距离越远，值越小，颜色越浅
                if(alpha > 1.0f) alpha = 1.0f;
                attributes.alpha = alpha;
            } else {
                attributes.alpha = 0.0f;
            }
        }
    }
    return array;
}

//保持中央位置cell
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    //获取将要停下的位置
    CGRect rect;
    rect.origin.x = proposedContentOffset.x;
    rect.origin.y = 0;
    rect.size = self.collectionView.frame.size;
    NSArray * array = [super layoutAttributesForElementsInRect:rect];
    CGFloat centerX = self.collectionView.frame.size.width / 2 + proposedContentOffset.x;
    //存放的最小间距
    CGFloat minDelta = MAXFLOAT;
    for (UICollectionViewLayoutAttributes * attrs in array) {//找到最近的cell
        if (ABS(minDelta) > ABS(attrs.center.x - centerX)) {
            minDelta = attrs.center.x-centerX;
        }
    }
    // 原有的偏移量加上最近的cell离中心点的距离
    proposedContentOffset.x += minDelta;
    return proposedContentOffset;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {//布局改变刷新cell
    return YES;
}

@end
