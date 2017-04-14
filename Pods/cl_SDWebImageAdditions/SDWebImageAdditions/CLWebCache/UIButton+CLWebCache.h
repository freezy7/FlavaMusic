//
//  UIButton+web.h
//  CLCommon
//
//  Created by wangpeng on 14-6-28.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CLWebCache)

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

#pragma mark - image 加圆角

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder failedImage:(UIImage *)failedImage;
- (void)setCornerImage:(UIImage *)image;

@end
