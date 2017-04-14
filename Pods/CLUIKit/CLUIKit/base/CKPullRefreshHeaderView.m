//
//  CLTableRefreshHeaderView.m
//  CLCommon
//
//  Created by wangpeng on 12/5/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import "CKPullRefreshHeaderView.h"

@interface CKPullRefreshHeaderView() {
    
}

@end


@implementation CKPullRefreshHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setDelegate:(id<CKPullRefreshHeaderViewDelegate>)delegate
{
    _delegate = delegate;
    if (_delegate==nil) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
}

- (void)viewWillAppear
{
    
}

- (void)setState:(CKPullRefreshState)aState
{
	_state = aState;
}

- (void)pullRefreshScrollViewDidScroll:(UIScrollView *)scrollView
{

}

- (void)pullRefreshScrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

- (void)pullRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    
}

- (void)didPullRefreshScrollView:(UIScrollView *)scrollView
{
    
}

- (void)delayToNormalWithScrollView:(UIScrollView *)scrollView
{
    
}

- (void)pullRefreshScrollViewDataSourceDidFinishLoading:(UIScrollView *)scrollView {
    
    
}

@end
