//
//  CKCoreUtil.m
//  CLUtilKit
//
//  Created by wangpeng on 16/1/6.
//  Copyright © 2016年 wangpeng. All rights reserved.
//

#import "CKCoreUtil.h"
#import "BPCoreUtil.h"
#import <objc/runtime.h>

@implementation CKCoreUtil

#pragma mark - 简单创建屏幕一像素的线

+ (CALayer *)createOnePixelLineWithWidth:(CGFloat)width color:(UIColor *)color
{
    CALayer *line = [[CALayer alloc] init];
    line.frame = CGRectMake(0, 0, width, [self screenOnePixel]);
    line.backgroundColor = color.CGColor;
    return line;
}

+ (CALayer *)createOnePixelLineWithHeight:(CGFloat)height color:(UIColor *)color
{
    CALayer *line = [[CALayer alloc] init];
    line.frame = CGRectMake(0, 0, [self screenOnePixel], height);
    line.backgroundColor = color.CGColor;    
    return line;
}

#pragma mark - 获取设备屏幕信息

+ (CKDeviceType)deviceType
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (size.width==320||size.width==640) {
        if (size.height==480||size.height==960) {
            return CKDeviceTypeIPhone320x480;
        } else {
            return CKDeviceTypeIPhone320x568;
        }
    } else if (size.width==375) {
        return CKDeviceTypeIPhone375x667;
    } else if (size.width==414) {
        return CKDeviceTypeIPhone414x736;
    } else {
        return CKDeviceTypeIPad;
    }
}

#pragma mark - 获取屏幕上真实的一像素对应的逻辑一像素

+ (CGFloat)screenOnePixel
{
    if ([self deviceType]==CKDeviceTypeIPhone414x736) {
        return 1.0f/3.0f;
    } else {
        if ([UIScreen mainScreen].scale < 2) {
            return 1.0f;
        } else {
            return 0.5;
        }
    }
}

#pragma mark - 通过颜色创建

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColorString:(NSString *)string
{
    return [self imageWithColor:[BPCoreUtil colorWithHexString:string]];
}

+ (UIImage *)imageWithColorString:(NSString *)string cornerRadius:(CGFloat)radius withSize:(CGSize)size
{
    return [self imageWithColor:[BPCoreUtil colorWithHexString:string] cornerRadius:radius withSize:size];
}

+ (UIImage *)imageWithColor:(UIColor *)color cornerRadius:(CGFloat)radius withSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [color setFill];
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColorString:(NSString *)string dash:(CGFloat *)dash withSize:(CGSize)size
{
    return [self imageWithColor:[BPCoreUtil colorWithHexString:string] dash:dash withSize:size];
}

+ (UIImage *)imageWithColor:(UIColor *)color dash:(CGFloat *)dash withSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [color setStroke];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineDash:dash count:2 phase:0];
    [path setLineWidth:size.height];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(size.width, 0)];
    [path stroke];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - System Version

+ (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size fixString:(NSString *)string
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f) {
        CGSize result = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:nil].size;
        result.height = ceilf(result.height);
        result.width = ceilf(result.width);
        return result;
    } else {
        CGSize result = [string sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        result.height = ceilf(result.height);
        result.width = ceilf(result.width);
        return result;
    }
}

+ (CGSize)sizeWithFont:(UIFont *)font fixString:(NSString *)string
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f) {
        CGSize result = [string sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]];
        result.height = ceilf(result.height);
        result.width = ceilf(result.width);
        return result;
    } else {
        CGSize result = [string sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        result.height = ceilf(result.height);
        result.width = ceilf(result.width);
        return result;
    }
}

#pragma mark - System Version

+ (NSInteger)bigSystemVersion
{
    NSArray *array = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."];
    if (array.count>0) {
        return [[array objectAtIndex:0] intValue];
    } else {
        return 0;
    }
}

+ (BOOL)systemBigThan7
{
    return [self bigSystemVersion]>=7;
}

+ (BOOL)systemBigThan8
{
    return [self bigSystemVersion]>=8;
}

+ (BOOL)systemBigThan9
{
    return [self bigSystemVersion]>=9;
}

+ (BOOL)systemBigThan10
{
    return [self bigSystemVersion]>=10;
}

+ (BOOL)systemBigThan6
{
    return [self bigSystemVersion]>=6;
}

+ (BOOL)isIPhone
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}

+ (BOOL)isIPad
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

@end
