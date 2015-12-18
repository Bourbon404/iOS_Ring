//
//  CellManager.m
//  tmp
//
//  Created by Bourbon on 15/11/12.
//  Copyright © 2015年 Bourbon. All rights reserved.
//

#import "CellManager.h"

@implementation CellManager


+(UICollectionViewCell *)cellManagerWith:(Class)attributes andCollectionView:(UICollectionView *)collection identifier:(NSString *)identifier andIndex:(NSIndexPath *)index
{
    if ([attributes isSubclassOfClass:[FirstFlowLayout class]])
    {
        FirstCollectionViewCell *cell = (FirstCollectionViewCell *)[collection dequeueReusableCellWithReuseIdentifier:@"cell1" forIndexPath:index];
        [cell setBackgroundColor:[UIColor redColor]];
        return cell;

    }
    else if ([attributes isSubclassOfClass:[SecondFlowLayout class]])
    {
        SecondCollectionViewCell *cell = (SecondCollectionViewCell *)[collection dequeueReusableCellWithReuseIdentifier:@"cell2" forIndexPath:index];
        [cell setBackgroundColor:[UIColor blueColor]];
        return cell;

    }else if ([attributes isSubclassOfClass:[ThirdFlowLayout class]])
    {
        ThirdCollectionViewCell *cell = (ThirdCollectionViewCell *)[collection dequeueReusableCellWithReuseIdentifier:@"cell3" forIndexPath:index];
        [cell setBackgroundColor:[UIColor yellowColor]];
        return cell;
    }
    else
    {
        return  [collection dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:index];
    }
    
}
@end
