//
//  Slider.m
//  tmp
//
//  Created by Bourbon on 15/12/11.
//  Copyright © 2015年 Bourbon. All rights reserved.
//

#import "Slider.h"

@implementation Slider

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
        self.minimumValue = 10;
        self.maximumValue = 120;
    }
    return self;
}
-(CGRect)trackRectForBounds:(CGRect)bounds
{
    NSLog(@"%@",NSStringFromCGRect(bounds));
    return bounds;
}
@end
