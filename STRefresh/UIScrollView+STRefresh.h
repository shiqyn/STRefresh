//
//  UIScrollView+STRefresh.h
//  STRefreshDemo
//
//  Created by shiqyn on 25/4/15.
//  Copyright (c) 2015年 Shiqyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRCircleProgressActivityIndicator.h"
 




@class STParallaxHeader;
@interface UIScrollView (STRefresh)

@property(nonatomic, strong, readonly)STParallaxHeader* parallaxHeader;

-(void)addHeaderWithCallback:(void(^)())callback dateKey:(NSString*)dateKey;
-(void)shouldPositionParallaxHeader;
-(void)endHeaderRefreshWithUpdateDate:(BOOL)needUpdateDate;
-(void)beginHeaderRefresh;
@end





@interface STParallaxHeader : UIView

@property (nonatomic, assign, readonly, getter=isInsideTableView) BOOL insideTableView;
@property (nonatomic, assign, readonly) CGFloat progress;
@property(nonatomic, assign, getter=isIgnoreContentInset)BOOL ignoreContentInset;

@end