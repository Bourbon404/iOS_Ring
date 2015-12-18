//
//  Layout.m
//  tmp
//
//  Created by Bourbon on 15/11/10.
//  Copyright © 2015年 Bourbon. All rights reserved.
//

#import "Layout.h"

#define ITEM_SIZE 70

@interface Layout ()

@property (nonatomic,assign) CGPoint center;
@property (nonatomic,assign) CGFloat radius;
@property (nonatomic,assign) NSInteger cellCount;

@end
@implementation Layout

-(void)prepareLayout
{
    [super prepareLayout];
    
    CGSize size = self.collectionView.frame.size;
    _cellCount = [self.collectionView numberOfItemsInSection:0];
    _center = CGPointMake(size.width/2.0, size.height/2.0);
    _radius = MIN(size.width, size.height)/2.5;
    
}
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.center = CGPointMake(_center.x + cosf(2 * indexPath.item * M_PI / _cellCount) * _radius,
                                    _center.y + sinf(2 * indexPath.item * M_PI / _cellCount) * _radius);
    
    if (sinf(2 * indexPath.item * M_PI / _cellCount) == -1) {
        attributes.size = CGSizeMake(ITEM_SIZE+20, ITEM_SIZE+20);

    }else{
        attributes.size = CGSizeMake(ITEM_SIZE, ITEM_SIZE);

    }
    
    return attributes;
}
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger i=0 ; i < self.cellCount; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;
}
@end
