//
//  TDSlider.m
//  Tudou
//
//  Created by zhang jiangshan on 12-12-11.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import "TDSlider.h"
#define LINE_HEIGHT 2
@interface TDSlider()
{
    UIImage * _pointImage;
}
@property(nonatomic,retain) UIImage * pointImage;
@end


@implementation TDSlider
@synthesize pointImage = _pointImage;
- (id)initWithStyle: (TDSliderStyle)style
{
    self = [super initWithFrame:CGRectZero];
    if(self)
    {
        _style = style;
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = RGBA(30, 30, 30, 0.7);
        
        _subProgress = [[UIView alloc] init];
        _subProgress.backgroundColor = RGB(112, 112, 112);
        
        _progressView = [[UIView alloc] init];
        _progressView.backgroundColor = [UIColor TDOrange];
        
        _thumb = [[UIImageView alloc] init];
        _thumb.userInteractionEnabled = YES;
        
        [self addSubview:_backgroundView];
        [self addSubview:_subProgress];
        [self addSubview:_progressView];
        [self addSubview:_thumb];
        
        UIPanGestureRecognizer * gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDrag:)];
        [gesture setDelegate:self];
        [self addGestureRecognizer:gesture];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
    
}

- (void)setSliderBackgroundColor: (UIColor *)color
{
    _backgroundView.backgroundColor = color;
}

- (void)setProgressColor: (UIColor *)color
{
    _progressView.backgroundColor = color;
}

- (void)setSubProgressColor: (UIColor *)color
{
    _subProgressLayer.fillColor = color.CGColor;
}

- (void)setThumbImage:(UIImage *)img
{
    _thumb.image = img;
    [_thumb sizeToFit];
    if(_style == TDSliderHorizontal)
        _thumbOffset = _thumb.size.width/2.0;
    else
        _thumbOffset = _thumb.size.height/2.0;
}

- (void)setPoints:(NSArray *)pointArray
{
    if(_pointButtons)
    {
        for(UIButton * btn in _pointButtons)
        {
            [btn removeFromSuperview];
        }
        _pointButtons = nil;
    }
    
    if(pointArray)
    {
        NSMutableArray * temp = [NSMutableArray arrayWithCapacity:pointArray.count];
        for(NSMutableDictionary * record in pointArray)
        {
            double pointValue = [[record objectForKey:@"startValue"] doubleValue];
            UserInfoButton * button = [UserInfoButton buttonWithType:UIButtonTypeCustom];
            button.userInfo = record;
            button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            [self insertSubview:button belowSubview:_thumb];
            [temp addObject:button];
            [button setImage:self.pointImage forState:UIControlStateNormal];
            [button sizeToFit];
            int index=(int)[pointArray indexOfObject:record];
            if (index==[pointArray count]-1) {
                button.center = CGPointMake(_thumbOffset+(self.progressRange-_thumbOffset - 4)*pointValue, self.height/2);
            }
            else{
                button.center = CGPointMake((self.progressRange-_thumbOffset/2)*pointValue+3, self.height/2);
            }
        }
        _pointButtons = [NSArray arrayWithArray:temp];
    }
}

- (float) progressRange
{
    if(_style == TDSliderHorizontal){
        return self.width;
    }
    else{
        return self.height-_thumbOffset-2;
    }
}

- (void)layoutSubviews
{

    if(_style == TDSliderHorizontal)
    {
        if (!isnan(_value) && NAN != _value) {
            _backgroundView.frame = CGRectMake(0, (self.height-LINE_HEIGHT)/2, self.width, LINE_HEIGHT);
            _progressView.frame = CGRectMake(0, (self.height-LINE_HEIGHT)/2, self.progressRange*self.value, LINE_HEIGHT);
            if (_subProgressLayer) {
                //此对象有时会是nil，会导致crush
                _subProgressLayer.frame = _backgroundView.frame;
            }
            if (!isnan(self.subValue)&& NAN != self.subValue) {
                _subProgress.frame = CGRectMake(0, (self.height-LINE_HEIGHT)/2, self.progressRange*self.subValue, LINE_HEIGHT);
                [_thumb sizeToFit];
                _thumb.center = CGPointMake((self.progressRange-_thumbOffset/2)*self.value+3, self.height/2);
            }
            
        }
    }
    else
    {
        _backgroundView.frame = CGRectMake((self.width-LINE_HEIGHT)/2, 0, LINE_HEIGHT, self.height);
        _progressView.frame = CGRectMake((self.width-LINE_HEIGHT)/2, self.height - (_thumbOffset+self.progressRange*self.value), LINE_HEIGHT, _thumbOffset+self.progressRange*self.value);
        if (_subProgressLayer) {
            _subProgressLayer.frame = _backgroundView.frame;
        }
        [_thumb sizeToFit];
        _thumb.center = CGPointMake(self.width/2 + 1, self.height - (_thumbOffset/2+self.progressRange*self.value)-2);
    }
}

- (void)didDrag: (UIPanGestureRecognizer *)sender
{
    //DLog(@"did drag!!");
    _sliderDidTouchThumb = YES;
    CGPoint point = [sender translationInView:_thumb];
    if(_style == TDSliderHorizontal)
    {
        _value = _value+point.x/self.progressRange;
        _value = [self getSliderValue:_value];
        if (!isnan(_value) && NAN != _value) {
            [self layoutSubviews];
        }
    }
    else
    {
        _value = _value-point.y/self.progressRange;
        _value = [self getSliderValue:_value];
        if (!isnan(_value) && NAN != _value) {
            [self layoutSubviews];
        }
        
    }
    [sender setTranslation:CGPointMake(0, 0) inView:_thumb];
    if(sender.state == UIGestureRecognizerStateBegan)
        [self sendActionsForControlEvents:UIControlEventTouchDown];
    else if(sender.state == UIGestureRecognizerStateChanged)
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    else if(sender.state == UIGestureRecognizerStateEnded)
    {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setValue:(float)value
{
    UIPanGestureRecognizer * gesture = [[_thumb gestureRecognizers] objectAtIndex:0];
    if(gesture.state != 0)
        return;
    _value = [self getSliderValue:value];
    if (!isnan(_value) && NAN != _value) {
        [self layoutSubviews];
    }
}

- (void)setSubValue:(NSTimeInterval)subValue {
    
    _subValue = [self getSliderValue:subValue];
}

- (void)setSubValues:(NSArray *)subValues
{
    _subValues = [subValues copy];
    if(!_subValues || _subValues.count<1)
    {
        _subProgressLayer.path = nil;
        return;
    }
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    for(NSArray * array in subValues)
    {
        
        double num1 = [array[0] doubleValue];
        num1 = [self getSliderValue:num1];
        double num2 = [array[1] doubleValue];
        num2 = [self getSliderValue:num2];
        
        if(_style == TDSliderHorizontal)
        {
            UIBezierPath * tempPath = [UIBezierPath bezierPathWithRect:CGRectMake(num1*_subProgressLayer.width, 0, (num2-num1)*_subProgressLayer.width, _subProgressLayer.height)];
            [path appendPath:tempPath];
            
        }
        else
        {
            UIBezierPath * tempPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, num1*_subProgressLayer.height, _subProgressLayer.width, (num2-num1)*_subProgressLayer.height)];
            [path appendPath:tempPath];
        }
    }
    _subProgressLayer.path = path.CGPath;
}

- (double)getSliderValue:(double)value
{
    if(value>1)
        return 1;
    else if(value<0)
        return 0;
    else
        return value;
}

- (UIImage *)pointImage
{
    if(!_pointImage)
    {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(12, 12), NO, 0);
        UIImage * pointImg = Image(@"player_point.png");
        [pointImg drawAtPoint:CGPointMake((12-pointImg.size.width)/2, (12-pointImg.size.height)/2)];
        _pointImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _pointImage;
}

- (void)thumbShow:(BOOL)show {
    
    _thumb.hidden = !show;
}

#pragma mark  UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGRect rball;
    if (_style == TDSliderHorizontal) {
        rball = CGRectMake(_thumb.left-20, _thumb.top-20, _thumb.size.width + 4 * 10, CGRectGetHeight(self.bounds)+10);
    } else {
        rball = CGRectMake(_thumb.left-20, _thumb.top-20, CGRectGetWidth(self.bounds), _thumb.size.height + 4 * 10);
    }
    
    CGPoint point = [touch locationInView:self];
    
    if(!CGRectContainsPoint(rball, point))
        return NO;
    else
        return YES;
}


@end
