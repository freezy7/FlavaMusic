//
//  BPUIImageAdditions.h
//  VGEUtil
//
//  Created by Hunter Huang on 8/13/11.
//  Copyright 2011 Hunter Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

CGContextRef createARGBBitmapContextFromImage(CGImageRef image);

@interface UIImage(ws)

- (UIImage *)resizableImageForAlliOSVersionWithCapInsets:(UIEdgeInsets)capInsets;

/**
 将image按照指定的比例放大或缩小
 */
- (UIImage *)scaleToScale:(float)scale;

/**
 将image按照指定的大小放大或缩小
 */
- (UIImage *)resizeToSize:(CGSize)size;
- (UIImage *)resizeToSizeWithScale:(CGSize)size;

- (UIImage *)resizeWithMaxSize:(CGSize)size;

/**
 将image压缩到宽和长都不超过maxLength
 */
- (UIImage *)resizeWithMaxLength:(CGFloat)maxLength;

/**
 截取部分图像
  */
- (UIImage*)getSubImage:(CGRect)rect;

/**
 根据imageOrientation进行处理，返回的新image能按照UIImageOrientationUp的方向显示
 */
- (UIImage *)rotateImageWithOri:(int)ori;
- (UIImage *)rotateImage;

/**
 获取某一像素点的颜色值
 */
- (UIColor *)pixcelColorAtLocation:(CGPoint)point;

/**
 图片拼接
 */
- (UIImage *)addImageAtBottom:(UIImage *)image;

/**
 图片圆角
 */
- (UIImage *)addCornerRadius:(CGFloat)cornerRadius;


//
- (UIImage *)tintedImageUsingColor:(UIColor *)tintColor;

@end
