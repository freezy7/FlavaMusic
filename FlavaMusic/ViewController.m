//
//  ViewController.m
//  FlavaMusic
//
//  Created by R_flava_Man on 16/2/19.
//  Copyright © 2016年 R_style_Man. All rights reserved.
//

#import "ViewController.h"
#import "FMDataService.h"
#import "CLDataService.h"
#import "FMScrollHeaderCell.h"
#import "FMRefreshHeaderView.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    FMRefreshHeaderView *_refreshHeaderView;
    
    UITableView *_tableView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [CLDataService getRequestWithMethod:@"v2-car-getModelEntranceInfo.html" parameters:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"222222222");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        
    }];
    
    NSLog(@"111111111");
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    _refreshHeaderView = [[FMRefreshHeaderView alloc] initWithFrame:CGRectMake(0, -64, _tableView.frame.size.width, 64)];
    _refreshHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _refreshHeaderView.defaultContentInset = _tableView.contentInset;
    [_tableView addSubview:_refreshHeaderView];
    
}

- (void)FMDataService
{
    [FMDataService getRequestWithMethod:@"alibaba.xiami.api.rank.index.get" parameters:nil success:^(NSURLSessionDataTask *task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        
    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"FMScrollHeaderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[FMScrollHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
    return [[UITableViewCell alloc] init];
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView refreshHeaderViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView refreshHeaderViewDidEndDragging:scrollView];
}

@end
