//
//  CKCoreUtil.h
//  CLUtilKit
//
//  Created by wangpeng on 16/1/6.
//  Copyright © 2016年 wangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum CKDeviceType {
    CKDeviceTypeIPhone320x480,
    CKDeviceTypeIPhone320x568,
    CKDeviceTypeIPhone375x667,
    CKDeviceTypeIPhone414x736,
    CKDeviceTypeIPad
} CKDeviceType;

@interface CKCoreUtil : NSObject

#pragma mark - 简单创建屏幕一像素的线

+ (CALayer *)createOnePixelLineWithWidth:(CGFloat)width color:(UIColor *)color;
+ (CALayer *)createOnePixelLineWithHeight:(CGFloat)height color:(UIColor *)color;

#pragma mark - 获取设备屏幕信息
+ (CKDeviceType)deviceType;

#pragma mark - 获取屏幕上真实的一像素对应的逻辑一像素
+ (CGFloat)screenOnePixel;

#pragma mark - 通过颜色创建图片
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColorString:(NSString *)string;
+ (UIImage *)imageWithColorString:(NSString *)string cornerRadius:(CGFloat)radius withSize:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color cornerRadius:(CGFloat)radius withSize:(CGSize)size;
+ (UIImage *)imageWithColorString:(NSString *)string dash:(CGFloat *)dash withSize:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color dash:(CGFloat *)dash withSize:(CGSize)size;

#pragma mark - System Version
+ (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size fixString:(NSString *)string;
+ (CGSize)sizeWithFont:(UIFont *)font fixString:(NSString *)string;
+ (BOOL)systemBigThan6;
+ (BOOL)systemBigThan7;
+ (BOOL)systemBigThan8;
+ (BOOL)systemBigThan9;
+ (BOOL)systemBigThan10;

+ (BOOL)isIPhone;
+ (BOOL)isIPad;

@end
