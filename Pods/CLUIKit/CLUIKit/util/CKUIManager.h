//
//  CKUIManager.h
//  CLUIKit
//
//  Created by wangpeng on 16/1/6.
//  Copyright © 2016年 wangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CKPullRefreshHeaderView;

@protocol CKUIManagerDelegate <NSObject>

#pragma mark - 导航栏物件设置
- (UIBarButtonItem *)generateBackBarButtonItemWithTarget:(id)target action:(SEL)action;
- (UIBarButtonItem *)generateBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (UIBarButtonItem *)generateSaveBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (UIBarButtonItem *)generateBarButtonItemWithImage:(UIImage *)image target:(id)target action:(SEL)action;
- (UIBarButtonItem *)generateBarButtonItemWithTitle:(NSString *)title color:(UIColor *)color target:(id)target action:(SEL)action;
- (UIBarButtonItem *)generateBarButtonItemWithTitle:(NSString *)title fontSize:(CGFloat)fontSize target:(id)target action:(SEL)action;
- (UIBarButtonItem *)generateBarButtonItemWithImage:(NSString *)image color:(UIColor *)color target:(id)target action:(SEL)action;

#pragma mark - 刷新头
- (CKPullRefreshHeaderView *)tableControllerPullRefreshHeaderViewWithFrame:(CGRect)frame;

#pragma mark - Controller相关图片
- (UIImage *)generateViewControllerLoadingImage;
- (UIImage *)generateViewControllerNetworkErrorImage;
- (UIImage *)generateViewControllerServerErrorImage;

#pragma mark - 显示提示HUD 设置时间自动消失
- (void)showErrorHintHUDInWindow:(NSString *)msg;
- (void)showErrorHintHUDInWindow:(NSString *)msg textOffset:(CGFloat)offset;
- (void)showHUDInWindowWithImage:(NSString *)imageName andMessage:(NSString *)msg;
- (void)showSuccessHUDHintInWindow:(NSString *)msg;
- (void)showMessageHUDInWindow:(NSString *)msg;
- (void)showMessageHUDInWindow:(NSString *)msg textOffset:(CGFloat)offset;
- (void)showNetworkErrorHintHUDInWindow;

#pragma mark - 显示loading相关HUD 注意：需要手动stop
- (void)showLoadingHUDMessageInWindow:(NSString *)text;
- (void)stopLoadingHUD;
- (void)stopLoadingHUD:(NSTimeInterval)delay;

#pragma mark - 使用应用程序的导航
- (UINavigationController *)generateNavigationControllerWithRootController:(UIViewController *)controller;

#pragma mark - 默认配置控件基本色
@optional
- (UIColor *)cellSeparatorLineColor;
- (UIColor *)cellSelectedBackgroundViewColor;
- (UIColor *)loadMoreCellBackgroundColor;
- (UIColor *)loadMoreCellNormalTextColor;
- (UIColor *)tableViewSectionIndexColor;
- (UIColor *)noDataViewMessageLabelTextColor;
- (UIColor *)pageLabelTextColor;
- (UIColor *)controllerBackgroundColor;

@end

#pragma mark -

@interface CKUIManager : NSObject

+ (void)setup:(id<CKUIManagerDelegate>)manager;

+ (id<CKUIManagerDelegate>)sharedManager;

@end