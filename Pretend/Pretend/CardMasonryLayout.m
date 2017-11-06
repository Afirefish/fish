//
//  CardMasonryLayout.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/11/6.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

//发现动态获得布局的高度和宽度不太好用 待修改
#import "CardMasonryLayout.h"

#define COLLECTION_WIDTH self.collectionView.bounds.size.width
#define COLLECTION_HEIGHT self.collectionView.bounds.size.height


@interface CardMasonryLayout()

@property (nonatomic, strong) NSMutableDictionary *lastYValueForColumn;
@property (strong, nonatomic) NSMutableDictionary *layoutInfo;
@end

@implementation CardMasonryLayout

-(void) prepareLayout {
    
    self.numberOfColumns = 3;//三行
    self.interItemSpacing = 12.5;//间距
    
    self.lastYValueForColumn = [NSMutableDictionary dictionary];
    CGFloat currentColumn = 0;
    CGFloat fullWidth = self.collectionView.frame.size.width;//总宽度
    CGFloat availableSpaceExcludingPadding = fullWidth - (self.interItemSpacing * (self.numberOfColumns + 1));//可用的除去间距的宽度，间距数设定为行数+1
    CGFloat itemWidth = availableSpaceExcludingPadding / self.numberOfColumns;//每一个cell的宽度
    self.layoutInfo = [NSMutableDictionary dictionary];
    NSIndexPath *indexPath;
    NSInteger numSections = [self.collectionView numberOfSections];
    
    for(NSInteger section = 0; section < numSections; section++)  {//如果有多个section，循环
        
        NSInteger numItems = [self.collectionView numberOfItemsInSection:section];
        for(NSInteger item = 0; item < numItems; item++){
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *itemAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            CGFloat x = self.interItemSpacing + (self.interItemSpacing + itemWidth) * currentColumn;//x值为宽度加上当前行数乘以cell宽
            CGFloat y = [self.lastYValueForColumn[@(currentColumn)] doubleValue];//读取当前currentColumn键值？

            CGFloat height = 100 + (arc4random() % 140);//获得高度
            
            itemAttributes.frame = CGRectMake(x, y, itemWidth, height);//设置frame
            y+= height;
            y += self.interItemSpacing;//y值加上间距
            
            self.lastYValueForColumn[@(currentColumn)] = @(y);//设置键值为更新后的y值
            
            currentColumn ++;//设置第二行
            if(currentColumn == self.numberOfColumns) currentColumn = 0;//如果到了第三行了，初始化为0
            self.layoutInfo[indexPath] = itemAttributes;//添加到数组
        }
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                         UICollectionViewLayoutAttributes *attributes,
                                                         BOOL *stop) {
        
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [allAttributes addObject:attributes];
        }
    }];
    return allAttributes;
}

-(CGSize) collectionViewContentSize {
    
    NSUInteger currentColumn = 0;
    CGFloat maxHeight = 0;
    do {
        CGFloat height = [self.lastYValueForColumn[@(currentColumn)] doubleValue];
        if(height > maxHeight)
            maxHeight = height;
        currentColumn ++;
    } while (currentColumn < self.numberOfColumns);
    
    return CGSizeMake(self.collectionView.frame.size.width, maxHeight);
}

@end
