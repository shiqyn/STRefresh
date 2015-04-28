//
//  ViewController.h
//  STRefreshDemo
//
//  Created by shiqyn on 24/4/15.
//  Copyright (c) 2015年 Shiqyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+STRefresh.h"

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    UITableView* tb;
}


@end

