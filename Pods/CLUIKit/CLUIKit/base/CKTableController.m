//
//  CLTableController.m
//  CLCommon
//
//  Created by wangpeng on 11/8/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import "CKTableController.h"
#import "CKSlideDeleteTableView.h"
#import "BPUIViewAdditions.h"
#import "CKCoreUtil.h"
#import "BPCoreUtil.h"
#import "CKUIManager.h"

@interface CKTableController () {
    UIView *_topBackgroundView;
}

@end

@implementation CKTableController

@dynamic useDeleteTable;

- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _noDataMsg = @"还没有内容";
        _noDataImg = [UIImage imageNamed:@"CLUIKit.bundle/main_table_no_data_history"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (![CKCoreUtil systemBigThan7] && self.useDeleteTable) {
        _tableView = [[CKSlideDeleteTableView alloc] initWithFrame:self.view.bounds];
    } else {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.width, self.view.height)];
    }
    
    if ([CKCoreUtil systemBigThan7]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.clipsToBounds = NO;
    if ([CKCoreUtil systemBigThan7]) {
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
    if ([CKCoreUtil systemBigThan6]) {
        if ([[CKUIManager sharedManager] respondsToSelector:@selector(tableViewSectionIndexColor)] && [[CKUIManager sharedManager] tableViewSectionIndexColor]) {
            _tableView.sectionIndexColor = [[CKUIManager sharedManager] tableViewSectionIndexColor];
        } else {
            _tableView.sectionIndexColor = [BPCoreUtil colorWithHexString:@"666666"];
        }
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_tableView.indexPathForSelectedRow) {
        [_tableView deselectRowAtIndexPath:_tableView.indexPathForSelectedRow animated:animated];
    }
}

- (void)controllerWillPushInTranslucentBarNavigationController
{
    [super controllerWillPushInTranslucentBarNavigationController];
    
    CGPoint offset = _tableView.contentOffset;
    _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    _tableView.scrollIndicatorInsets = _tableView.contentInset;
    _tableView.contentOffset = CGPointMake(0, offset.y-64);
}

- (void)reloadData
{
    [self.tableView reloadData];
}

- (void)addTopBackgroundWithColor:(UIColor *)color
{
    if ([CKCoreUtil systemBigThan7]) {
        if (!_topBackgroundView) {
            _topBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -2000, self.view.width, 2000+self.tableView.contentInset.top)];
            _topBackgroundView.backgroundColor = [UIColor whiteColor];
            [self.view insertSubview:_topBackgroundView atIndex:0];
        }
    }
}

- (void)addTopBackgroundWithWhiteColor
{
    [self addTopBackgroundWithColor:[UIColor whiteColor]];
}

- (void)addContentBackgroundWithColor:(UIColor *)color
{
    if ([CKCoreUtil systemBigThan7]) {
        UIView *bottomBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 999999)];
        bottomBackgroundView.backgroundColor = color;
        [self.tableView insertSubview:bottomBackgroundView atIndex:0];
    }
}

- (BOOL)useDeleteTable
{
    return NO;
}

- (void)showNoDataViewWithType:(int)type msg:(NSString *)msg image:(UIImage *)image
{
    [self showNoDataViewWithType:type msg:msg image:image frame:_tableView.bounds];
}

- (void)showNoDataViewWithType:(int)type msg:(NSString *)msg image:(UIImage *)image frame:(CGRect)frame
{
    if (!_noDataView) {
        _noDataView = [[CKNoDataView alloc] initWithFrame:frame];
        _noDataView.delegate = self;
        _noDataView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _noDataView.image = _noDataImg;
    }
    if (type==0) {
        self.tableView.alpha = 1;
        self.tableView.userInteractionEnabled = YES;
        if (_noDataView.superview!=_tableView) {
            [_noDataView removeFromSuperview];
            _noDataView.frame = frame;
            [_tableView addSubview:_noDataView];
        }
    } else {
        self.tableView.alpha = 0;
        self.tableView.userInteractionEnabled = NO;
        if (_noDataView.superview!=self.view) {
            [_noDataView removeFromSuperview];
            _noDataView.frame = frame;
            [self.view addSubview:_noDataView];
            [self.view sendSubviewToBack:_noDataView];
        }
    }
    _noDataView.image = image;
    _noDataView.msg = msg;
    _noDataView.hidden = NO;
}

- (void)showFailedViewWithMsg:(NSString *)msg image:(UIImage *)image
{
    [self showNoDataViewWithType:1 msg:msg image:image];
}

- (void)showNoDataView
{
    [self showNoDataViewWithType:0 msg:_noDataMsg image:_noDataImg];
}

- (void)showNoDataViewWithFrame:(CGRect)frame
{
    [self showNoDataViewWithType:0 msg:_noDataMsg image:_noDataImg frame:frame];
}
- (void)hideNoDataView
{
    _noDataView.hidden = YES;
    self.tableView.alpha = 1;
    self.tableView.userInteractionEnabled = YES;
}

- (void)setNoDataMsg:(NSString *)noDataMsg
{
    _noDataMsg = noDataMsg;
    
    _noDataView.msg = _noDataMsg;
}

- (void)setNoDataViewFrame:(CGRect)rect
{
    _noDataView.frame = rect;
}

- (void)setTableViewScrollToTop:(BOOL)top
{
    _tableView.scrollsToTop = top;
}

- (void)scrollToTop:(BOOL)animated
{
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, self.tableView.width, 1) animated:animated];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([[UIMenuController sharedMenuController] isMenuVisible]) {
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_topBackgroundView) {
        _topBackgroundView.top = -2000-_tableView.contentOffset.y-64;
    }
}

#pragma mark - CLNoDataViewDelegate

- (void)noDataViewDidClick:(CKNoDataView *)view
{
    
}

@end
