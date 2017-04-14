//
//  UIImageView+web.m
//  CLCommon
//
//  Created by lin on 13-11-20.
//  Copyright (c) 2013年 eclicks. All rights reserved.
//

#import "UIImageView+CLWebCache.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "objc/runtime.h"
#import "BPExecutorService.h"
#import "UIView+WebCache.h"
#import "FLAnimatedImageView.h"
#import "BPSDImageManagerAdditions.h"
#import "BPUIImageAdditions.h"
#import "BPUIViewAdditions.h"
#import "UIImage+ImageEffects.h"

static char cacheUrlKey;

@interface UIImageView ()

@property (nonatomic, strong) NSString *cacheUrl;

@end

@implementation UIImageView (CLWebCache)

- (void)setCacheUrl:(NSString *)cacheUrl
{
     objc_setAssociatedObject(self, &cacheUrlKey, cacheUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)cacheUrl
{
    return objc_getAssociatedObject(self, &cacheUrlKey);
}

#pragma mark - CLWebCache 便利方法

- (void)setImageWithURL:(NSURL *)url
{
    [self sd_setImageWithURL:url];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self sd_setImageWithURL:url placeholderImage:placeholder];
}

- (void)setImageWithURL:(NSURL *)url success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure
{
    [self sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
            if (success) success(image);
        } else {
            if (failure) failure(error);
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure
{
    [self sd_setImageWithURL:url placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
            if (success) success(image);
        } else {
            if (failure) failure(error);
        }
    }];
}

#pragma mark - 有圆角的的imageView 加载图片时自动切圆角存储

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder failedImage:(UIImage *)failedImage
{
    NSAssert(![self respondsToSelector:@selector(setAnimatedImage:)], @"should not be a FLAnimatedImageView,");
    [self setImageWithURL:url placeholderImage:placeholder failedImage:failedImage downloadTagStr:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder failedImage:(UIImage *)failedImage imgViewMode:(UIViewContentMode)mode
{
    NSAssert(![self respondsToSelector:@selector(setAnimatedImage:)], @"should not be a FLAnimatedImageView,");
    [self setImageWithURL:url placeholderImage:placeholder failedImage:failedImage downloadTagStr:nil];
    [self setContentMode:mode];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder failedImage:(UIImage *)failedImage downloadTagStr:(NSString *)tagStr 
{
    NSAssert(![self respondsToSelector:@selector(setAnimatedImage:)], @"should not be a FLAnimatedImageView,");
    self.cacheUrl = nil;
    __weak UIImageView *weakSelf = self;
    NSString *cacheUrl = nil;
    if (weakSelf.layer.cornerRadius>0) {
        cacheUrl = [[url absoluteString] stringByAppendingFormat:@"_%.0fx%.0f_o%.0f", weakSelf.width, weakSelf.height, weakSelf.cornerRadius];
        if ([[SDWebImageManager sharedManager] hasCacheForURL:[NSURL URLWithString:cacheUrl]]) {
            [BPExecutorService addBlockOnBackgroundThread:^{
                UIImage *image = [[SDWebImageManager sharedManager] cacheImageForURL:[NSURL URLWithString:cacheUrl]];
                [BPExecutorService addBlockOnMainThread:^{
                    weakSelf.image = image;
                    [weakSelf startPushFadeTransition];
                }];
            }];
            return;
        }
    } else if (weakSelf.layer.cornerRadius==0) {
        if ([[SDWebImageManager sharedManager] hasCacheForURL:url]) {
            [BPExecutorService addBlockOnBackgroundThread:^{
                UIImage *image = [[SDWebImageManager sharedManager] cacheImageForURL:url];
                [BPExecutorService addBlockOnMainThread:^{
                    weakSelf.image = image;
                    [weakSelf startPushFadeTransition];
                }];
            }];
            return;
        }
    }
    
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        __strong UIImageView *strongSelf = weakSelf;
        if (!strongSelf) return;
        if (error==nil) {
            if (strongSelf.layer.cornerRadius>0) {
                strongSelf.image = placeholder;
                self.cacheUrl = cacheUrl;
                [strongSelf setCornerImage:image cacheUrl:cacheUrl];
                strongSelf.clipsToBounds = NO;
            } else {
                if (image!=strongSelf.image) {
                    [strongSelf setImage:image];
                    [strongSelf startPushFadeTransition];
                }
            }
        } else {
            if (failedImage) {
                [strongSelf setImage:failedImage];
            }
        }
    }];
}

- (void)setCornerImage:(UIImage *)image cacheUrl:(NSString *)cacheUrl
{
    __block UIImageView *weakSelf = self;
    CGRect rect = weakSelf.bounds;
    float cr = weakSelf.layer.cornerRadius;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
        [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cr] addClip];
        if (rect.size.width*image.size.height!=rect.size.height*image.size.width) {
            CGSize blockSize = CGSizeMake(rect.size.width*[UIScreen mainScreen].scale, rect.size.height*[UIScreen mainScreen].scale);
            CGSize result = CGSizeZero;
            result.width = blockSize.width;
            result.height = blockSize.width*image.size.height/image.size.width;
            if (result.height<blockSize.height) {
                result.height = blockSize.height;
                result.width = blockSize.height*image.size.width/image.size.height;
            }
            UIImage *subImage = [[image resizeToSize:result] getSubImage:CGRectMake((result.width/2-blockSize.width/2), (result.height/2-blockSize.height/2), blockSize.width, blockSize.height)];
            [subImage drawInRect:rect];
        } else {
            [image drawInRect:rect];
        }
        __strong UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        if (cacheUrl) {
            [[SDImageCache sharedImageCache] storeImage:result forKey:[[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:cacheUrl]] completion:nil];
        }
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong UIImageView *strongSelf = weakSelf;
            if (!strongSelf) return;
            if ([strongSelf.cacheUrl isEqualToString:cacheUrl]) {
                strongSelf.image = result;
            }
        });
    });
}

- (void)setCornerImage:(UIImage *)image
{
    [self setCornerImage:image cacheUrl:nil];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

#pragma mark - 网络加载图片并做高斯模糊缓存显示

- (void)setBlurImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    NSAssert(![self respondsToSelector:@selector(setAnimatedImage:)], @"should not be a FLAnimatedImageView,");
    self.cacheUrl = nil;
    [self sd_cancelCurrentImageLoad];
    __weak UIImageView *weakSelf = self;
    NSString *cacheUrl = [NSString stringWithFormat:@"%@_blur", url.absoluteString];
    if ([[SDWebImageManager sharedManager] hasCacheForURL:[NSURL URLWithString:cacheUrl]]) {
        [BPExecutorService addBlockOnBackgroundThread:^{
            UIImage *blurImage = [[SDWebImageManager sharedManager] cacheImageForURL:[NSURL URLWithString:cacheUrl]];
            [BPExecutorService addBlockOnMainThread:^{
                weakSelf.image = blurImage;
            }];
        }];
    } else {
        [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error==nil) {
                [BPExecutorService addBlockOnBackgroundThread:^{
                    UIImage *blurImage = [self accelerateBlurWithImage:image];
                    [[SDWebImageManager sharedManager] saveImageToCache:blurImage forURL:[NSURL URLWithString:cacheUrl]];
                   [BPExecutorService addBlockOnMainThread:^{
                       weakSelf.image = blurImage;
                   }];
                }];
            } else {
                weakSelf.image = placeholder;
            }
        }];
    }
}

- (void)setBlurDefaultImage:(UIImage *)defaultImage
{
    NSString *cacheUrl = @"https://www.chelun.com/default_blur";
    __weak UIImageView *weakSelf = self;
    if ([[SDWebImageManager sharedManager] hasCacheForURL:[NSURL URLWithString:cacheUrl]]) {
        [BPExecutorService addBlockOnBackgroundThread:^{
            UIImage *blurImage = [[SDWebImageManager sharedManager] cacheImageForURL:[NSURL URLWithString:cacheUrl]];
            [BPExecutorService addBlockOnMainThread:^{
                weakSelf.image = blurImage;
            }];
        }];
    } else {
        [BPExecutorService addBlockOnBackgroundThread:^{
            UIImage *blurImage = [self accelerateBlurWithImage:defaultImage];
            [[SDWebImageManager sharedManager] saveImageToCache:blurImage forURL:[NSURL URLWithString:cacheUrl]];
            [BPExecutorService addBlockOnMainThread:^{
                weakSelf.image = blurImage;
            }];
        }];
    }
}

#pragma mark - private

- (void)startPushFadeTransition
{
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [animation setDuration:0.3f];
    [animation setRemovedOnCompletion:YES];
    [self.layer addAnimation:animation forKey:@"fade"];
}

- (UIImage *)accelerateBlurWithImage:(UIImage *)image
{
    // R 15  F 1.0  C [UIColor colorWithWhite:0.2f alpha:0.2f]
    return [image applyBlurWithRadius:15 tintColor:[UIColor colorWithWhite:0.0f alpha:0.3f] saturationDeltaFactor:1.0 maskImage:nil];
}

@end
