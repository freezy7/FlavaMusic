//
//  CKSDImageCacheAdditions.m
//  QueryViolations
//
//  Created by R_flava_Man on 17/3/22.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import "CKSDImageCacheAdditions.h"
#import "SDImageCacheConfig.h"
#import "UIImage+MP4.h"
#import <objc/runtime.h>

@interface SDImageCache ()

//MARK: public
- (nullable NSOperation *)ORIGqueryCacheOperationForKey:(nullable NSString *)key done:(nullable SDCacheQueryCompletedBlock)doneBlock;

- (void)ORIGstoreImage:(nullable UIImage *)image
         imageData:(nullable NSData *)imageData
            forKey:(nullable NSString *)key
            toDisk:(BOOL)toDisk
        completion:(nullable SDWebImageNoParamsBlock)completionBlock;

- (nullable UIImage *)ORIGimageFromDiskCacheForKey:(nullable NSString *)key;

//MARK: private
- (nullable UIImage *)ORIGscaledImageForKey:(nullable NSString *)key image:(nullable UIImage *)image;

//占位方法
- (nullable UIImage *)scaledImageForKey:(nullable NSString *)key image:(nullable UIImage *)image;
- (nullable UIImage *)diskImageForKey:(nullable NSString *)key;
- (nullable NSData *)diskImageDataBySearchingAllPathsForKey:(nullable NSString *)key;

@end

@implementation SDImageCache (CKSDImageCacheAdditions)

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
        
        __method_hook([self class], @selector(storeImage:imageData:forKey:toDisk:completion:), @selector(NEWstoreImage:imageData:forKey:toDisk:completion:), @selector(ORIGstoreImage:imageData:forKey:toDisk:completion:));
        __method_hook([self class], @selector(imageFromDiskCacheForKey:), @selector(NEWimageFromDiskCacheForKey:), @selector(ORIGimageFromDiskCacheForKey:));
        __method_hook([self class], @selector(queryCacheOperationForKey:done:), @selector(NEWqueryCacheOperationForKey:done:), @selector(ORIGqueryCacheOperationForKey:done:));
        
        if ([self instancesRespondToSelector:@selector(scaledImageForKey:image:)]) {
            __method_hook([self class], @selector(scaledImageForKey:image:), @selector(NEWscaledImageForKey:image:), @selector(ORIGscaledImageForKey:image:));
        }
    });
}

#pragma mark - public

- (nullable NSOperation *)NEWqueryCacheOperationForKey:(nullable NSString *)key done:(nullable SDCacheQueryCompletedBlock)doneBlock
{
    
    if (!key) {
        if (doneBlock) {
            doneBlock(nil, nil, SDImageCacheTypeNone);
        }
        return nil;
    }
    UIImage *image = [self imageFromMemoryCacheForKey:key];
    if (image) {
        
        return [self ORIGqueryCacheOperationForKey:key done:doneBlock];
    } else {
        
        NSOperation *operation = [NSOperation new];
        dispatch_queue_t kIoQueue = [[SDImageCache sharedImageCache] valueForKey:@"_ioQueue"];
        dispatch_async(kIoQueue, ^{
            if (operation.isCancelled) {
                // do not call the completion if cancelled
                return;
            }
            
            @autoreleasepool {
                UIImage *diskImage = [self imageFromDiskCacheForKey:key];
                if (diskImage.mp4Data) {
                    if (doneBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            doneBlock(diskImage, diskImage.mp4Data, SDImageCacheTypeDisk);
                        });
                    }
                } else {
                    NSData *diskData = [self diskImageDataBySearchingAllPathsForKey:key];
                    //上方用到imageFromDiskCacheForKey是为了,disk取出后加入到 cacheMemory
                    if (doneBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            doneBlock(diskImage, diskData, SDImageCacheTypeDisk);
                        });
                    }
                }
            }
        });
        return operation;
    }
}

- (void)NEWstoreImage:(nullable UIImage *)image
             imageData:(nullable NSData *)imageData
                forKey:(nullable NSString *)key
                toDisk:(BOOL)toDisk
            completion:(nullable SDWebImageNoParamsBlock)completionBlock
{
    if (image.mp4Data) {
        if (!image || !key) {
            if (completionBlock) {
                completionBlock();
            }
            return;
        }
        //对比SDImageCache 去除 cacheImagesInMemory
        dispatch_queue_t kIoQueue = [[SDImageCache sharedImageCache] valueForKey:@"_ioQueue"];
        dispatch_async( kIoQueue, ^{
            NSData *data = image.mp4Data;
            //data无数据时不做图片转data,因为无效
            [self storeImageDataToDisk:data forKey:key];
            
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock();
                });
            }
        });
    } else {
        [self ORIGstoreImage:image imageData:imageData forKey:key toDisk:toDisk completion:completionBlock];
    }
}

- (nullable UIImage *)NEWimageFromDiskCacheForKey:(nullable NSString *)key
{
    if ([key hasSuffix:@".mp4"]) {//判断MP4文件做单独处理（not safe）
        UIImage *diskImage = [self diskImageForKey:key];
        return diskImage;
    } else {
        return [self ORIGimageFromDiskCacheForKey:key];
    }
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
