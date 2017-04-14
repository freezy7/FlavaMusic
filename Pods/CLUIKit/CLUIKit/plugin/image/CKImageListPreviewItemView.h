//
//  CKImageListPreviewItemView.h
//  CLCommon
//
//  Created by Kent on 13-12-26.
//  Copyright (c) 2013年 eclicks. All rights reserved.
//

#import "CKHorizontalScrollView.h"
#import "FLAnimatedImage.h"

@protocol CKImageListPreviewItemViewDelegate;

@interface CKImageListPreviewItemView : UIScrollView <CKHorizontalScrollItemInterface>

@property (nonatomic) int index;
@property (nonatomic, strong) NSString *imageLink;
@property (nonatomic, strong, readonly) FLAnimatedImageView *imgView;
@property (nonatomic, weak) id<CKImageListPreviewItemViewDelegate> photoViewDelegate;
@property (nonatomic, readonly) UIImageView *aniImgView;
@property (nonatomic) BOOL isLoading;

- (void)turnOffZoom;

@end

@protocol CKImageListPreviewItemViewDelegate <NSObject>

- (void)didLoadingImageSuccess:(CKImageListPreviewItemView *)photoView;

@optional
- (void)didTapped:(CKImageListPreviewItemView *)photoView;
- (void)didLongPressed:(CKImageListPreviewItemView *)photoView;
- (void)didLoadingStatusChange:(CKImageListPreviewItemView *)photoView;

@end
