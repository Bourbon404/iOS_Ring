# iOS_Ring
仿照手机百度卫士的饼状图
之前看到百度安全卫士的首页有一个环形动画挺有意思的，所以就仿照这写了一个。
先上结果图

![image](https://github.com/zhwe130205/iOS_Ring/blob/master/tmp/1.png)
![image](https://github.com/zhwe130205/iOS_Ring/blob/master/tmp/2.png)

有两个功能，上面的滑竿是来改变数值大小，并调整饼状图的扇形面积；下面的滑竿是来调整整体图片的上下浮层间距。
总体就这么两个功能，下面开始分布来介绍如何实现的。

视图层级

![image](https://github.com/zhwe130205/iOS_Ring/blob/master/tmp/3.png)

（一）饼状图
文字部分采用CATextLayer的方式添加到界面上，通过滑动滑竿来改变数值。
后面的饼状图通过自定义UIVew，在传入数值后，调用```[self setNeedsDisplay]```方法，进而调用```-(void)drawRect:(CGRect)rect``` 来重新绘制背景。
采用CGContext来绘制背景。
  (二)  层次感
通过滑动下面的滑竿来改变视图的层次感，这里通过首先设置viecontroller里面每个view的zposition，然后设置CATransform3D来改变视图层次。

下面查看代码

```
（一）绘制饼状图
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
（二）改变层次感
-(void)showShadow:(float)value
{
    CATransform3D transform = CATransform3DIdentity;
//    transform.m34 = 1/8000;
    transform.m34 = -0.001;
    transform = CATransform3DRotate(transform, -M_PI /value, -1, 0, 0);
    self.layer.sublayerTransform = transform;

}
```
