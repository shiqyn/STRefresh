//
//  UIScrollView+STRefresh.m
//  STRefreshDemo
//
//  Created by shiqyn on 25/4/15.
//  Copyright (c) 2015年 Shiqyn. All rights reserved.
//

#import "UIScrollView+STRefresh.h"
#import <objc/runtime.h>
#import <PureLayout.h>
#import "TestView.h"
#import "STRefreshHeaderView.h"

static char UIScrollViewParallaxHeader;
static char UIScrollViewRefreshView;
static char UIScrollViewTriggerRefreshAuto;

static void *VGParallaxHeaderObserverContext = &VGParallaxHeaderObserverContext;



@interface STParallaxHeader()
@property (nonatomic, assign, readwrite, getter=isInsideTableView) BOOL insideTableView;
@property (nonatomic, strong, readwrite) UIView *containerView;
@property (nonatomic, strong, readwrite) UIView *contentView;

@property (nonatomic, weak, readwrite) UIScrollView *scrollView;

@property (nonatomic, readwrite) CGFloat originalTopInset;
@property (nonatomic, readwrite) CGFloat originalHeight;

@property (nonatomic, strong, readwrite) NSLayoutConstraint *insetAwarePositionConstraint;
@property (nonatomic, strong, readwrite) NSLayoutConstraint *insetAwareSizeConstraint;

@property (nonatomic, assign, readwrite) CGFloat progress;
- (instancetype)initWithScrollView:(UIScrollView *)scrollView
                       contentView:(UIView *)view
                            height:(CGFloat)height;

@end

@implementation STParallaxHeader

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
                       contentView:(UIView *)view
                            height:(CGFloat)height
{
    self = [super initWithFrame:CGRectMake(0, 0, CGRectGetWidth(scrollView.bounds), height)];
    if (!self) {
        return nil;
    }
    
    self.scrollView = scrollView;
    
    self.originalHeight = height;
    self.originalTopInset = scrollView.contentInset.top;
    
    self.containerView = [[UIView alloc] initWithFrame:self.bounds];
    self.containerView.clipsToBounds = YES;
    
    if (!self.isInsideTableView) {
        self.containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    
    [self addSubview:self.containerView];
    
    self.contentView = view;
    
    return self;
}


- (void)setContentView:(UIView *)contentView
{
    if(_contentView != nil) {
        [_contentView removeFromSuperview];
    }
    
    _contentView = contentView;
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.containerView addSubview:_contentView];
    
    // Constraints
    [self addContentViewModeFillConstraints];
}

- (void)addContentViewModeFillConstraints
{
    [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                       withInset:0];
    [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeRight
                                       withInset:0];
    
    self.insetAwarePositionConstraint = [self.contentView autoAlignAxis:ALAxisHorizontal
                                                       toSameAxisOfView:self.containerView
                                                             withOffset:self.originalTopInset/2];
    
    NSLayoutConstraint *constraint = [self.contentView autoSetDimension:ALDimensionHeight
                                                                 toSize:self.originalHeight
                                                               relation:NSLayoutRelationGreaterThanOrEqual];
    constraint.priority = UILayoutPriorityRequired;
    
    self.insetAwareSizeConstraint = [self.contentView autoMatchDimension:ALDimensionHeight
                                                             toDimension:ALDimensionHeight
                                                                  ofView:self.containerView
                                                              withOffset:-self.originalTopInset];
    self.insetAwareSizeConstraint.priority = UILayoutPriorityDefaultHigh;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(contentInset))]
        && context == VGParallaxHeaderObserverContext
        &&!self.isIgnoreContentInset) {
        UIEdgeInsets edgeInsets = [[change valueForKey:@"new"] UIEdgeInsetsValue];
        
        // If scroll view we need to fix inset (TableView has parallax view in table view header)
        self.originalTopInset = edgeInsets.top - ((!self.isInsideTableView) ? self.originalHeight : 0);
 
        self.insetAwarePositionConstraint.constant = self.originalTopInset / 2;
        self.insetAwareSizeConstraint.constant = -self.originalTopInset;

        if(!self.isInsideTableView) {
            self.scrollView.contentOffset = CGPointMake(0, -self.scrollView.contentInset.top);
        }
    }
}


@end





#pragma mark -
@interface UIScrollView (_STRefresh)
@property(nonatomic, strong)STRefreshHeaderView* refreshView;
@property(nonatomic, assign, getter=isTiggerRefreshAuto)BOOL tiggerRefreshAuto;
@end


@implementation UIScrollView (STRefresh)
-(void)setParallaxHeader:(STParallaxHeader *)header{
    header.insideTableView = [self isKindOfClass:[UITableView class]];
    if(header.isInsideTableView){
        [(UITableView*)self setTableHeaderView:header];
    }else{
        [self addSubview:header];
    }
    
    objc_setAssociatedObject(self, &UIScrollViewParallaxHeader, header, OBJC_ASSOCIATION_ASSIGN);
}

-(STParallaxHeader*)parallaxHeader{
    return  objc_getAssociatedObject(self, &UIScrollViewParallaxHeader);
}
-(void)setRefreshView:(STRefreshHeaderView *)refreshView{
    objc_setAssociatedObject(self, &UIScrollViewRefreshView, refreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(STRefreshHeaderView*)refreshView{
    return  objc_getAssociatedObject(self, &UIScrollViewRefreshView);
}

-(void)setTiggerRefreshAuto:(BOOL)tiggerRefreshAuto{
    NSNumber* number = [NSNumber numberWithBool:tiggerRefreshAuto];
    objc_setAssociatedObject(self, &UIScrollViewTriggerRefreshAuto, number, OBJC_ASSOCIATION_ASSIGN);
}
-(BOOL)isTiggerRefreshAuto{
    return  [objc_getAssociatedObject(self, &UIScrollViewTriggerRefreshAuto) boolValue];
}




-(void)addHeaderWithCallback:(void(^)())callback dateKey:(NSString*)dateKey{
    
//     TestView* tv = [[TestView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,0)];
    self.refreshView = [[STRefreshHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0)];
    self.refreshView.state = STRefreshStateNormal;
    self.refreshView.dateKey = dateKey;
    self.refreshView.refreshingBlock = callback;
    float height = 0;
    
    self.parallaxHeader = [[STParallaxHeader alloc] initWithScrollView:self
                                                           contentView:self.refreshView height:height];
    [self shouldPositionParallaxHeader];
    
    // If UIScrollView adjust inset
    if (!self.parallaxHeader.isInsideTableView) {
        UIEdgeInsets selfContentInset = self.contentInset;
        selfContentInset.top += height;
        
        self.contentInset = selfContentInset;
        self.contentOffset = CGPointMake(0, -selfContentInset.top);
    }
    // Watch for inset changes
    [self addObserver:self.parallaxHeader
           forKeyPath:NSStringFromSelector(@selector(contentInset))
              options:NSKeyValueObservingOptionNew
              context:VGParallaxHeaderObserverContext];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (self.superview && newSuperview == nil) {
        [self.superview removeObserver:self
                            forKeyPath:NSStringFromSelector(@selector(contentInset))
                               context:VGParallaxHeaderObserverContext];
    }
}


- (void)shouldPositionParallaxHeader{
    if(self.parallaxHeader.isInsideTableView) {
        [self positionTableViewParallaxHeader];
    }else {
        [self positionScrollViewParallaxHeader];
    }
}

- (void)positionTableViewParallaxHeader{
    NSLog(@"positionTableViewParallaxHeader %@", NSStringFromCGPoint(self.contentOffset));
    
    if (self.contentOffset.y < self.parallaxHeader.originalHeight) {
        CGFloat height = self.contentOffset.y * -1 + self.parallaxHeader.originalHeight;
        self.parallaxHeader.containerView.frame = CGRectMake(0, self.contentOffset.y, CGRectGetWidth(self.frame), height);
        self.parallaxHeader.containerView.backgroundColor = [UIColor clearColor];
    }
    
    if(self.refreshView.state == STRefreshStateRefreshing){
        return;
    }
    
    CGFloat scaleProgress = fmaxf(0, (1 - ((self.contentOffset.y + self.parallaxHeader.originalTopInset) / self.parallaxHeader.originalHeight)));
    self.parallaxHeader.progress = scaleProgress;
    float progress = fabs(self.contentOffset.y+self.parallaxHeader.originalTopInset)/TIGGE_REFRESH_HEIGHT;
    NSLog(@">>>>%f", progress);
       NSLog(@"%d, %d, %d", self.isDragging, self.isDecelerating, self.tracking);
    [self.refreshView setProgress:progress];
    
    if(!self.isTiggerRefreshAuto){
        if(self.isDragging){
            if(self.refreshView.state != STRefreshStateRefreshing){
                if(progress>=1.0f){
                    self.refreshView.state = STRefreshStateCanTiggeRefresh;
                }else{
                    self.refreshView.state = STRefreshStatePulling;
                }
            }
        }else{
            if(self.refreshView.state == STRefreshStateCanTiggeRefresh){
                self.refreshView.state = STRefreshStateRefreshing;
                self.parallaxHeader.ignoreContentInset = YES;
     
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                                 animations:^(){
                                     self.contentInset = UIEdgeInsetsMake(TIGGE_REFRESH_HEIGHT+self.parallaxHeader.originalTopInset+4, 0, 0, 0);
                                 }completion:nil];
            }
        }
    }else{
         if(progress>=1.0f && self.refreshView.state != STRefreshStateRefreshing){
            self.refreshView.state = STRefreshStateRefreshing;
            self.parallaxHeader.ignoreContentInset = YES;
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                             animations:^(){
                                 self.contentInset = UIEdgeInsetsMake(TIGGE_REFRESH_HEIGHT+self.parallaxHeader.originalTopInset+4, 0, 0, 0);
                             }completion:nil];
         }
    }
}

- (void)positionScrollViewParallaxHeader{
    CGFloat height = self.contentOffset.y * -1;
    CGFloat scaleProgress = fmaxf(0, (height / (self.parallaxHeader.originalHeight + self.parallaxHeader.originalTopInset)));
    self.parallaxHeader.progress = scaleProgress;
    
    if (self.contentOffset.y < 0) {
        // This is where the magic is happening
        self.parallaxHeader.frame = CGRectMake(0, self.contentOffset.y, CGRectGetWidth(self.frame), height);
    }
}

-(void)endHeaderRefreshWithUpdateDate:(BOOL)needUpdateDate{
    self.tiggerRefreshAuto = NO;
    [self.refreshView endRefreshingWithUpdateDate:needUpdateDate];
    self.refreshView.state = STRefreshStateNormal;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^(){
                         self.contentInset = UIEdgeInsetsMake(0+self.parallaxHeader.originalTopInset, 0, 0, 0);
                     }completion:nil];
}

-(void)beginHeaderRefresh{
    self.tiggerRefreshAuto = YES;
    [self setContentOffset:CGPointMake(0, -(TIGGE_REFRESH_HEIGHT+self.parallaxHeader.originalTopInset+4)) animated:YES];
}

@end







