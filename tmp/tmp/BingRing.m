//
//  BingRing.m
//  tmp
//
//  Created by Bourbon on 15/12/18.
//  Copyright © 2015年 Bourbon. All rights reserved.
//

#import "BingRing.h"

@implementation BingRing
{
    float currentValue;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextBeginPath(contextRef);
    CGContextAddArc(contextRef, rect.size.width/2, rect.size.height/2, rect.size.height/2, currentValue/2+M_PI_2,-currentValue/2+M_PI_2, YES);
    CGContextAddLineToPoint(contextRef, rect.size.width/2, rect.size.height/2);
    CGContextClosePath(contextRef);
    CGContextSetFillColorWithColor(contextRef, [UIColor colorWithRed:80/255.0 green:185/255.0 blue:255/255.0 alpha:0.6].CGColor);
    CGContextFillPath(contextRef);
    
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}
-(void)bingValueChange:(float)value
{
    
    currentValue = value/100 * M_PI * 2;
    [self setNeedsDisplay];
}
@end
