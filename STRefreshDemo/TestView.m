//
//  TestView.m
//  Example
//
//  Created by shiqyn on 21/4/15.
//  Copyright (c) 2015年 Marek Serafin. All rights reserved.
//

#import "TestView.h"
#import <Masonry.h>

@implementation TestView
-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200, 60)];
        label.text = @"111111111111";
        label.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:label];
 
        UILabel* label2 = [UILabel  new];
        label2.text = @"222222";
        label2.backgroundColor = [UIColor redColor];
        [self addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker* make){
            make.size.mas_equalTo(CGSizeMake(200, 30));
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY).with.priorityLow();
            make.bottom.lessThanOrEqualTo(label.mas_top);
        
//            make.center.equalTo(self).with.centerOffset(CGPointMake(0, -55));
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker* maker){
            maker.top.equalTo(self).offset(50);
            maker.centerX.equalTo(self.mas_centerX);
            maker.height.equalTo(@20);
        }];
    }
    return self;
        
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
