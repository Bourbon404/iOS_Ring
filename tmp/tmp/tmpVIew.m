//
//  tmpVIew.m
//  tmp
//
//  Created by Bourbon on 15/11/27.
//  Copyright © 2015年 Bourbon. All rights reserved.
//

#import "tmpVIew.h"
@implementation tmpVIew
@synthesize lalala;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init
{
    if (self = [super init])
    {
        lalala = [[UIView alloc] init];
        [lalala setBackgroundColor:[UIColor yellowColor]];
        [self addSubview:lalala];    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [lalala mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        //make.width.height.equalTo(@300);
    }];

}
@end
