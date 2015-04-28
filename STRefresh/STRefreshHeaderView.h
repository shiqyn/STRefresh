//
//  STRefreshHeaderView.h
//  STRefreshDemo
//
//  Created by shiqyn on 26/4/15.
//  Copyright (c) 2015年 Shiqyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRCircleProgressActivityIndicator.h"

extern const CGFloat TIGGE_REFRESH_HEIGHT;

typedef enum {
    STRefreshStateNormal,
    STRefreshStatePulling,
    STRefreshStateCanTiggeRefresh,
    STRefreshStateRefreshing
}STRefreshState;

@interface STRefreshHeaderView : UIView{
    UILabel* infoLabel;
    SRCircleProgressActivityIndicator* progressView;
}
@property(nonatomic,assign)STRefreshState state;
@property(nonatomic, copy)void (^refreshingBlock)();
@property(nonatomic, copy)NSString* dateKey;
-(void)setProgress:(CGFloat)newProgress;
- (void)endRefreshingWithUpdateDate:(BOOL)updateDate;
@end
