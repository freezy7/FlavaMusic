//
//  CKUIImageAdditions.m
//  QueryViolations
//
//  Created by R_flava_Man on 17/3/23.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import "CKUIImageAdditions.h"
#import "UIImage+MultiFormat.h"
#import "UIImage+MP4.h"
#import "SDWebImageDecoder.h"
#import <objc/runtime.h>

@implementation UIImage(CKUIImageAdditions)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        void (^__method_hook)(Class, SEL, SEL, SEL) = ^(Class cls, SEL sel, SEL newSel, SEL origSel) {
            Method method = class_getClassMethod(cls, sel);
            Method newMethod = class_getClassMethod(cls, newSel);
            
            if (class_addMethod(cls, origSel, method_getImplementation(method), method_getTypeEncoding(method))) {
                Method origMethod = class_getClassMethod(cls, origSel);
                method_setImplementation(origMethod, method_getImplementation(method));
                method_setImplementation(method, method_getImplementation(newMethod));
            }
        };
        
        __method_hook([self class], @selector(sd_imageWithData:), @selector(NEWsd_imageWithData:), @selector(ORIGsd_imageWithData:));
        __method_hook([self class], @selector(decodedImageWithImage:), @selector(NEWdecodedImageWithImage:), @selector(ORIGdecodedImageWithImage:));
        __method_hook([self class], @selector(decodedAndScaledDownImageWithImage:), @selector(NEWdecodedAndScaledDownImageWithImage:), @selector(ORIGdecodedAndScaledDownImageWithImage:));
    });
}

+ (nullable UIImage *)NEWsd_imageWithData:(nullable NSData *)data
{
    SDImageFormat imageFormat = [NSData sd_imageFormatForImageData:data];
    UIImage *image;
    if (imageFormat == SDImageFormatUndefined) {
        //关键之处，检测是否是小视频 ftyp
        if (data.length>12) {
            if (((char *)(data.bytes))[4]==0x66&&
                ((char *)(data.bytes))[5]==0x74&&
                ((char *)(data.bytes))[6]==0x79&&
                ((char *)(data.bytes))[7]==0x70) {
                //@"video/mp4"
                image = [UIImage sd_mp4WithData:data];
            }
        }
    } else {
        image = [UIImage ORIGsd_imageWithData:data];
    }
    return image;
}

+ (nullable UIImage *)NEWdecodedImageWithImage:(nullable UIImage *)image
{
    if (image.mp4Data) {
        return image;
    }
    return [UIImage ORIGdecodedImageWithImage:image];
}

+ (nullable UIImage *)NEWdecodedAndScaledDownImageWithImage:(nullable UIImage *)image
{
    if (image.mp4Data) {
        return image;
    }
    return [UIImage ORIGdecodedAndScaledDownImageWithImage:image];
}

//占位使用
+ (nullable UIImage *)ORIGsd_imageWithData:(nullable NSData *)data
{
    return nil;
}

+ (nullable UIImage *)ORIGdecodedImageWithImage:(nullable UIImage *)image
{
    return nil;
}

+ (nullable UIImage *)ORIGdecodedAndScaledDownImageWithImage:(nullable UIImage *)image
{
    return nil;
}

@end
