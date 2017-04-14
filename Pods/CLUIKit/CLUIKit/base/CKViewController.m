//
//  CKViewController.m
//  CLCommon
//
//  Created by wangpeng on 11/8/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import "CKViewController.h"
#import "CKUIView+Animation.h"
#import "BPUIViewAdditions.h"
#import "BPCoreUtil.h"
#import "CKCoreUtil.h"
#import "CKUIManager.h"

@interface CKViewController () {
    BOOL _isViewFirstDidAppear;
    void (^_blockForViewFirstDidAppear)(void);
    BOOL _isViewFirstWillAppear;
}

@end

@implementation CKViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
        });
        self.showLoadingIndicator = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[CKUIManager sharedManager] respondsToSelector:@selector(controllerBackgroundColor)] && [[CKUIManager sharedManager] controllerBackgroundColor]) {
        self.view.backgroundColor = [[CKUIManager sharedManager] controllerBackgroundColor];
    } else {
        self.view.backgroundColor = [BPCoreUtil colorWithHexString:@"f4f4f4" alpha:1];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_isViewFirstWillAppear) {
        _isViewFirstWillAppear = YES;
        if ([CKCoreUtil systemBigThan7]&&self.navigationController.navigationBar.translucent) {
            [self controllerWillPushInTranslucentBarNavigationController];
        }
    }
    
    if (self.isLoadingIndicator) {
        [_indicatorView startRotateAnimation];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performSelector:@selector(hasViewFirstDidAppear) withObject:nil afterDelay:0.01f];
}

- (void)hasViewFirstDidAppear
{
    if (_blockForViewFirstDidAppear) {
        _blockForViewFirstDidAppear();
        _blockForViewFirstDidAppear = nil;
    }
    _isViewFirstDidAppear = YES;
}

- (void)setDefaultBackItemForNavigationBar
{
    self.navigationItem.leftBarButtonItem = [[CKUIManager sharedManager] generateBackBarButtonItemWithTarget:self action:@selector(backAction)];
}

- (void)backAction
{
    if ([self.navigationController.viewControllers count]>1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)isLoadingIndicator
{
    return _indicatorView.superview!=nil;
}

- (void)startLoadingIndicator
{
    if (_showLoadingIndicator) {
        if (!_indicatorView) {
            _indicatorView = [[UIImageView alloc] initWithFrame:CGRectMake(floorf(self.view.width/2-43/2), floorf(self.view.height/2-43/2), 43, 43)];
            _indicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            _indicatorView.image = [[CKUIManager sharedManager] generateViewControllerLoadingImage];
            [self.view addSubview:_indicatorView];
        }
        [self.view bringSubviewToFront:_indicatorView];
        [_indicatorView startRotateAnimation];
    }else{
        [_indicatorView setHidden:YES];
    }
}

- (void)stopLoadingIndicator {
    [self stopLoadingIndicator:nil];
}

- (void)stopLoadingIndicator:(void (^)(BOOL))completion
{
    if (_showLoadingIndicator) {
        if (!_indicatorView) {
            return;
        }
        [_indicatorView stopAllAnimation];
        [_indicatorView removeFromSuperview];
        _indicatorView = nil;
    } else {
        [_indicatorView setHidden:YES];
    }
    if (completion) {
        completion(YES);
    }
}

- (void)hideLoadingIndicator
{
    [_indicatorView setHidden:YES];
}

- (void)attachBlockWhenViewFirstDidAppear:(void(^)(void))block
{
    if (_isViewFirstDidAppear) {
        block();
    } else {
        _blockForViewFirstDidAppear = block;
    }
}

- (void)controllerWillPushInTranslucentBarNavigationController
{
    
}

@end
