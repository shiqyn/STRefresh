//
//  SRCircleProgressActivityIndicator.m
//  STRefreshDemo
//
//  Created by shiqyn on 24/4/15.
//  Copyright (c) 2015年 Shiqyn. All rights reserved.
//

#import "SRCircleProgressActivityIndicator.h"

#define DEGREES_TO_RADIANS(x) (x)/180.0*M_PI


@interface SRCircleProgressActivityIndicator()
@property(nonatomic, strong, readwrite)CALayer* logoImgLayer;
@property(nonatomic, strong, readwrite)UIActivityIndicatorView* loadingIndicatorView;
@property(nonatomic, strong, readwrite)CAShapeLayer* backgroundCircleCircleLayer;
@property(nonatomic, strong, readwrite)CAShapeLayer* frontAnimateCircleLayer;
@end;
@implementation SRCircleProgressActivityIndicator

-(instancetype)initWithFrame:(CGRect)frame logoImage:(UIImage*)logoImg{
    if(self = [super initWithFrame:frame]){
        self.borderColor = [UIColor colorWithRed:203/255.0 green:32/255.0 blue:39/255.0 alpha:1];
        self.borderWidth = 2.0f;
        
        self.loadingIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:self.loadingIndicatorView];
        [self.loadingIndicatorView hidesWhenStopped];
        self.loadingIndicatorView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        

        self.logoImgLayer = ({
            CALayer* layer = [[CALayer alloc] init];
            layer.frame = self.bounds;
            layer.contents = (id)logoImg.CGImage;
            layer.contentsGravity = kCAGravityResizeAspect;
            layer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(180), 0, 0, 1);
            [self.layer addSublayer:layer];
            layer;
        });

        
        
        self.backgroundCircleCircleLayer =({
            CAShapeLayer* layer = [[CAShapeLayer alloc] init];
            layer.frame = self.bounds;
            layer.fillColor = nil;
            layer.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6].CGColor;
            layer.lineWidth  = self.borderWidth;
            layer.lineCap = kCALineCapRound;
            UIBezierPath* bezierPath = [UIBezierPath bezierPathWithArcCenter:self.loadingIndicatorView.center
                                                                      radius:self.frame.size.height/2
                                                                  startAngle:DEGREES_TO_RADIANS(0)
                                                                    endAngle:DEGREES_TO_RADIANS(360)
                                                                   clockwise:YES];
            layer.path = bezierPath.CGPath;
            [self.layer addSublayer:layer];
            layer;
        });
        
        self.frontAnimateCircleLayer = ({
            CAShapeLayer* layer = [[CAShapeLayer alloc] init];
            layer.frame = self.bounds;
            layer.fillColor = nil;
            layer.strokeColor = self.borderColor.CGColor;
            layer.lineWidth  = self.borderWidth;
            layer.lineCap = kCALineCapRound;
            UIBezierPath* bezierPath = [UIBezierPath bezierPathWithArcCenter:self.loadingIndicatorView.center
                                                                      radius:self.frame.size.height/2
                                                                  startAngle:DEGREES_TO_RADIANS(-90)
                                                                    endAngle:DEGREES_TO_RADIANS(-360-90)
                                                                   clockwise:NO];
            layer.path = bezierPath.CGPath;
            [self.layer addSublayer:layer];
            layer;
        });
    }
    return self;
}
-(void)setProgress:(CGFloat)newProgress{
    static double prevProgress;
  
    if(newProgress > 1.0f){
        newProgress = 1.0f;
    }
    self.alpha = 1.0f*newProgress;
    
    if(newProgress>=0 && newProgress<=1.0f){
        CABasicAnimation* logoImgRotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        logoImgRotateAnimation.fromValue  = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(180-180*prevProgress)];
        logoImgRotateAnimation.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(180-180*newProgress)];
        logoImgRotateAnimation.duration = 0.15;
        logoImgRotateAnimation.removedOnCompletion = NO;
        logoImgRotateAnimation.fillMode = kCAFillModeForwards;
        [self.logoImgLayer addAnimation:logoImgRotateAnimation forKey:@""];
        
        CABasicAnimation* circleProgressAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        circleProgressAnimation.fromValue = [NSNumber numberWithFloat:((CAShapeLayer*)self.frontAnimateCircleLayer.presentationLayer).strokeEnd];
        circleProgressAnimation.toValue = [NSNumber numberWithFloat:newProgress];
        circleProgressAnimation.duration = 0.05 + 0.05*(fabs([circleProgressAnimation.fromValue doubleValue] - [circleProgressAnimation.toValue doubleValue]));
        circleProgressAnimation.removedOnCompletion = NO;
        circleProgressAnimation.fillMode = kCAFillModeForwards;
        circleProgressAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [self.frontAnimateCircleLayer addAnimation:circleProgressAnimation forKey:@"animation"];
    }
    _progress = newProgress;
    prevProgress = newProgress;
}

@end

















