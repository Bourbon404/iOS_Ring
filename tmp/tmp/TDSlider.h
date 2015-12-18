//
//  TDSlider.h
//  Tudou
//
//  Created by zhang jiangshan on 12-12-11.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoButton.h"
typedef NS_ENUM(NSInteger, TDSliderStyle) {
    TDSliderHorizontal,
    TDSliderVertical
};

/*!
 @class
 @abstract 自制Slider，支持横竖
 */
@interface TDSlider : UIControl<UIGestureRecognizerDelegate>
{
    TDSliderStyle _style;
    UIView * _backgroundView;
    CAShapeLayer * _subProgressLayer;
    UIView *_subProgress;
    UIView * _progressView;
    UIImageView * _thumb;
    float _thumbOffset;
    NSArray * _pointButtons; //打点
}
@property(nonatomic,assign) float value;
@property(nonatomic,readonly) UIImageView * thumb;
@property(nonatomic,copy) NSArray * subValues; // @[@[@0.1,@0.2] , @[@0.4,@0.6]] 这种形式
@property(nonatomic,assign) NSTimeInterval subValue;
@property(nonatomic,readonly) NSArray * pointButtons;
@property(nonatomic,assign) BOOL sliderDidTouchThumb;
- (id)initWithStyle: (TDSliderStyle)style;

- (void)setSliderBackgroundColor: (UIColor *)color;
- (void)setProgressColor: (UIColor *)color;
- (void)setSubProgressColor: (UIColor *)color;

- (void)setThumbImage:(UIImage *)img;

- (void)setPoints:(NSArray *)pointArray;

- (float) progressRange;

- (void)thumbShow:(BOOL)show;

@end
