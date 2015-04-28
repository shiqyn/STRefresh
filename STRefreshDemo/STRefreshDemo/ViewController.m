//
//  ViewController.m
//  STRefreshDemo
//
//  Created by shiqyn on 24/4/15.
//  Copyright (c) 2015年 Shiqyn. All rights reserved.
//

#import "ViewController.h"
#import <BlocksKit.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    tb = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tb.delegate = self;
    tb.dataSource = self;
    [self.view addSubview:tb];
    __weak ViewController* weakself = self;
    [tb addHeaderWithCallback:^{
        [weakself bk_performBlock:^(id obj){
            [tb endHeaderRefreshWithUpdateDate:YES];
        }afterDelay:3];
    }dateKey:@"demostrefreshdatakey"];

    UIView* tbBgView = [[UIView alloc] initWithFrame:tb.bounds];
    tb.backgroundView = tbBgView;
    tbBgView.backgroundColor = [UIColor colorWithRed:0.810 green:0.912 blue:1.000 alpha:1.000];
    
//    self.navigationController.navigationBar.hidden = YES;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self bk_performBlock:^(id obj){
        [tb beginHeaderRefresh];
    }afterDelay:2];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [tb shouldPositionParallaxHeader];
    
    // Log Parallax Progress
    //    NSLog(@"Progress: %f", scrollView.parallaxHeader.progress);
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{ 
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text  = @"1122";
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
