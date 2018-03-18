//
//  PuriLayout.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/11/2.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

//暂时没有用到的圆形布局写法
#import "PuriLayout.h"

@implementation PuriLayout {
    CGFloat angleOfEachItem;
    CGFloat angleForSpacing;
    CGFloat circumference;
    long cellCount;
    CGFloat maxNoOfCellsInCircle;
    CGFloat _startAngle;
    CGFloat _endAngle;
}

- (id)init {
    self = [super init];
    if (self) {
        _startAngle = M_PI;
        _endAngle = 0;
    }
    return self;
}

//centre圆心～radius圆半径～itemSize卡牌的大小～angularSpacing角度距离~
-(void)initWithCentre:(CGPoint)centre radius:(CGFloat)radius itemSize:(CGSize)itemSize andAngularSpacing:(CGFloat)angularSpacing{
    self.centre = centre;
    self.radius = radius;
    self.itemSize = itemSize;
    self.angularSpacing = angularSpacing;
}

//设置起始位置
-(void)setStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle{
    _startAngle = startAngle;
    _endAngle = endAngle;
    if(_startAngle == 2*M_PI){
        _startAngle = 2*M_PI - M_PI/180;
    }
    if(_endAngle == 2*M_PI){
        _endAngle = 2*M_PI - M_PI/180;
    }
}

//准备显示
-(void)prepareLayout{
    [super prepareLayout];
    cellCount = [self.collectionView numberOfItemsInSection:0];
    circumference = ABS(_startAngle - _endAngle)*_radius;//圆弧长度
    maxNoOfCellsInCircle =  circumference/(MAX(self.itemSize.width, self.itemSize.height) + self.angularSpacing/2);//卡牌的最大数量
    angleOfEachItem = ABS(_startAngle - _endAngle)/maxNoOfCellsInCircle;//每一张卡牌的角度
}

//返回视图大小
-(CGSize)collectionViewContentSize{
    CGFloat visibleAngle = ABS(_startAngle - _endAngle);//当前可见的角度
    long remainingItemsCount = cellCount > maxNoOfCellsInCircle ? cellCount - maxNoOfCellsInCircle : 0;//剩下的卡牌的数量
    CGFloat scrollableContentWidth = (remainingItemsCount+1)*angleOfEachItem*_radius/(2*M_PI/visibleAngle);//可滚动内容宽度,弧度就行了呀，为什么要除以这个2pi和当前角度的比例，似乎是为了在达到2pi前留出小小的一些空间，在2pi的时候恰好为2pi

    CGFloat height = _radius + (MAX(_itemSize.width, _itemSize.height)/2);

    if(_scrollDirection == UICollectionViewScrollDirectionVertical)//如果能够水平滑动，设置宽度大一些，否则，高度大一些
    {
        return CGSizeMake(height, scrollableContentWidth + self.collectionView.bounds.size.height);
    }
    return CGSizeMake(scrollableContentWidth + self.collectionView.bounds.size.width, height);
}


//cell的设置
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_scrollDirection == UICollectionViewScrollDirectionVertical)
    {
        return [self layoutAttributesForVerticalScrollForItemAtIndexPath:indexPath];
    }
    return [self layoutAttributesForHorozontalScrollForItemAtIndexPath:indexPath];
}



//每一个cell的设置 水平滑动
-(UICollectionViewLayoutAttributes *)layoutAttributesForHorozontalScrollForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    CGFloat offset = self.collectionView.contentOffset.x;
    offset = offset == 0 ? 1 : offset;//如果当前偏移为0，那么设置为1，否则不变,为了后面的除法
    CGFloat arcOffset = offset * M_PI_2;
    CGFloat angle = arcOffset/self.radius;//我觉得是这样的
    //CGFloat offsetPartInMPI = offset/circumference;//当前偏移量和圆弧的比例
    //CGFloat angle = 2*M_PI*offsetPartInMPI;//
    CGFloat offsetAngle = angle;//偏移的角度

    attributes.size = self.itemSize;//设置了cell的大小
    int mirrorX = self.mirrorX ? -1 : 1;//传入no值，初始化为1，控制正向旋转还是反向旋转
    int mirrorY = self.mirrorY ? -1 : 1;

    CGFloat x = self.centre.x + offset + mirrorX*(_radius*cosf(indexPath.item*angleOfEachItem - offsetAngle + angleOfEachItem/2 - _startAngle));//圆心变换，然后加上开始位置的角度与当前cell中心点角度的角度差计算出来的x值
    CGFloat y = self.centre.y + mirrorY*(_radius*sinf(indexPath.item*angleOfEachItem - offsetAngle + angleOfEachItem/2 - _startAngle));
    //NSLog(@"indexPath %ld attributes x %f,y %f,_radius %f",(long)indexPath.row,x,y,_centre.x + offset);
    CGFloat cellCurrentAngle = (indexPath.item*angleOfEachItem + angleOfEachItem/2 - offsetAngle);//当前cell的角度
    if(cellCurrentAngle >= -angleOfEachItem/2 && cellCurrentAngle <= ABS(_startAngle - _endAngle) + angleOfEachItem/2){//当当前的角度大于cell的一半的角度，并且小于设置的角度加上自己一半的角度时，显示
        attributes.alpha = 1;
    }else{
        attributes.alpha = 0;
    }

    attributes.center = CGPointMake(x, y);//当前cell的中心点
    attributes.zIndex = cellCount - indexPath.item;//在z轴的位置
    if(self.rotateItems){
        if(self.mirrorY){
            attributes.transform = CGAffineTransformMakeRotation(M_PI_2 - cellCurrentAngle);//旋转
        }else{
            attributes.transform = CGAffineTransformMakeRotation(cellCurrentAngle - M_PI/2);
        }
    }
    return attributes;
}

//垂直滑动
-(UICollectionViewLayoutAttributes *)layoutAttributesForVerticalScrollForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat offset = self.collectionView.contentOffset.y;
    offset = offset == 0 ? 1 : offset;
    CGFloat offsetPartInMPI = offset/circumference;
    CGFloat angle = 2*M_PI*offsetPartInMPI;
    CGFloat offsetAngle = angle;
    
    attributes.size = self.itemSize;
    int mirrorX = self.mirrorX ? -1 : 1;
    int mirrorY = self.mirrorY ? -1 : 1;
    
    CGFloat x = self.centre.x + mirrorX*(_radius*cosf(indexPath.item*angleOfEachItem - offsetAngle + angleOfEachItem/2 - _startAngle));
    CGFloat y = _centre.y + offset + mirrorY*(_radius*sinf(indexPath.item*angleOfEachItem - offsetAngle + angleOfEachItem/2 - _startAngle));
    
    CGFloat cellCurrentAngle = indexPath.item*angleOfEachItem + angleOfEachItem/2 - offsetAngle;
    
    if(cellCurrentAngle >= -angleOfEachItem/2 && cellCurrentAngle <= ABS(_startAngle - _endAngle) + angleOfEachItem/2){
        attributes.alpha = 1;
    }else{
        attributes.alpha = 0;
    }
    
    attributes.center = CGPointMake(x, y);
    attributes.zIndex = cellCount - indexPath.item;
    if(self.rotateItems){
        if(self.mirrorX){
            attributes.transform = CGAffineTransformMakeRotation(2*M_PI - cellCurrentAngle);
        }else{
            attributes.transform = CGAffineTransformMakeRotation(cellCurrentAngle);
        }
    }
    
    return attributes;
}

//展示全部的cell
-(NSArray <__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray<__kindof UICollectionViewLayoutAttributes *> *attributes = [NSMutableArray array];
    for(NSInteger i=0; i < cellCount; i++){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *cellAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        if(CGRectIntersectsRect(rect, cellAttributes.frame) && cellAttributes.alpha != 0){//如果当前cell在视图的frame内，并且没有被隐藏，则把这个加入
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    attributes.center = CGPointMake(self.centre.x + self.collectionView.contentOffset.x, self.centre.y + self.collectionView.contentOffset.y);
    attributes.alpha = 0.2;
    attributes.transform = CGAffineTransformMakeScale(0.5, 0.5);
    return attributes;
    
}

- (UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    attributes.center = CGPointMake(self.centre.x + self.collectionView.contentOffset.x, self.centre.y + self.collectionView.contentOffset.y);
    attributes.alpha = 0.2;
    attributes.transform = CGAffineTransformMakeScale(0.5, 0.5);
    return attributes;
    
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}



@end
