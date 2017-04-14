//
//  CKSDWebImageDownloaderOperationAdditions.m
//  QueryViolations
//
//  Created by R_flava_Man on 17/3/23.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import "CKSDWebImageDownloaderOperationAdditions.h"
#import "UIImage+MP4.h"
#import <objc/runtime.h>

@interface SDWebImageDownloaderOperation ()

//MARK: private
- (nullable UIImage *)ORIGscaledImageForKey:(nullable NSString *)key image:(nullable UIImage *)image;

//占位方法
- (nullable UIImage *)scaledImageForKey:(nullable NSString *)key image:(nullable UIImage *)image;

@end

@implementation SDWebImageDownloaderOperation (CKSDWebImageDownloaderOperationAdditions)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        void (^__method_hook)(Class, SEL, SEL, SEL) = ^(Class cls, SEL sel, SEL newSel, SEL origSel) {
            Method method = class_getInstanceMethod(cls, sel);
            Method newMethod = class_getInstanceMethod(cls, newSel);
            
            if (class_addMethod(cls, origSel, method_getImplementation(method), method_getTypeEncoding(method))) {
                method_setImplementation(method, method_getImplementation(newMethod));
            }
        };
        
        if ([self instancesRespondToSelector:@selector(scaledImageForKey:image:)]) {
            __method_hook([self class], @selector(scaledImageForKey:image:), @selector(NEWscaledImageForKey:image:), @selector(ORIGscaledImageForKey:image:));
        }
    });
}

#pragma mark - private

- (nullable UIImage *)NEWscaledImageForKey:(nullable NSString *)key image:(nullable UIImage *)image
{
    if (image.mp4Data) {
        return image;
    }
    return [self ORIGscaledImageForKey:key image:image];
}

@end
