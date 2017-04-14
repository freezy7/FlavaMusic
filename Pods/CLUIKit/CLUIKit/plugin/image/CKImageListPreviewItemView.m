//
//  CKImageListPreviewItemView.m
//  CLCommon
//
//  Created by Kent on 13-12-26.
//  Copyright (c) 2013年 eclicks. All rights reserved.
//

#import "CKImageListPreviewItemView.h"
#import "CKImageListPreviewLoadingView.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCache.h"
#import "CKReachabilityUtil.h"
#import "SDWebImageManager.h"
#import "UIImage+GIF.h"
#import "CKRequestProgressCenter.h"
#import "BPNSURLAdditions.h"
#import "BPUIViewAdditions.h"
#import "UIImage+MultiFormat.h"
#import "BPSDImageManagerAdditions.h"
#import "BPNSMutableDictionaryAdditions.h"
#import "CKRequestProgressCenter.h"
#import "CKUIManager.h"

@interface CKImageListPreviewItemView () <UIScrollViewDelegate> {
    CKImageListPreviewLoadingView *_loadingView;
}

@end

@implementation CKImageListPreviewItemView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.minimumZoomScale = 1.f;
        self.maximumZoomScale = 2.f;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        
        _imgView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(5, 0, self.width-10, self.height)];
        _imgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.clipsToBounds = YES;
        [self addSubview:_imgView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progressDidUpdate:) name:APP_EVENT_CHELUN_NETPROGRESS_DOWNLOAD_DID_UPDATE object:nil];
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(viewWasTapped) object:nil];
    UITouch *touch = [touches anyObject];
    if (touch.tapCount==1) {
        [self performSelector:@selector(viewWasTapped) withObject:nil afterDelay:0.2f];
    } else if (touch.tapCount==2) {
        [self viewWasDoubleTapped:touch];
    }
}

- (void)viewDidShow
{
    [_imgView startAnimating];
}

- (void)viewDidHidden
{
    [_imgView stopAnimating];
}

- (CGSize)validImageSize:(UIImage *)imageToShow
{
    CGFloat width = imageToShow.size.width;
    CGFloat height = imageToShow.size.height;
    
    // 不超过当前view大小
    if (width>self.width-10) {
        height = height*(self.width-10)/width;
        width = self.width-10;
    }
    if (height>self.height) {
        width = width*self.height/height;
        height = self.height;
    }
    
    return CGSizeMake(width, height);
}

- (void)updateImgViewFrameAfterImageSet
{
    CGSize size = [self validImageSize:_imgView.image];
    _imgView.frame = CGRectMake(5, 0, size.width, size.height);
    _imgView.center = CGPointMake(self.width/2, self.height/2);
    
    [self setMaxZoomScalesForCurrentBounds];
}

- (void)viewWillResize
{
    _imgView.transform = CGAffineTransformIdentity;
    _imgView.frame = CGRectMake(5, 0, self.width-10, self.height);
    self.zoomScale = 1.0f;
    
    [self updateImgViewFrameAfterImageSet];
}

- (void)setImageLink:(NSString *)imageLink
{
    _imageLink = imageLink;
    
    _imgView.transform = CGAffineTransformIdentity;
    _imgView.frame = CGRectMake(5, 0, self.width-10, self.height);
    _imgView.image = nil;
    self.zoomScale = 1.0f;
    self.contentSize = self.size;
    
    if (!_imageLink) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:_imageLink];
    if ([url isFileURL]) {
        NSData *data = [NSData dataWithContentsOfFile:[url path]];
        SDImageFormat imageFormat = [NSData sd_imageFormatForImageData:data];
        if (imageFormat == SDImageFormatGIF) {
            _imgView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
            if (_imgView.isAnimating) [_imgView stopAnimating];
        } else {
            _imgView.image = [UIImage sd_imageWithData:data];
        }
        [self stopLoading];
        [self updateImgViewFrameAfterImageSet];
    } else {
        if (![[SDWebImageManager sharedManager] hasCacheForURL:url]) {
            [self startLoading];
            
            __weak CKImageListPreviewItemView *itemView = self;
            [_imgView sd_setImageWithURL:url placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                [[CKRequestProgressCenter sharedInstance] updateDownloadProgress:expectedSize>0?((float)receivedSize)/((float)expectedSize):0 forTagStr:_imageLink];
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (!error) {
                    if (itemView.imgView.isAnimating) {
                        [itemView.imgView stopAnimating];
                    }
                    [itemView updateImgViewFrameAfterImageSet];
                    [itemView stopLoading];
                } else {
                    [itemView stopLoadingWithFailed];
                    if (![CKReachabilityUtil sharedInstance].reachability.isReachable) {
                        [[CKUIManager sharedManager] showNetworkErrorHintHUDInWindow];
                    } else if (itemView) {
                        [[CKUIManager sharedManager] showErrorHintHUDInWindow:@"下载原图失败"];
                    }
                }
            }];
        } else {
            [_imgView sd_cancelCurrentImageLoad];
            [_imgView setImageWithURL:url];
            if (_imgView.isAnimating) [_imgView stopAnimating];
            [self stopLoading];
            [self updateImgViewFrameAfterImageSet];
        }
    }
}

- (BOOL)isZoomed
{
    return !([self zoomScale] == [self minimumZoomScale]);
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = _imgView.height / scale;
    zoomRect.size.width  = _imgView.width / scale;
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0)-30;
    
    return zoomRect;
}

- (void)zoomToLocation:(CGPoint)location
{
    float newScale;
    CGRect zoomRect;
    if ([self isZoomed]) {
        zoomRect = self.bounds;
    } else {
        newScale = [self maximumZoomScale];
        zoomRect = [self zoomRectForScale:newScale withCenter:location];
    }
    [self zoomToRect:zoomRect animated:YES];
}

- (void)turnOffZoom
{
    if ([self isZoomed]) {
        [self zoomToLocation:CGPointZero];
    }
}

- (void)setIsLoading:(BOOL)isLoading
{
    _isLoading = isLoading;
    if (_photoViewDelegate&&[_photoViewDelegate respondsToSelector:@selector(didLoadingStatusChange:)]) {
        [_photoViewDelegate didLoadingStatusChange:self];
    }
}

- (void)startLoading
{
    if (_loadingView==nil) {
        _loadingView = [[CKImageListPreviewLoadingView alloc] initWithFrame:self.bounds];
        _loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_loadingView];
        [_loadingView startAnimation];
    }
    self.isLoading = YES;
    
    if (_aniImgView==nil) {
        _aniImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _aniImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        _aniImgView.contentMode = UIViewContentModeScaleAspectFill;
        _aniImgView.clipsToBounds = YES;
        _aniImgView.hidden = YES;
        [self insertSubview:_aniImgView belowSubview:_loadingView];
    }
    
    NSURL *url = [NSURL URLWithString:_imageLink];
    if (![[SDWebImageManager sharedManager] hasCacheForURL:url]) {
        NSString *thumbLink = [[SDWebImageManager sharedManager] cachedThumbLinkWithImageLink:_imageLink];
        if (thumbLink) {
            _aniImgView.image = [[SDWebImageManager sharedManager] cacheImageForURL:[NSURL URLWithString:thumbLink]];
            _aniImgView.hidden = NO;
            _aniImgView.frame = CGRectMake(self.width/2-_aniImgView.image.size.width/2/2, self.height/2-_aniImgView.image.size.height/2/2, _aniImgView.image.size.width/2, _aniImgView.image.size.height/2);
            
        }
    }
}

- (void)stopLoadingWithFailed
{
    if (_loadingView) {
        [_loadingView removeFromSuperview];
        _loadingView = nil;
    }
}

- (void)stopLoading
{
    if (_loadingView) {
        [_loadingView removeFromSuperview];
        _loadingView = nil;
    }
    self.isLoading = NO;
    
    if (_aniImgView&&_aniImgView.hidden==NO) {
        if (_imgView.image) {
            _imgView.hidden = YES;
            _aniImgView.image = _imgView.image;
            CGSize size = [self validImageSize:_aniImgView.image];
            [UIView animateWithDuration:0.45f animations:^{
                _aniImgView.frame = CGRectMake(self.width/2-size.width/2, self.height/2-size.height/2, size.width, size.height);
            } completion:^(BOOL finished) {
                [_aniImgView removeFromSuperview];
                _aniImgView = nil;
                _imgView.hidden = NO;
                if (_photoViewDelegate&&[_photoViewDelegate respondsToSelector:@selector(didLoadingImageSuccess:)]) {
                    [_photoViewDelegate didLoadingImageSuccess:self];
                }
            }];
        } else {
            [_aniImgView removeFromSuperview];
            _aniImgView = nil;
        }
    }
}

- (void)setMaxZoomScalesForCurrentBounds {
    CGSize boundsSize = CGSizeMake(self.width-10, self.height);
    CGSize imageSize = _imgView.bounds.size;
    
    // calculate min/max zoomscale
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat maxScale = MAX(MAX(xScale, yScale), 2.0);       // use minimum of these to allow the image to become fully visible
    
    self.maximumZoomScale = maxScale;
}

- (void)progressDidUpdate:(NSNotification *)notification
{
    NSString *tagStr = notification.object;
    if ([tagStr isEqualToString:_imageLink]) {
        float progress = [notification.userInfo floatForKey:@"progress"];
        _loadingView.progress = progress;
    }
}

#pragma mark - Actions

- (void)viewWasTapped
{
    if (_photoViewDelegate && [_photoViewDelegate respondsToSelector:@selector(didTapped:)]) {
        [_photoViewDelegate didTapped:self];
    }
}

- (void)viewWasDoubleTapped:(UITouch *)touch
{
    [self zoomToLocation:[touch locationInView:self]];
}

- (void)viewWasLongPressed:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        if (_photoViewDelegate && [_photoViewDelegate respondsToSelector:@selector(didLongPressed:)]) {
            [_photoViewDelegate didLongPressed:self];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (_imgView.image) {
        for (id view in [scrollView subviews]) {
            if ([view isKindOfClass:[UIImageView class]]) {
                return view;
            }
        }
    }
    return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    _imgView.top = floor((MAX(scrollView.contentSize.height, scrollView.height)-_imgView.height)/2);
    _imgView.left = floor((MAX(scrollView.contentSize.width, scrollView.width)-_imgView.width)/2);
}

@end
