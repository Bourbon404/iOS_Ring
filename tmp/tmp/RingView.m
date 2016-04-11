//
//  RingView.m
//  tmp
//
//  Created by Bourbon on 15/12/18.
//  Copyright © 2015年 Bourbon. All rights reserved.
//

#import "RingView.h"
#import "Masonry.h"
#import "BingRing.h"
#import "YuanView.h"
@implementation RingView
{
    float currentValue;
    CATextLayer *title;
    BingRing *bing;
}

-(void)showShadow:(float)value
{
    CATransform3D transform = CATransform3DIdentity;
//    transform.m34 = 1/8000;
    transform.m34 = -0.001;
    transform = CATransform3DRotate(transform, -M_PI /value, -1, 0, 0);
    self.layer.sublayerTransform = transform;

}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIImage *waimianImage = [UIImage imageNamed:@"ring_speedup"];
        UIImageView *waimianView = [[UIImageView alloc] initWithImage:waimianImage];
        [waimianView setFrame:CGRectMake((frame.size.width-254)/2, 50, 254, 254)];
        waimianView.layer.zPosition = 10;
        [self.layer addSublayer:waimianView.layer];
        
        YuanView *yuan = [[YuanView alloc] initWithFrame:CGRectMake((frame.size.width-216)/2, 50+(254-216)/2, 216, 216)];
        yuan.layer.zPosition = 15;
        [self addSubview:yuan];
        
        
        UIImage *jiange = [UIImage imageNamed:@"ring_scale"];
        UIImageView *jiangeView = [[UIImageView alloc] initWithImage:jiange];
        [jiangeView setFrame:CGRectMake((frame.size.width-199)/2, 50+(254-199)/2, 199, 199)];
        jiangeView.layer.zPosition = 30;
        [self.layer addSublayer:jiangeView.layer];
        
        //饼状图
        bing = [[BingRing alloc] initWithFrame:CGRectMake((frame.size.width-150)/2, 50+(254-150)/2, 150, 150)];
        bing.layer.zPosition = 60;
        [self addSubview:bing];


        UILabel *subTitleLabel = [[UILabel alloc] init];
        [subTitleLabel setText:@"存储空间"];
        [subTitleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [subTitleLabel setTextColor:[UIColor whiteColor]];
        [subTitleLabel setTextAlignment:(NSTextAlignmentCenter)];
        NSDictionary *subTitleDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16],NSFontAttributeName, nil];
        subTitleLabel.layer.zPosition = 70;
        CGSize subTitleSize = [subTitleLabel.text sizeWithAttributes:subTitleDict];
        [subTitleLabel setFrame:CGRectMake((frame.size.width-subTitleSize.width)/2, 200, subTitleSize.width, subTitleSize.height)];
        subTitleLabel.shadowOffset = CGSizeMake(10, 10);
        subTitleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
        [self addSubview:subTitleLabel];
        
        title = [[CATextLayer alloc] init];
        [title setString:@"88%"];
//        title.contentsScale = 2;
        [title setFont:(__bridge CFTypeRef _Nullable)([UIFont boldSystemFontOfSize:40])];
        [title setFontSize:40];
        [title setForegroundColor:[UIColor whiteColor].CGColor];
        NSDictionary *titleDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:40],NSFontAttributeName, nil];
        CGSize titleSize = [title.string sizeWithAttributes:titleDict];
        [title setFrame:CGRectMake((frame.size.width-titleSize.width)/2, 120, titleSize.width, titleSize.height)];
        title.zPosition = 80;

        
        [self.layer addSublayer:title];



    }
    return self;
}

-(void)valueChange:(float)value
{
    [title setString:[NSString stringWithFormat:@"%.0f%%",value]];
    NSDictionary *titleDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:40],NSFontAttributeName, nil];
    CGSize titleSize = [title.string sizeWithAttributes:titleDict];
    [title setFrame:CGRectMake((self.frame.size.width-titleSize.width)/2, 120, titleSize.width, titleSize.height)];

    [bing bingValueChange:value];
}



@end
