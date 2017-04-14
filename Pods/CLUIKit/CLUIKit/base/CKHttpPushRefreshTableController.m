//
//  CLHttpPushRefreshTableController.m
//  CLCommon
//
//  Created by wangpeng on 12/6/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import "CKHttpPushRefreshTableController.h"
#import "BPUIViewAdditions.h"
#import "CKUIManager.h"

@interface CKHttpPushRefreshTableController () {
    BOOL _isPullRefresh;
}

@end

@implementation CKHttpPushRefreshTableController

- (void)dealloc
{
    _refreshHeaderView.delegate = nil;
    _refreshHeaderView = nil;
}

- (void)viewDidLoad
{
    _refreshHeaderView = [[CKUIManager sharedManager] tableControllerPullRefreshHeaderViewWithFrame:CGRectMake(0, -60, self.view.width, 60)];
    _refreshHeaderView.delegate = self;

    [super viewDidLoad];
    
    _refreshHeaderView.defaultContentInset = self.tableView.contentInset;
    
    [self.tableView addSubview:_refreshHeaderView];
}

- (void)controllerWillPushInTranslucentBarNavigationController
{
    [super controllerWillPushInTranslucentBarNavigationController];
    _refreshHeaderView.defaultContentInset = self.tableView.contentInset;
}

- (void)startLoadingIndicator
{
    if (_isPullRefresh) {
        return;
    }
    [super startLoadingIndicator];
}

- (void)didPullRefresh
{
    [_refreshHeaderView didPullRefreshScrollView:self.tableView];
}

#pragma mark - VGEDataModelDelegate

- (void)dataModelDidFinish:(VGEDataModel *)model
{
    [super dataModelDidFinish:model];
    [_refreshHeaderView pullRefreshScrollViewDataSourceDidFinishLoading:self.tableView];
    _isPullRefresh = NO;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_refreshHeaderView pullRefreshScrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[_refreshHeaderView pullRefreshScrollViewDidScroll:scrollView];
    [super scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[_refreshHeaderView pullRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - CLPullRefreshHeaderViewDelegate

- (BOOL)pullRefreshTableHeaderDataSourceIsLoading:(CKPullRefreshHeaderView *)view
{
    return [self.dataModel loading];
}

- (void)pullRefreshTableHeaderDidTriggerRefresh:(CKPullRefreshHeaderView *)view
{
    _isPullRefresh = YES;
    [self.dataModel reload];
}

@end
