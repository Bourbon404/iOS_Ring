//
//  ViewController.m
//  tmp
//
//  Created by Bourbon on 15/11/10.
//  Copyright © 2015年 Bourbon. All rights reserved.
//

#import "ViewController.h"
#import "Layout.h"
#import "Masonry.h"
#import "ScrollLayout.h"
#import "PullLayout.h"
#import "ttt.h"
#import "FirstCollectionViewCell.h"
#import "SecondCollectionViewCell.h"
#import "ThirdCollectionViewCell.h"
#import "FirstFlowLayout.h"
#import "SecondFlowLayout.h"
#import "ThirdFlowLayout.h"
#import "CellManager.h"
#import "Lala.h"
//#import "TDSlider.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "Slider.h"
#import "RingView.h"
#import "TMPRignView.h"
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *view;
    UIView *tmpVIew;
    int i;
    Lala *tm;
    RingView *ring;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    // Do any additional setup after loading the view, typically from a nib.
//    
////    ttt *layout = [[ttt alloc] init];
//    PullLayout *layout = [[PullLayout alloc] init];
////    Layout *layout = [[Layout alloc] init];
////    ScrollLayout *layout = [[ScrollLayout alloc] init];
//    view = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
//    [view setDataSource:self];
//    [view setDelegate:self];
//    [view registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
//    [view registerClass:[FirstCollectionViewCell class] forCellWithReuseIdentifier:@"cell1"];
//    [view registerClass:[SecondCollectionViewCell class] forCellWithReuseIdentifier:@"cell2"];
//    [view registerClass:[ThirdCollectionViewCell class] forCellWithReuseIdentifier:@"cell3"];
//    [view setBackgroundColor:[UIColor grayColor]];
//    view.pagingEnabled = NO;
//    [self.view addSubview:view];
//    
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//        make.top.equalTo(self.view.mas_top);
//        make.bottom.equalTo(self.view.mas_bottom);
//        
//    }];
    
//    UIView *tmp = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 100, 100, 100)];
//    [tmp setBackgroundColor:[UIColor brownColor]];
//    [self.view addSubview:tmp];
//    
//    [UIView animateWithDuration:3 delay:3 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
//        [tmp setFrame:CGRectMake(200, 200, 100, 100)];
//
//    } completion:^(BOOL finished) {
//
//    }];
//    
//    UITableView *table = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStylePlain)];
//    [table setDelegate:self];
//    [table setDataSource:self];
//    [self.view addSubview:table];
//    table sele
    
//    i = 0;
//    tmpVIew = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    [tmpVIew setBackgroundColor:[UIColor blackColor]];
//    [self.view addSubview:tmpVIew];
//    
//    [tmpVIew addObserver:self forKeyPath:@"frame" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
//
//    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(change) userInfo:nil repeats:YES];
    
//    tm = [[Lala alloc] init];
//    [tm setFrame:CGRectMake(0, 0, 300, 300)];
//    [self.view addSubview:tm];
//    UIButton *bu=[UIButton buttonWithType:UIButtonTypeInfoDark];
//    bu.frame=CGRectMake(100, 100, 20, 20);
//    bu.backgroundColor=[UIColor redColor];
//    [self.view addSubview:bu];
//    [bu addTarget:self action:@selector(tmfffff) forControlEvents:UIControlEventTouchUpInside];
////    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        [self tmfffff];
////    });
////    [self tmfffff];
//    
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 300, 100)];
//    [label setBackgroundColor:[UIColor purpleColor]];
//    [label setText:@"lallala"];
//    [self.view addSubview:label];
//    
//    label.transform = CGAffineTransformMakeRotation(-M_PI_2);
//    
//    
//
//    SecondViewController *second = [[SecondViewController alloc] init];
//    [second.view setFrame:CGRectMake(100, 100, 100, 100)];
//    [second.view setBackgroundColor:[UIColor redColor]];
//    [self addChildViewController:second];
//    
//    [self transitionFromViewController:self
//                      toViewController:second
//                              duration:0
//                               options:(UIViewAnimationOptionTransitionNone)
//                            animations:^{
//                                
//                            } completion:^(BOOL finished) {
//                                
////                                currentController = selectController;
//                                
//                            }];
//
    
//    Slider *slider = [[Slider alloc] initWithFrame:CGRectMake(10, 200, 603, 10)];
//    [self.view addSubview:slider];
//    
    UIImage *image = [UIImage imageNamed:@"bg_blue"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:self.view.frame];
    [self.view addSubview:imageView];
    

    ring = [[RingView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:ring];
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 400, self.view.frame.size.width-20, 20)];
    [slider setMinimumValue:0];
    [slider setMaximumValue:100];
    [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:(UIControlEventValueChanged)];
    [self.view addSubview:slider];

    UISlider *slider1 = [[UISlider alloc] initWithFrame:CGRectMake(10, 500, self.view.frame.size.width-20, 20)];
    [slider1 setMinimumValue:-10];
    [slider1 setMaximumValue:-3];
    [slider1 addTarget:self action:@selector(showShadowWithValue:) forControlEvents:(UIControlEventValueChanged)];
    [self.view addSubview:slider1];

//
//    TMPRignView *ring = [[TMPRignView alloc] initWithFrame:self.view.frame];
//    
//    [self.view addSubview:ring];

    //=== ViewController中的viewDidLoad方法中 ===
//    //主Layer
//    CGRect frame = CGRectInset(self.view.bounds, 50, 50);
//    CALayer *layer = [CALayer layer];
//    layer.frame = frame;
//    [self.view.layer addSublayer:layer];
//    
//    //文字
//    CATextLayer *textLayer = [CATextLayer layer];
//    textLayer.contentsScale = [UIScreen mainScreen].scale;
//    textLayer.string = @"mgen 123";
//    textLayer.foregroundColor = [UIColor blackColor].CGColor;
//    textLayer.frame = layer.bounds;
//    textLayer.zPosition = 80;
//    [layer addSublayer:textLayer];
//    
//    //第一个椭圆
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    shapeLayer.contentsScale = [UIScreen mainScreen].scale;
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddEllipseInRect(path, NULL, layer.bounds);
//    shapeLayer.path = path;
//    shapeLayer.fillColor = [UIColor blueColor].CGColor;
//    shapeLayer.zPosition = 40;
//    [layer addSublayer:shapeLayer];
//    
//    //第二个椭圆
//    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
//    shapeLayer2.contentsScale = [UIScreen mainScreen].scale;
//    CGMutablePathRef path2 = CGPathCreateMutable();
//    CGPathAddEllipseInRect(path2, NULL, layer.bounds);
//    shapeLayer2.path = path2;
//    shapeLayer2.fillColor = [UIColor greenColor].CGColor;
//    shapeLayer2.zPosition = 0;
//    [layer addSublayer:shapeLayer2];
//    
//    //背景矩形
//    CALayer *backLayer = [CALayer layer];
//    backLayer.contentsScale = [UIScreen mainScreen].scale;
//    backLayer.backgroundColor = [UIColor grayColor].CGColor;
//    backLayer.frame = layer.bounds;
//    backLayer.zPosition = -40;
//    [layer addSublayer:backLayer];
//
//    //Identity transform
//    CATransform3D transform = CATransform3DIdentity;
//    //Perspective 3D
//    transform.m34 = -1.0 / 700;
//    //旋转
//    transform = CATransform3DRotate(transform, M_PI / 3, 0, 1, 0);
//    //设置CALayer的sublayerTransform
//    layer.sublayerTransform = transform;

    
}
-(void)sliderValueChange:(UISlider *)slider
{
    [ring valueChange:fabsf(slider.value)];
}
-(void)showShadowWithValue:(UISlider *)slider
{
    [ring showShadow:fabsf(slider.value)];
}
//-(void)tmfffff
//{
//    [tm tmolala];
//}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    ThirdViewController *third = [[ThirdViewController alloc] init];
//    [self.navigationController pushViewController:third animated:YES];
//}
//-(void)change
//{
//    
//    [tmpVIew setFrame:CGRectMake(10*i, 10*i, 10*i, 10*i)];
//    i = i + 2;
//}
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
//{
//    NSLog(@"收到了通知");
//    NSLog(@"%@",change);
//}
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 1;
//}
//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return 80;
//}
//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *cell = [CellManager cellManagerWith:[collectionView.collectionViewLayout class] andCollectionView:collectionView identifier:nil andIndex:indexPath];
//
//    cell.contentView.layer.cornerRadius = 35.0f;
//    cell.contentView.layer.borderWidth = 1.0f;
//
//    return cell;
//}
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    FirstFlowLayout *layout1 = [[FirstFlowLayout alloc] init];
//    
//    SecondFlowLayout *layout2 = [[SecondFlowLayout alloc] init];
//    
//    ThirdFlowLayout *layout3 = [[ThirdFlowLayout alloc] init];
//    
//    if (indexPath.item % 3 == 0) {
//        __weak UICollectionView *tmp = collectionView;
//        [collectionView setCollectionViewLayout:layout1 animated:YES completion:^(BOOL finished) {
//            [tmp reloadData];
//        }];
//    }else if (indexPath.item % 3 == 1){
//        __weak UICollectionView *tmp = collectionView;
//        [collectionView setCollectionViewLayout:layout2 animated:YES completion:^(BOOL finished) {
//            [tmp reloadData];
//        }];
//    }else{
//        __weak UICollectionView *tmp = collectionView;
//        [collectionView setCollectionViewLayout:layout3 animated:YES completion:^(BOOL finished) {
//            [tmp reloadData];
//        }];
//    }
//
//    
//
//}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat itemHeight = 480/3;
//
//    NSInteger num = [view numberOfItemsInSection:0];
//    if (scrollView.contentOffset.x < 0) {
//        [scrollView setContentOffset:CGPointMake(itemHeight*(num -4), 0)];
//    }else if(scrollView.contentOffset.x > itemHeight*(num -4)){
//        [scrollView setContentOffset:CGPointMake(0, 0)];
//    }
//}
@end
