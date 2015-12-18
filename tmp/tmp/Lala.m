//
//  Lala.m
//  tmp
//
//  Created by Bourbon on 15/11/27.
//  Copyright © 2015年 Bourbon. All rights reserved.
//

#import "Lala.h"
@implementation Lala
@synthesize uiuiui;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//-(instancetype)init
//{
//    if (self = [super init])
//    {
//                self.lalala = [[UIView alloc] init];
//                [self.lalala setBackgroundColor:[UIColor yellowColor]];
//                [self addSubview:self.lalala];[self.lalala mas_makeConstraints:^(MASConstraintMaker *make) {
//                    //make.edges.equalTo(self);
//                    make.width.height.equalTo(@300);
//                }];
//    }
//    return self;
//}
-(instancetype)init
{
    if (self = [super init])
    {
        uiuiui = [[UIView alloc] init];
        [uiuiui setBackgroundColor:[UIColor purpleColor]];
        [self addSubview:uiuiui];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [uiuiui mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        
    }];
    
    [self.lalala mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@100);
//        make.edges.equalTo(uiuiui);
        make.left.equalTo(uiuiui.mas_right).offset(10);
    }];

 
}
-(void)tmolala
{
}
@end
