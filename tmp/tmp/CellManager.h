//
//  CellManager.h
//  tmp
//
//  Created by Bourbon on 15/11/12.
//  Copyright © 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FirstFlowLayout.h"
#import "SecondFlowLayout.h"
#import "ThirdFlowLayout.h"
#import "FirstCollectionViewCell.h"
#import "SecondCollectionViewCell.h"
#import "ThirdCollectionViewCell.h"
@interface CellManager : NSObject

+(UICollectionViewCell *)cellManagerWith:(Class)attributes andCollectionView:(UICollectionView *)collection identifier:(NSString *)identifier andIndex:(NSIndexPath *)index;
@end
