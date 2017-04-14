//
//  CLPlatePostImageCheckView.m
//  CLCommon
//
//  Created by Kent on 13-12-26.
//  Copyright (c) 2013年 eclicks. All rights reserved.
//

#import "CKImageListPreviewController.h"
#import "CKImageListPreviewItemView.h"
#import "CKHorizontalScrollView.h"
#import "UIImageView+WebCache.h"
#import "CKImageListPreviewLoadingView.h"
#import "BPSDImageManagerAdditions.h"
#import "BPExecutorService.h"
#import "CKUIView+Animation.h"
#import "SDWebImageManager.h"
#import "BPUIViewAdditions.h"
#import "BPNSArrayAdditions.h"
#import "BPCoreUtil.h"
#import "CKCoreUtil+Net.h"
#import "CKUIManager.h"

@protocol CKImageListPreviewContentViewDelegate <NSObject>

- (void)contentViewChangeFrame;

@end

@interface CKImageListPreviewContentView : UIView

@property (nonatomic, weak) id<CKImageListPreviewContentViewDelegate> delegate;
@property (nonatomic, weak) CKHorizontalScrollView *scrollView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic) BOOL shouldAtuoLayout;

@end

@interface CKImageListPreviewController () <CKHorizontalScrollViewDelegate, CKHorizontalScrollViewDataSource, CKImageListPreviewItemViewDelegate> {
    CKImageListPreviewContentView *_contentView;
    UIView  *_bottomView;
    UILabel *_pageLabel, *_praiseLabel;
    UIButton *_shareBtn;
    
    CKHorizontalScrollView *_scrollView;
    BOOL _enableRotate;
}

@property (nonatomic) NSInteger index;
@property (nonatomic, strong) NSArray *imageLinkList;
@property (nonatomic) NSInteger startIndex;
@property (nonatomic, strong) NSDictionary *imageViewDict;

@end

@implementation CKImageListPreviewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _enableRotate = YES;
    _contentView.shouldAtuoLayout = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    _enableRotate = NO;
    _contentView.shouldAtuoLayout = YES;
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _contentView = [[CKImageListPreviewContentView alloc] initWithFrame:self.view.bounds];
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_contentView];
    
    _scrollView = [[CKHorizontalScrollView alloc] initWithFrame:CGRectMake(-5, 0, _contentView.width+10, _contentView.height)];
    _scrollView.horizontalDelegate = self;
    _scrollView.horizontalDataSource = self;
    [_contentView addSubview:_scrollView];
    _contentView.scrollView = _scrollView;
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-44, self.view.width, 44)];
    _bottomView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4f];
    [_contentView addSubview:_bottomView];
    _contentView.bottomView = _bottomView;
    
    _pageLabel = [[UILabel alloc] initWithFrame:_bottomView.bounds];
    _pageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _pageLabel.backgroundColor = [UIColor clearColor];
    _pageLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _pageLabel.font = [UIFont boldSystemFontOfSize:17];
    _pageLabel.textAlignment = NSTextAlignmentCenter;
    if ([[CKUIManager sharedManager] respondsToSelector:@selector(pageLabelTextColor)] && [[CKUIManager sharedManager] pageLabelTextColor]) {
        _pageLabel.textColor = [[CKUIManager sharedManager] pageLabelTextColor];
    } else {
        _pageLabel.textColor = [BPCoreUtil colorWithHexString:@"a0de73" alpha:1.0f];
    }
    _pageLabel.text = [NSString stringWithFormat:@"%zd/%zd", _index+1, _imageLinkList.count];
    [_bottomView addSubview:_pageLabel];
    
    if (self.delegate) {
        if (_shareBtn==nil) {
            _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _shareBtn.backgroundColor = [UIColor clearColor];
            _shareBtn.frame = CGRectMake(self.view.width-10 - 55, 0, 55, _bottomView.height);
            _shareBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
            [_shareBtn setImage:[UIImage imageNamed:@"CLUIKit.bundle/btn_image_preview_share"] forState:UIControlStateNormal];
            _shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0.f, 20.f, 0, 0);
            [_shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [_bottomView addSubview:_shareBtn];
        }
    } else {
        [_shareBtn removeFromSuperview];
        _shareBtn = nil;
    }
    
    [_scrollView reloadData];
    [_scrollView setCurrentIndex:_index animated:NO];
    [self updateAnimationStatus];
    [self updateImageLoading];
}

+ (void)showInController:(UIViewController *)controller imageLinkList:(NSArray *)imageLinkList startIndex:(NSInteger)startIndex imageViewDict:(NSDictionary *)imageViewDict delegate:(id<CKImageListPreviewControllerDelegate>)delegate
{
    CKImageListPreviewController *previewController = [[CKImageListPreviewController alloc] init];
    previewController.imageLinkList = imageLinkList;
    previewController.startIndex = startIndex;
    previewController.imageViewDict = imageViewDict;
    previewController.delegate = delegate;
    [previewController showInController:controller];
}

- (void)showInController:(UIViewController *)controller
{
    if (_startIndex>=0&&_startIndex<_imageLinkList.count) {
        _index = _startIndex;
    }
    
    BOOL hasCache = [[SDWebImageManager sharedManager] hasCacheForURL:[NSURL URLWithString:_imageLinkList[_index]]];
    BOOL hasStartImageView = hasCache&&[self.imageViewDict objectForKey:@(_index)];
    if (hasCache&&hasStartImageView) {
        UIImageView *startImgView = [self.imageViewDict objectForKey:@(_index)];
        
        UIWindow *rootView = [[UIApplication sharedApplication].delegate window];
        UIView *mask = [[UIView alloc] initWithFrame:rootView.bounds];
        mask.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        mask.backgroundColor = [UIColor blackColor];
        [rootView addSubview:mask];
        
        CGRect aniImgRect = [rootView convertRect:startImgView.bounds fromView:startImgView];
        
        UIImageView *aniImgView = [[UIImageView alloc] initWithFrame:startImgView.bounds];
        aniImgView.clipsToBounds = YES;
        aniImgView.contentMode = UIViewContentModeScaleAspectFill;
        aniImgView.frame = aniImgRect;
        [aniImgView setImage:[[SDWebImageManager sharedManager] cacheImageForURL:[NSURL URLWithString:_imageLinkList[_index]]]];
        [rootView addSubview:aniImgView];
        
        CGSize imageSize = [CKCoreUtil sizeWithImageLink:_imageLinkList[_index]];
        
        CGFloat width = imageSize.width;
        CGFloat height = imageSize.height;
        
        // 不超过当前view大小
        if (width>self.view.width) {
            height = height*(self.view.width)/width;
            width = self.view.width;
        }
        if (height>self.view.height) {
            width = width*self.view.height/height;
            height = self.view.height;
        }
        CKImageListPreviewItemView *itemView = (id)[_scrollView currentItemView];
        [itemView.imgView stopAnimating];
        [UIView animateWithDuration:0.45f animations:^{
            aniImgView.frame = CGRectMake(self.view.width/2-width/2, self.view.height/2-height/2, width, height);
        } completion:^(BOOL finished) {
            [controller presentViewController:self animated:NO completion:^{
                [aniImgView removeFromSuperview];
                [mask removeFromSuperview];
                [itemView.imgView startAnimating];
            }];
        }];
    } else {
        [controller presentViewController:self animated:NO completion:^{
            
        }];
    }
}

- (void)removeFromSuperviewWithAnimation
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    NSString *endImageLink = [_imageLinkList safeObjectAtIndex:_scrollView.currentIndex];
    if (endImageLink&&[_imageViewDict objectForKey:@(_scrollView.currentIndex)]) {
        UIImageView *endImageView = [_imageViewDict objectForKey:@(_scrollView.currentIndex)];
        
        CKImageListPreviewItemView *itemView = (CKImageListPreviewItemView *)_scrollView.currentItemView;
        
        UIImageView *imgView = nil;
        if (itemView.imgView.image) {
            imgView = itemView.imgView;
        } else {
            imgView = itemView.aniImgView;
        }
        
        UIView *rootView = [[UIApplication sharedApplication].delegate window];
        CGRect rootRect = [rootView convertRect:imgView.bounds fromView:imgView];
        
        UIView *mask = [[UIView alloc] initWithFrame:rootView.bounds];
        mask.backgroundColor = [UIColor blackColor];
        mask.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [rootView addSubview:mask];
        
        CGRect aniImgRect = [rootView convertRect:rootRect toView:rootView];
        UIImageView *aniImgView = [[UIImageView alloc] initWithFrame:aniImgRect];
        aniImgView.clipsToBounds = YES;
        aniImgView.contentMode = UIViewContentModeScaleAspectFill;
        [aniImgView setImage:imgView.image];
        aniImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
        [rootView addSubview:aniImgView];
        
        __block id controller = self;
        
        [self dismissViewControllerAnimated:NO completion:^{
            if (endImageView&&endImageView.window) {
                CGRect endImageRect = [rootView convertRect:endImageView.bounds fromView:endImageView];
                [UIView animateWithDuration:0.40f animations:^{
                    aniImgView.frame = endImageRect;
                    mask.alpha = 0.0f;
                } completion:^(BOOL finished) {
                    [aniImgView removeFromSuperview];
                    [mask removeFromSuperview];
                    controller = nil;
                }];
            } else {
                [UIView animateWithDuration:0.40f animations:^{
                    aniImgView.alpha = 0.0f;
                    mask.alpha = 0.0f;
                } completion:^(BOOL finished) {
                    [aniImgView removeFromSuperview];
                    [mask removeFromSuperview];
                    controller = nil;
                }];
            }
        }];
    } else {
        [self.view.window startPushFadeTransition];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (![CKCoreUtil systemBigThan8]) {
        [UIView animateWithDuration:duration animations:^{
            if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
                [_scrollView resizeToFrame:CGRectMake(-5, 0, self.view.height+10, self.view.width) animated:YES duration:duration];
                [_bottomView setFrame:CGRectMake(_bottomView.left, self.view.width-32, _bottomView.width, 32)];
            } else {
                if ([CKCoreUtil systemBigThan8]) {
                    [_scrollView resizeToFrame:CGRectMake(-5, 0, self.view.height+10, self.view.width) animated:YES duration:duration];
                    [_bottomView setFrame:CGRectMake(_bottomView.left, self.view.width-32, _bottomView.width, 32)];
                } else {
                    [_scrollView resizeToFrame:CGRectMake(-5, 0, self.view.width+10, self.view.height) animated:YES duration:duration];
                    [_bottomView setFrame:CGRectMake(_bottomView.left, self.view.height-44, _bottomView.width, 44)];
                }
            }
        }];
    }
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if ([CKCoreUtil systemBigThan8]) {
        [UIView animateWithDuration:duration animations:^{
            [_scrollView resizeToFrame:CGRectMake(-5, 0, self.view.width+10, self.view.height) animated:YES duration:duration];
            [_bottomView setFrame:CGRectMake(_bottomView.left, self.view.height-44, _bottomView.width, 44)];
        }];
    }
}

//适配ios5rotate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return _enableRotate;
}

- (BOOL)shouldAutorotate
{
    return _enableRotate;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    if (_enableRotate) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (void)updateAnimationStatus
{
    CKImageListPreviewItemView *currentItemView = (id)[_scrollView currentItemView];
    for (id view in _scrollView.subviews) {
        if ([view isKindOfClass:[CKImageListPreviewItemView class]]) {
            CKImageListPreviewItemView *itemView = view;
            if (itemView==currentItemView) {
                if (!itemView.imgView.isAnimating) {
                    [itemView.imgView startAnimating];
                }
            } else {
                if (itemView.imgView.isAnimating) {
                    [itemView.imgView stopAnimating];
                }
            }
        }
    }
}

#pragma mark - Actions

- (void)shareBtnAction
{
    [self.delegate imageListPreviewController:self didClickShareImageLink:[_imageLinkList safeObjectAtIndex:_scrollView.currentIndex]];
}

#pragma mark - BPHorizontalScrollViewDataSource & BPHorizontalScrollViewDelegate

- (id<CKHorizontalScrollItemInterface>)horizontalScrollView:(CKHorizontalScrollView *)scroller itemViewForIndex:(NSInteger)index
{
    CKImageListPreviewItemView *view = (CKImageListPreviewItemView *)[scroller dequeueReusableItemView];
    if (!view) {
        view = [[CKImageListPreviewItemView alloc] initWithFrame:scroller.bounds];
        view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        view.photoViewDelegate = self;
    }
    view.frame = scroller.bounds;
    
    view.imageLink = [_imageLinkList safeObjectAtIndex:index];
    return view;
}

- (NSInteger)numberOfItems
{
    return _imageLinkList.count;
}

- (void)horizontalScrollView:(CKHorizontalScrollView *)scroller didSelectIndex:(NSInteger)index
{
    self.index = index;
    
    [self updateImageLoading];
    _pageLabel.text = [NSString stringWithFormat:@"%zd/%zd",index+1, _imageLinkList.count];
    [self updateAnimationStatus];
}

- (void)updateImageLoading
{
    BOOL isLoading = [(CKImageListPreviewItemView *)[_scrollView currentItemView] isLoading];
    _shareBtn.enabled = !isLoading;
}

#pragma mark - CLPlatePostImageCheckItemViewDelegate

- (void)didTapped:(CKImageListPreviewItemView *)photoView
{
    [self removeFromSuperviewWithAnimation];
}

- (void)didLoadingImageSuccess:(CKImageListPreviewItemView *)photoView
{
    if (photoView==(id)[_scrollView currentItemView]) {
        if (!photoView.imgView.isAnimating) {
            [photoView.imgView startAnimating];
        }
    }
}

- (void)didLoadingStatusChange:(CKImageListPreviewItemView *)photoView
{
    if (photoView==(id)[_scrollView currentItemView]) {
        [self updateImageLoading];
    }
}

@end


@implementation CKImageListPreviewContentView

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!_shouldAtuoLayout) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        [_scrollView resizeToFrame:CGRectMake(-5, 0, self.width+10, self.height) animated:YES duration:0.25];
        [_bottomView setFrame:CGRectMake(_bottomView.left, self.height-44, _bottomView.width, 44)];
    }];
}

@end
