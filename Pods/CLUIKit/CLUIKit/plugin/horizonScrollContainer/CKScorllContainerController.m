//
//  CLScorllContainerController.m
//  CLCommon
//
//  Created by ali on 15/1/29.
//  Copyright (c) 2015年 eclicks. All rights reserved.
//

#import "CKScorllContainerController.h"
#import "CKHttpTableController.h"
#import "BPNSArrayAdditions.h"
#import "CKCoreUtil.h"
#import "BPUIViewAdditions.h"

@interface CKScorllContainerController ()<CKTopTabViewDelegate, CKHorizontalScrollViewDataSource, CKHorizontalScrollViewDelegate> {
    NSMutableArray *_refreshedControllers;
    
    CKViewController *_oldController;//上一个展示的页面
    CKViewController *_curController;//展示的页面
}

@end

@implementation CKScorllContainerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    _controllerList = [self controllersList];
    
    [super viewDidLoad];
    
    CGFloat offset = ([CKCoreUtil systemBigThan7] && self.navigationController.navigationBar.translucent)?64:0;
    if ([self topTabItems].count) {
        _tabView = [[CKTopTabView alloc] initWithFrame:CGRectMake(0, offset, self.view.width, 40)];
        _tabView.items = [self topTabItems];
        _tabView.delegate = self;
        _tabView.selectedIndex = 0;
        [self.view addSubview:_tabView];
        _scrollView = [[CKHorizontalScrollView alloc] initWithFrame:CGRectMake(0, _tabView.bottom, self.view.width, self.view.height - _tabView.bottom)];
    } else {
        _scrollView = [[CKHorizontalScrollView alloc] initWithFrame:CGRectMake(0, offset, self.view.width, self.view.height - offset)];
    }
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _scrollView.horizontalDataSource = self;
    _scrollView.horizontalDelegate = self;
    _scrollView.scrollsToTop = NO;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    
    [_scrollView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[_controllerList safeObjectAtIndex:self.selectedIndex] viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[_controllerList safeObjectAtIndex:_selectedIndex] viewDidAppear:animated];
    
    self.scrollView.scrollEnabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[_controllerList safeObjectAtIndex:_selectedIndex] viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[_controllerList safeObjectAtIndex:_selectedIndex] viewDidDisappear:animated];
}


/**
 子类继承
 返回tab的标题
 */
- (NSArray *)topTabItems
{
    return @[];
}

/**
 子类重写
 返回所包含的controller
 */
- (NSArray *)controllersList
{
    return nil;
}

- (UIViewController *)currentController
{
    if (_selectedIndex<_controllerList.count) {
        return [_controllerList safeObjectAtIndex:_selectedIndex];
    }
    return nil;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex == selectedIndex) {
        return;
    }
    //MARK::以下只是做controller逻辑的替换，（除 1和2 所对应的更新内容）并无更新view的位置的操作
    //获取上一个展示的VC
    _oldController = [_controllerList safeObjectAtIndex:_selectedIndex];
    if ([_oldController isKindOfClass:[CKTableController class]]) {
        [(CKTableController *)_oldController setTableViewScrollToTop:NO];
    }
    
    //赋值当前的 index
    _selectedIndex = selectedIndex;
    
    //1、点击上方tab 触发的scrollView的滚动，主动滑动时不会触发
    if (_selectedIndex != _scrollView.currentIndex) {
        [_scrollView setCurrentIndex:_selectedIndex animated:NO event:NO];;
    }
    
    //2、不带事件点击的 更新tabView的选择位
    [_tabView setSelectedIndex:_selectedIndex withEvent:NO];
    
    //获取要展示的VC
    _curController = [_controllerList safeObjectAtIndex:_selectedIndex];
    if ([_curController isKindOfClass:[CKTableController class]]) {
        [(CKTableController *)_curController setTableViewScrollToTop:YES];
    }
    
    //预加载未进行加载的页面，加载过不在进行重复加载数据
    if ([_curController isKindOfClass:[CKHttpTableController class]]) {
        if (!_refreshedControllers) {
            _refreshedControllers = [NSMutableArray array];
        }
        CKHttpTableController *theController = (CKHttpTableController *)_curController;
        NSString *currentIndex = [NSString stringWithFormat:@"%zd", self.selectedIndex];
        if (![_refreshedControllers containsObject:currentIndex]) {
            if (!theController.dataModel) {
                [theController view];
            }
            if (self.selectedIndex != 0 && [theController.dataModel itemCount] <=0) {
                [theController.dataModel loadCache];
                [theController reloadData];
                [theController refresh];
            }
            [_refreshedControllers addObject:currentIndex];
        }
    }
    
    [self updateControllerViewLifeCircle];
}

//更新controller 的层级次序
- (void)updateControllerViewLifeCircle
{
    if (_oldController != _curController) {
        [_oldController viewWillDisappear:NO];
        [_curController viewWillAppear:NO];
        [_oldController viewDidDisappear:NO];
        [_curController viewDidAppear:NO];
    }
}

#pragma mark - CKHorizontalScrollViewDataSource & CKHorizontalScrollViewDelegate

- (NSInteger)numberOfItems
{
    return _controllerList.count;
}

- (CKHorizontalScrollItemView *)horizontalScrollView:(CKHorizontalScrollView *)scroller itemViewForIndex:(NSInteger)index
{
    CKHorizontalScrollItemView *itemView = (CKHorizontalScrollItemView *)[scroller dequeueReusableItemView];
    if (itemView==nil) {
        itemView = [[CKHorizontalScrollItemView alloc] initWithFrame:scroller.bounds];
        itemView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    
    NSArray *subviews = itemView.subviews;
    [subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIViewController *controller = [_controllerList safeObjectAtIndex:index];
    controller.view.frame = itemView.bounds;
    controller.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    if ([controller isKindOfClass:[CKTableController class]]) {
        [((CKTableController *)controller) setTableViewScrollToTop:index == self.selectedIndex];
    }
    [itemView addSubview:controller.view];
    return itemView;
}

- (void)horizontalScrollView:(CKHorizontalScrollView *)scroller willSelectIndex:(NSInteger)index
{
    
}

- (void)horizontalScrollView:(CKHorizontalScrollView *)scroller didSelectIndex:(NSInteger)index
{
    if (index != _selectedIndex) {
        self.selectedIndex = scroller.currentIndex;
    }
}

#pragma mark - CLTopTabViewDelegate

- (void)topTabView:(CKTopTabView *)view didSelectAtIndex:(NSInteger)index
{
    if (index != _selectedIndex) {
        self.selectedIndex = index;
    }
}

@end
