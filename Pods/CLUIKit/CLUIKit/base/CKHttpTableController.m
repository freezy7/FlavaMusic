//
//  CKHttpTableController.m
//  CLCommon
//
//  Created by wangpeng on 11/11/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import "CKHttpTableController.h"
#import "CKReachabilityUtil.h"
#import "CKUIManager.h"

@interface CKHttpTableController ()

@end

@implementation CKHttpTableController

- (void)dealloc
{
    [_dataModel setDelegate:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dataModel = [self createDataModel];
    // 有缓存先显示缓存数据
    if (_dataModel.itemCount>0) {
        [self reloadData];
    }
    
    [self performSelector:@selector(refresh) withObject:nil afterDelay:0.01f];
}

- (void)refreshWithMarkIndex
{
    
}

- (void)refresh
{
    _refreshOneTimeWhenAppear = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:_dataModel selector:@selector(reload) object:nil];
    [_dataModel performSelector:@selector(reload) withObject:nil afterDelay:0.01f];
}

- (CKListDataModel *)createDataModel
{
    return nil;
}

- (void)reloadData
{
    [self.tableView reloadData];
}

- (void)reloadWithNoDataView
{
    [self reloadData];
    if (![self haveCacheOrData]) {
        // 加载成功之后仍然无数据，显示无数据内容
        if (!_disableNoDataView) {
            [self showNoDataView];
        }
    } else {
        [self hideNoDataView];
    }
}

- (void)enableRefreshOneTimeWhenAppear
{
    if ([self.view window]) {
        [self refresh];
    } else {
        _refreshOneTimeWhenAppear = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_refreshOneTimeWhenAppear) {
        [self refresh];
    }
}

- (BOOL)haveCacheOrData
{
    return _dataModel.itemCount>0;
}

- (void)changeDataModel:(CKListDataModel *)model
{
    _dataModel = model;
}

#pragma mark - VGEDataModelDelegate

- (void)dataModelPrepareStart:(VGEDataModel *)model
{

}

- (void)dataModelWillStart:(VGEDataModel *)model
{
    // 无缓存显示loading indicator
    [self hideNoDataView];
    if (![self haveCacheOrData]) {
        [self startLoadingIndicator];
    }
}

- (void)dataModelWillFinish:(VGEDataModel *)model
{
    _isDataModelLoadedFromNet = YES;
}

- (void)dataModelDidUpdate:(VGEDataModel *)model
{
    [self stopLoadingIndicator:nil];
}

- (void)dataModelDidSuccess:(VGEDataModel *)model
{
    [self reloadData];
    if (_indicatorView) {
        __weak CKHttpTableController *weakSelf = self;
        [self stopLoadingIndicator:^(BOOL finished) {
            if (![[CKReachabilityUtil sharedInstance].reachability isReachable]) {
                [[CKUIManager sharedManager] showNetworkErrorHintHUDInWindow];
            }
            if (![weakSelf haveCacheOrData]) {
                // 加载成功之后仍然无数据，显示无数据内容
                if (!_disableNoDataView) {
                    [weakSelf showNoDataView];
                }
            } else {
                [weakSelf hideNoDataView];
            }
        }];
    } else {
        if (![[CKReachabilityUtil sharedInstance].reachability isReachable]) {
            [[CKUIManager sharedManager] showNetworkErrorHintHUDInWindow];
        }
        if (![self haveCacheOrData]) {
            // 加载成功之后仍然无数据，显示无数据内容
            if (!_disableNoDataView) {
                [self showNoDataView];
            }
        } else {
            [self hideNoDataView];
        }
    }
}

- (void)dataModelDidFail:(VGEDataModel *)model
{
    if (_indicatorView) {
        __weak CKHttpTableController *weakSelf = self;
        [self stopLoadingIndicator:^(BOOL finished) {
            if (model && [(CKDataResult *)model.result respondsToSelector:@selector(code)]) {
                if (![weakSelf haveCacheOrData]) {
                    if ([(CKDataResult *)model.result code]==CKDataResultNetworkError) {
                        [weakSelf showFailedViewWithMsg:@"网络不给力，请点击屏幕重试" image:[[CKUIManager sharedManager] generateViewControllerNetworkErrorImage]];
                    } else if ([(CKDataResult *)model.result code]==CKDataResultServerError) {
                        [weakSelf showFailedViewWithMsg:@"服务器打瞌睡了，请稍后再试" image:[[CKUIManager sharedManager] generateViewControllerServerErrorImage]];
                    }
                } else {
                    if ([(CKDataResult *)model.result code]==CKDataResultNetworkError) {
                        [[CKUIManager sharedManager] showNetworkErrorHintHUDInWindow];
                    }
                }
            }
        }];
    } else {
        if (model && [(CKDataResult *)model.result respondsToSelector:@selector(code)]) {
            if (![self haveCacheOrData]) {
                if ([(CKDataResult *)model.result code]==CKDataResultNetworkError) {
                    [self showFailedViewWithMsg:@"网络不给力，请点击屏幕重试" image:[[CKUIManager sharedManager] generateViewControllerNetworkErrorImage]];
                } else if ([(CKDataResult *)model.result code]==CKDataResultServerError) {
                    [self showFailedViewWithMsg:@"服务器打瞌睡了，请稍后再试" image:[[CKUIManager sharedManager] generateViewControllerServerErrorImage]];
                }
            } else {
                if ([(CKDataResult *)model.result code]==CKDataResultNetworkError) {
                    [[CKUIManager sharedManager] showNetworkErrorHintHUDInWindow];
                }
            }
        }
    }
}

- (void)dataModelDidFinish:(VGEDataModel *)model
{
    [self stopLoadingIndicator:nil];
}

#pragma mark - CLNoDataViewDelegate

- (void)noDataViewDidClick:(CKNoDataView *)view
{
    [self refresh];
}

@end
