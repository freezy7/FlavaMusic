//
//  UIButton+web.m
//  CLCommon
//
//  Created by wangpeng on 14-6-28.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import "UIButton+CLWebCache.h"
#import "UIButton+WebCache.h"
#import "SDImageCache.h"
#import "BPExecutorService.h"
#import "BPSDImageManagerAdditions.h"
#import "BPUIImageAdditions.h"
#import "BPUIViewAdditions.h"
#import "objc/runtime.h"

static char cacheUrlKey;

@interface UIButton ()

@property (nonatomic, strong) NSString *cacheUrl;

@end

@implementation UIButton (CLWebCache)

- (void)setCacheUrl:(NSString *)cacheUrl
{
    objc_setAssociatedObject(self, &cacheUrlKey, cacheUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)cacheUrl
{
    return objc_getAssociatedObject(self, &cacheUrlKey);
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:placeholder];
}

- (void)setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:placeholder];
}

#pragma mark - image 加圆角

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder failedImage:(UIImage *)failedImage
{
    self.cacheUrl = nil;
    [self sd_cancelImageLoadForState:UIControlStateNormal];
    __weak UIButton *weakSelf = self;
    NSString *cacheUrl = nil;
    if (weakSelf.layer.cornerRadius>0) {
        cacheUrl = [[url absoluteString] stringByAppendingFormat:@"_%.0fx%.0f_o%.0f", weakSelf.width, weakSelf.height, weakSelf.cornerRadius];
        NSURL *cCacheUrl = [NSURL URLWithString:cacheUrl];
        if (cCacheUrl&&[[SDWebImageManager sharedManager] hasCacheForURL:cCacheUrl]) {
            [BPExecutorService addBlockOnBackgroundThread:^{
                UIImage *image = [[SDWebImageManager sharedManager] cacheImageForURL:[NSURL URLWithString:cacheUrl]];
                [BPExecutorService addBlockOnMainThread:^{
                    [weakSelf setImage:image forState:UIControlStateNormal];
                }];
            }];
            return;
        }
    } else if (weakSelf.layer.cornerRadius==0) {
        if (url&&[[SDWebImageManager sharedManager] hasCacheForURL:url]) {
            [BPExecutorService addBlockOnBackgroundThread:^{
                UIImage *image = [[SDWebImageManager sharedManager] cacheImageForURL:url];
                [BPExecutorService addBlockOnMainThread:^{
                    [weakSelf setImage:image forState:UIControlStateNormal];
                }];
            }];
            return;
        }
    }
    
    self.clipsToBounds = YES;
    
    [self sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        __strong UIButton *strongSelf = weakSelf;
        if (!strongSelf) return;
        if (!error) {
            if (strongSelf.layer.cornerRadius>0) {
                [strongSelf setImage:placeholder forState:UIControlStateNormal];
                self.cacheUrl = cacheUrl;
                [strongSelf setCornerImage:image cacheUrl:cacheUrl];
            } else {
                if (image!=[strongSelf imageForState:UIControlStateNormal]) {
                    [strongSelf setImage:image forState:UIControlStateNormal];
                }
                strongSelf.clipsToBounds = NO;
            }
        } else {
            strongSelf.clipsToBounds = NO;
        }
    }];
}

- (void)setCornerImage:(UIImage *)image cacheUrl:(NSString *)cacheUrl
{
    __block UIButton *weakSelf = self;
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
            UIImage *subImage = [[image resizeToSize:result] getSubImage:CGRectMake(-(result.width/2-blockSize.width/2), -(result.height/2-blockSize.height/2), blockSize.width, blockSize.height)];
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
            __strong UIButton *strongSelf = weakSelf;
            if (!strongSelf) return;
            if ([strongSelf.cacheUrl isEqualToString:cacheUrl]) {
                [strongSelf setImage:result forState:UIControlStateNormal];
                strongSelf.clipsToBounds = NO;
            }
        });
    });
}

- (void)setCornerImage:(UIImage *)image
{
    [self setCornerImage:image cacheUrl:nil];
}

@end
