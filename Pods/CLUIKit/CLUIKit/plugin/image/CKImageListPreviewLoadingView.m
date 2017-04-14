//
//  CLImageLoadingView.m
//  CLCommon
//
//  Created by Kent on 13-12-27.
//  Copyright (c) 2013年 eclicks. All rights reserved.
//

#import "CKImageListPreviewLoadingView.h"
#import "CKUIView+Animation.h"
#import "BPUIViewAdditions.h"

@interface CKImageListPreviewLoadingView () {
    BOOL _isLoading;
    UIImageView *_loadingImgView;
    
    UILabel *_progressLabel;
}

@end

@implementation CKImageListPreviewLoadingView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _loadingImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width/2-41/2, self.height/2-41/2, 41, 41)];
        _loadingImgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _loadingImgView.image = [UIImage imageNamed:@"CLUIKit.bundle/img_image_preview_loading"];
        [self addSubview:_loadingImgView];
        
        _progressLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _progressLabel.backgroundColor = [UIColor clearColor];
        _progressLabel.font = [UIFont systemFontOfSize:ceilf(_loadingImgView.width/4.0f)];
        _progressLabel.textColor = [UIColor whiteColor];
        _progressLabel.autoresizingMask = _loadingImgView.autoresizingMask;
        [self addSubview:_progressLabel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)setProgress:(float)progress
{
    _progress = fabsf(progress);
    
    [self updateProgressLabel];
}

- (void)updateProgressLabel
{
    _progressLabel.text = [NSString stringWithFormat:@"%.0f%%", floorf(_progress*100)];
}

- (void)startAnimation
{
    _isLoading = YES;
    [self setProgress:0];
    if (self.window) {
        [_loadingImgView startRotateAnimation];
    }
}

- (void)enterForeground
{
    if (_isLoading) {
        [_loadingImgView startRotateAnimation];
    }
}

- (void)didMoveToWindow
{
    if (_isLoading) {
        [_loadingImgView startRotateAnimation];
    }
}

- (void)stopAnimation
{
    _isLoading = NO;
    [_loadingImgView stopAllAnimation];
    [self removeFromSuperview];
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
}

@end
