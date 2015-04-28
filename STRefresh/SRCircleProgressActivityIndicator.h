//
//  SRCircleProgressActivityIndicator.h
//  STRefreshDemo
//
//  Created by shiqyn on 24/4/15.
//  Copyright (c) 2015年 Shiqyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRCircleProgressActivityIndicator : UIView{
    
}
@property(nonatomic,assign, getter=isInsideTableView)BOOL insideTableView;
@property (nonatomic,strong) UIColor *borderColor;
@property (nonatomic,assign) CGFloat borderWidth;
@property(nonatomic, assign)CGFloat progress;

@property(nonatomic, strong, readonly)CALayer* logoImgLayer;
@property(nonatomic, strong, readonly)UIActivityIndicatorView* loadingIndicatorView;
@property(nonatomic, strong, readonly)CAShapeLayer* frontAnimateCircleLayer;
@property(nonatomic, strong, readonly)CAShapeLayer* backgroundCircleCircleLayer;

-(instancetype)initWithFrame:(CGRect)frame logoImage:(UIImage*)logoImg;
-(void)setProgress:(CGFloat)newProgress;
@end
