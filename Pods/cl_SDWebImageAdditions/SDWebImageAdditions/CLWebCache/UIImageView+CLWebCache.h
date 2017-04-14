//
//  UIImageView+web.h
//  CLCommon
//
//  Created by lin on 13-11-20.
//  Copyright (c) 2013年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (CLWebCache)

//additions
- (void)setImageWithURL:(NSURL *)url;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)setImageWithURL:(NSURL *)url success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;

#pragma mark - 有圆角的的UIImageView 加载图片时自动切圆角存储

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder failedImage:(UIImage *)failedImage;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder failedImage:(UIImage *)failedImage imgViewMode:(UIViewContentMode)mode;
- (void)setCornerImage:(UIImage *)image;

#pragma mark - 网络加载图片并做高斯模糊缓存显示
//对高斯模糊图缓存
- (void)setBlurImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)setBlurDefaultImage:(UIImage *)defaultImage;

@end
