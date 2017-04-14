//
//  CLTableRefreshHeaderView.h
//  CLCommon
//
//  Created by wangpeng on 12/5/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	CKPullRefreshPulling = 0,
	CKPullRefreshNormal,
	CKPullRefreshLoading,
} CKPullRefreshState;

@class CKPullRefreshHeaderView;

@protocol CKPullRefreshHeaderViewDelegate <NSObject>

- (void)pullRefreshTableHeaderDidTriggerRefresh:(CKPullRefreshHeaderView *)view;
- (BOOL)pullRefreshTableHeaderDataSourceIsLoading:(CKPullRefreshHeaderView *)view;

@optional
- (void)pullRefreshTableHeaderDidEndOrCancelRefresh:(CKPullRefreshHeaderView *)view;

@end

@interface CKPullRefreshHeaderView : UIView {
    @protected
    CKPullRefreshState _state;
    BOOL _canUpdate;
}

@property (nonatomic,weak) id <CKPullRefreshHeaderViewDelegate> delegate;
@property (nonatomic) UIEdgeInsets defaultContentInset;

- (void)viewWillAppear;

- (void)setState:(CKPullRefreshState)state;

- (void)pullRefreshScrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)pullRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)pullRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)pullRefreshScrollViewDataSourceDidFinishLoading:(UIScrollView *)scrollView;
- (void)didPullRefreshScrollView:(UIScrollView *)scrollView;

@end
