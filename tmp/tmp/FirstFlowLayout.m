//
//  FirstFlowLayout.m
//  tmp
//
//  Created by Bourbon on 15/11/12.
//  Copyright © 2015年 Bourbon. All rights reserved.
//

#import "FirstFlowLayout.h"

@implementation FirstFlowLayout
{
    CGSize itemSize;
    NSInteger count;
    CGFloat space;
}
-(void)prepareLayout
{
    [super prepareLayout];
    
    [self setScrollDirection:(UICollectionViewScrollDirectionHorizontal)];
    itemSize = CGSizeMake(100, 100);
    count = [self.collectionView numberOfItemsInSection:0];
    space = 90/2;
}
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < count; i++)
    {
        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:index];
        
        attributes.center = CGPointMake(space + itemSize.width/2.0 + (i/2) * (itemSize.width + space),
                                        self.collectionView.frame.size.height - 150- (itemSize.height/2.0 + space + (itemSize.height + space) * ((i+1)%2)));
        attributes.size = itemSize;
        [array addObject:attributes];
    }
    return array;
}
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    return attributes;
}
-(CGSize)collectionViewContentSize
{
    return CGSizeMake((itemSize.width + space) * count/2 + space , itemSize.width * 2 + space * 3);
}

@end
