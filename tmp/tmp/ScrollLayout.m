//
//  ScrollLayout.m
//  tmp
//
//  Created by Bourbon on 15/11/11.
//  Copyright © 2015年 Bourbon. All rights reserved.
//

#import "ScrollLayout.h"

@interface ScrollLayout ()
{
    CGFloat itemWith;
    CGFloat itemHeight;
    CGFloat space;
    CGFloat count;
    int offset;
}
@end
@implementation ScrollLayout
-(instancetype)init
{
    if (self = [super init]) {
        itemHeight = 480/3;
        itemWith = 480/3;
        space = 18.4;
        self.collectionView.pagingEnabled = NO;

    }
    return self;
}
-(void)prepareLayout
{
    [super prepareLayout];
    count = [self.collectionView numberOfItemsInSection:0];
    offset = self.collectionView.contentOffset.x / itemWith;
}
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < count; i ++) {
        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:index];
        [array addObject:attributes];
    }
    return array;
}
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    attributes.center = CGPointMake(itemWith/2.0 + (itemWith+space)*indexPath.item , self.collectionView.frame.size.height/2.0);
    attributes.size = CGSizeMake(itemWith, itemHeight);
    
    
    return attributes;
    

}
-(CGFloat)minimumInteritemSpacing
{
    return space;
}
-(CGFloat)minimumLineSpacing
{
    return space;
}
-(CGSize)collectionViewContentSize
{
    return CGSizeMake(itemWith * count + space * (count - 1), 100);
}

@end
