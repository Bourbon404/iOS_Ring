//
//  PullLayout.m
//  tmp
//
//  Created by Bourbon on 15/11/11.
//  Copyright © 2015年 Bourbon. All rights reserved.
//

#import "PullLayout.h"

@implementation PullLayout
{
    NSMutableArray *heightArray;
}
-(void)prepareLayout
{
    [super prepareLayout];
    heightArray = [NSMutableArray array];
    for (int i = 0; i < 80; i ++) {
        srand((unsigned)time(0));
        NSNumber *number = [NSNumber numberWithInt:(arc4random()%6+1)*20];
        [heightArray addObject:number];
    }
}
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<[self.collectionView numberOfItemsInSection:0]; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:index];
        
        if (i >= 3) {
            
            CGRect tmpFrame = attributes.frame;
            
            UICollectionViewLayoutAttributes *preAttributes = [array objectAtIndex:(i-3)];
            tmpFrame.origin.y = preAttributes.frame.size.height + preAttributes.frame.origin.y + 10;

            attributes.frame = tmpFrame;
            
        }
        
        
        [array addObject:attributes];
    }
    return array;
}
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    int width = 150;
    int space = 10;
    CGRect tmpFrame = attributes.frame;
    tmpFrame.origin.x = indexPath.item%3 * (width + space);
    tmpFrame.size.width = width;
    NSNumber *number = [heightArray objectAtIndex:indexPath.item];
    tmpFrame.size.height = number.integerValue;
    tmpFrame.origin.y = 0;
    attributes.frame = tmpFrame;
    
    return attributes;
}
-(CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.frame.size.width, 5000);
}
@end
