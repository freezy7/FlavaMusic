//
//  CKViewController.h
//  CLCommon
//
//  Created by wangpeng on 11/8/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKViewController : UIViewController {
    @protected
    UIImageView *_indicatorView;
}

@property (nonatomic) BOOL showLoadingIndicator;

- (void)setDefaultBackItemForNavigationBar;
- (void)backAction;

// 第一次进入不显示下拉刷新，只显示indicator
- (BOOL)isLoadingIndicator;
- (void)startLoadingIndicator;
- (void)stopLoadingIndicator;
- (void)stopLoadingIndicator:(void (^ __nullable)(BOOL finished))completion;

- (void)hideLoadingIndicator;

- (void)attachBlockWhenViewFirstDidAppear:(void(^__nullable)(void))block;

- (void)controllerWillPushInTranslucentBarNavigationController;

@end
