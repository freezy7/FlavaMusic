//
//  CKTableController.h
//  CLCommon
//
//  Created by wangpeng on 11/8/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import "CKViewController.h"
#import "CKNoDataView.h"

@interface CKTableController : CKViewController <UITableViewDataSource, UITableViewDelegate, CKNoDataViewDelegate> {
    @protected
    CKNoDataView *_noDataView;
    BOOL shouldScrollTop;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, readonly) BOOL useDeleteTable;
@property (nonatomic, strong) NSString *noDataMsg;
@property (nonatomic, strong) UIImage *noDataImg;

- (void)reloadData;

// 无数据情况
- (void)showNoDataViewWithType:(int)type msg:(NSString *)msg image:(UIImage *)image;
- (void)showFailedViewWithMsg:(NSString *)msg image:(UIImage *)image;
- (void)showNoDataView;
- (void)showNoDataViewWithFrame:(CGRect)frame;
- (void)hideNoDataView;
- (void)setNoDataViewFrame:(CGRect)rect;

- (void)setTableViewScrollToTop:(BOOL)top;
- (void)scrollToTop:(BOOL)animated;
- (void)addTopBackgroundWithColor:(UIColor *)color;
- (void)addTopBackgroundWithWhiteColor;

- (void)addContentBackgroundWithColor:(UIColor *)color;

@end
