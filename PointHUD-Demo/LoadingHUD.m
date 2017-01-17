//
//  LoadingHUD.m
//  HdgSDK_Pay
//
//  Created by 翻墙的小猪 on 2017/1/13.
//  Copyright © 2017年 hodo. All rights reserved.
//

#import "LoadingHUD.h"

const CGFloat PointRadius = 8;
const CGFloat TranslatLen = 6.0;
const CGFloat SmallViewSize = 100.0;

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height

#define topPointColor    [UIColor colorWithRed:90 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1.0].CGColor
#define leftPointColor   [UIColor colorWithRed:250 / 255.0 green:85 / 255.0 blue:78 / 255.0 alpha:1.0].CGColor
#define bottomPointColor [UIColor colorWithRed:92 / 255.0 green:201 / 255.0 blue:105 / 255.0 alpha:1.0].CGColor
#define rightPointColor  [UIColor colorWithRed:253 / 255.0 green:175 / 255.0 blue:75 / 255.0 alpha:1.0].CGColor



@interface LoadingHUD ()

@property (nonatomic, strong) CAShapeLayer * TopPointLayer;
@property (nonatomic, strong) CAShapeLayer * BottomPointLayer;
@property (nonatomic, strong) CAShapeLayer * LeftPointLayer;
@property (nonatomic, strong) CAShapeLayer * rightPointLayer;

@property (nonatomic, strong)UIView *smallView;
@property (nonatomic, assign) BOOL animating;
@property (nonatomic, strong)UILabel *textLab;
@property (nonatomic, assign)float smallPointX;//记录小view的x中心点
@property (nonatomic, assign)float smallPointY;

@end

@implementation LoadingHUD

- (instancetype)init {
        if (self == [super init]) {
    
            self.frame = CGRectMake(0, 0, screenW, screenH);
            self.backgroundColor = [UIColor colorWithRed:96/255 green:96/255 blue:96/255 alpha:.6];
        
            
            self.smallView = [[UIView alloc] init];
            self.smallView.frame = CGRectMake(0, 0, SmallViewSize, SmallViewSize);
            self.smallView.center = CGPointMake(screenW/2-5, screenH/2-5);
            self.smallView.backgroundColor = [UIColor clearColor];
            self.smallView.alpha = 1;
            [self addSubview:self.smallView];
            
            _smallPointX = self.smallView.center.x;
            _smallPointY = self.smallView.center.y;
    
            [self initLayers];
        }
        
        return self;
}

#pragma mark - Iniatial
- (void)initLayers {
    
    float centerX = self.center.x;
    float centerY = self.center.y;

    //
    CGPoint topPoint = CGPointMake(centerX, centerY-20);
    self.TopPointLayer = [self layerWithPoint:topPoint color:topPointColor];
    self.TopPointLayer.opacity = 1.f;
    [self.smallView.layer addSublayer:self.TopPointLayer];

    CGPoint leftPoint = CGPointMake(centerX-20, centerY);
    self.LeftPointLayer = [self layerWithPoint:leftPoint color:leftPointColor];
    self.LeftPointLayer.opacity = 1.f;
    [self.smallView.layer addSublayer:self.LeftPointLayer];

    CGPoint bottomPoint = CGPointMake(centerX, centerY+20);
    self.BottomPointLayer = [self layerWithPoint:bottomPoint color:bottomPointColor];
    self.BottomPointLayer.opacity = 1.f;
    [self.smallView.layer addSublayer:self.BottomPointLayer];

    CGPoint rightPoint = CGPointMake(centerX+20, centerY);
    self.rightPointLayer = [self layerWithPoint:rightPoint color:rightPointColor];
    self.rightPointLayer.opacity = 1.f;
    [self.smallView.layer addSublayer:self.rightPointLayer];
    
}

- (CAShapeLayer *)layerWithPoint:(CGPoint)center color:(CGColorRef)color {
    
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(center.x-PointRadius , center.y-PointRadius, PointRadius * 2, PointRadius * 2);
    layer.fillColor = color;
    //让贝塞尔曲线与CAShapeLayer产生联系
    layer.path = [self pointPath];
    return layer;
}
- (CGPathRef)pointPath {
    //为了保持圆圈始终在中心位置，此处的point需要是全屏幕view的layer的中心位置
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(-screenW/2+50+5+4, -screenH/2+50+5+4) radius:PointRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES].CGPath;
}

- (void)showLoading{
    
    UIWindow * window = [UIApplication sharedApplication].windows[0];
    [window addSubview:self];
   
    [self startAni];
}

- (void)showText:(NSString*)string{
    
    self.textLab = [[UILabel alloc]init];
    self.textLab.frame = CGRectMake(0, 0, SmallViewSize+60,30);
    self.textLab.center = CGPointMake(_smallPointX, _smallPointY+SmallViewSize/2+5);
    self.textLab.textAlignment = NSTextAlignmentCenter;
    self.textLab.text = string;
    self.textLab.textColor = [UIColor whiteColor];
    self.textLab.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.textLab];
}


#pragma mark - Animation
- (void)startAni {
    
    //self.animating = YES;
    [self addTranslationAniToLayer:self.TopPointLayer xValue:0 yValue:TranslatLen];
    [self addTranslationAniToLayer:self.LeftPointLayer xValue:TranslatLen yValue:0];
    [self addTranslationAniToLayer:self.BottomPointLayer xValue:0 yValue:-TranslatLen];
    [self addTranslationAniToLayer:self.rightPointLayer xValue:-TranslatLen yValue:0];
    [self addRotationAniToLayer:self.smallView.layer];
    
}

//内外收缩动画
- (void)addTranslationAniToLayer:(CALayer *)layer xValue:(CGFloat)x yValue:(CGFloat)y {
    CAKeyframeAnimation * translationKeyframeAni = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    translationKeyframeAni.duration = 1.0;
    translationKeyframeAni.repeatCount = HUGE;
    translationKeyframeAni.removedOnCompletion = NO;
    translationKeyframeAni.fillMode = kCAFillModeForwards;
    translationKeyframeAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    NSValue * fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0.f)];
    NSValue * toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(x, y, 0.f)];
    translationKeyframeAni.values = @[fromValue, toValue, fromValue, toValue, fromValue];
    [layer addAnimation:translationKeyframeAni forKey:@"translationKeyframeAni"];
}

//旋转动画
- (void)addRotationAniToLayer:(CALayer *)layer {
    CABasicAnimation * rotationAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAni.fromValue = @(0);
    rotationAni.toValue = @(M_PI * 2);
    rotationAni.duration = 1.5;
    rotationAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAni.repeatCount = HUGE;
    rotationAni.fillMode = kCAFillModeForwards;
    rotationAni.removedOnCompletion = NO;
    [layer addAnimation:rotationAni forKey:@"rotationAni"];
}

#pragma mark - Stop
- (void)removeLoading {
    
    [self.TopPointLayer removeAllAnimations];
    [self.LeftPointLayer removeAllAnimations];
    [self.BottomPointLayer removeAllAnimations];
    [self.rightPointLayer removeAllAnimations];
    [self.smallView.layer removeAllAnimations];
    [self.smallView removeFromSuperview];
    if (self.textLab) {
        [self.textLab removeFromSuperview];
    }
    [self removeFromSuperview];
    
    //self.animating = NO;
}

@end
