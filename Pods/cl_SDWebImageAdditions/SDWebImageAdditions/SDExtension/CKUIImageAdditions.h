//
//  CKUIImageAdditions.h
//  QueryViolations
//
//  Created by R_flava_Man on 17/3/23.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CKUIImageAdditions)

+ (nullable UIImage *)ORIGsd_imageWithData:(nullable NSData *)data;

+ (nullable UIImage *)ORIGdecodedImageWithImage:(nullable UIImage *)image;

+ (nullable UIImage *)ORIGdecodedAndScaledDownImageWithImage:(nullable UIImage *)image;

@end
