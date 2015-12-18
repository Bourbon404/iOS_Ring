//
//  YuanView.m
//  tmp
//
//  Created by Bourbon on 15/12/18.
//  Copyright © 2015年 Bourbon. All rights reserved.
//

#import "YuanView.h"

@implementation YuanView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef contextRef1 = UIGraphicsGetCurrentContext();
    CGContextBeginPath(contextRef1);
    CGContextAddArc(contextRef1, rect.size.width/2,rect.size.height/2, 210/2, 0, M_PI*2, YES);
    CGContextSetStrokeColorWithColor(contextRef1, [UIColor colorWithWhite:1 alpha:0.6].CGColor);
    CGContextSetLineWidth(contextRef1, 6);
    CGContextStrokePath(contextRef1);

}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

@end
