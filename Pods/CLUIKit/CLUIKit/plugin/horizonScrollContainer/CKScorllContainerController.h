//
//  CLScorllContainerController.h
//  CLCommon
//
//  Created by ali on 15/1/29.
//  Copyright (c) 2015年 eclicks. All rights reserved.
//

#import "CKViewController.h"
#import "CKHorizontalScrollView.h"
#import "CKTopTabView.h"

@interface CKScorllContainerController : CKViewController {
@protected
    NSArray *_controllerList;
}

@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, strong, readonly) CKHorizontalScrollView *scrollView;
@property (nonatomic, strong, readonly) CKTopTabView *tabView;
/**
 子类重写
 返回tab的标题
 */
- (NSArray *)topTabItems;

/**
 子类重写
 返回所包含的controller
 */
- (NSArray *)controllersList;

- (UIViewController *)currentController;

@end
