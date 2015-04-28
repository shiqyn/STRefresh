//
//  STRefreshHeaderView.m
//  STRefreshDemo
//
//  Created by shiqyn on 26/4/15.
//  Copyright (c) 2015年 Shiqyn. All rights reserved.
//

#import "STRefreshHeaderView.h"
#import <Masonry.h>
#import <NSDate+TimeAgo.h>

#define CIRCLE_PROGRESS_SIZE  CGSizeMake(26, 26)
const CGFloat TIGGE_REFRESH_HEIGHT =  70;

@interface STRefreshHeaderView()
@property(nonatomic, assign, getter=isNeedUpdateDate)BOOL needUpdateDate;

@end

@implementation STRefreshHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        
        infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.font = [UIFont systemFontOfSize:12];
        infoLabel.textColor = [UIColor lightGrayColor];
        infoLabel.textAlignment = NSTextAlignmentCenter;
        infoLabel.text = @"test";
        [self addSubview:infoLabel];
      
        progressView = [[SRCircleProgressActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, CIRCLE_PROGRESS_SIZE.width, CIRCLE_PROGRESS_SIZE.height)
                                                                      logoImage:[UIImage imageNamed:@"centerIcon.png"]];
        [self addSubview:progressView];
        [progressView mas_makeConstraints:^(MASConstraintMaker* make){
            make.centerX.equalTo(self.mas_centerX);
            make.size.mas_equalTo(CIRCLE_PROGRESS_SIZE);
            make.centerY.equalTo(self.mas_centerY).with.priorityLow();
            make.bottom.lessThanOrEqualTo(infoLabel.mas_top).with.offset(-4);
        }];
        
        [infoLabel mas_makeConstraints:^(MASConstraintMaker* maker){
            maker.top.equalTo(self).offset(TIGGE_REFRESH_HEIGHT-15);
            maker.centerX.equalTo(self.mas_centerX);
            maker.height.equalTo(@20);
        }];
        
        self.state = STRefreshStateNormal;
    }
    return self;
}

-(void)showLastUpdateTime{
    if(self.dateKey){
        NSDate* lastRefreshDate = [[NSUserDefaults standardUserDefaults] objectForKey:self.dateKey];
        if(lastRefreshDate){
            infoLabel.text = [NSString stringWithFormat:@"%@刷新", [lastRefreshDate timeAgo]];
            return;
        }
    }
    infoLabel.text = @"";
}

-(void)setState:(STRefreshState)state{
    _state = state;
    if(_state == STRefreshStateRefreshing){
        progressView.loadingIndicatorView.hidden = NO;
        progressView.frontAnimateCircleLayer.hidden = YES;
        progressView.logoImgLayer.hidden = YES;
        progressView.backgroundCircleCircleLayer.hidden = YES;
    }else{
        progressView.loadingIndicatorView.hidden = YES;
        progressView.frontAnimateCircleLayer.hidden = NO;
        progressView.logoImgLayer.hidden = NO;
        progressView.backgroundCircleCircleLayer.hidden = NO;
    }
    
    // text
    if(_state == STRefreshStateRefreshing){
        infoLabel.text = @"正在刷新";
        [progressView.loadingIndicatorView startAnimating];
        if(self.refreshingBlock){
            self.refreshingBlock();
        }
    }else if(_state == STRefreshStateCanTiggeRefresh){
//        infoLabel.text = @"释放刷新";
    }else{
        [self showLastUpdateTime];
    }
}

-(void)setProgress:(CGFloat)newProgress{
    [progressView setProgress:newProgress];
}
- (void)endRefreshingWithUpdateDate:(BOOL)updateDate{
    self.needUpdateDate = updateDate;
    if(updateDate){
        infoLabel.text = [NSString stringWithFormat:@"%@刷新", [[NSDate date] timeAgo]];
        if(self.dateKey){
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.dateKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
 
}
@end



