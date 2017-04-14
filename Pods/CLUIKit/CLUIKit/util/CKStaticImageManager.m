//
//  CKStaticImageManager.m
//  CLCommon
//
//  Created by wangpeng on 14-6-16.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import "CKStaticImageManager.h"
#import "BPNSMutableDictionaryAdditions.h"
#import "BPExecutorService.h"
#import "BPUIImageAdditions.h"
#import "CKCoreUtil.h"
#import "BPCoreUtil.h"

@interface CKStaticImageManager () {
    NSMutableDictionary *_cache;
}

@end

@implementation CKStaticImageManager

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    self = [super init];
    if (self) {
        _cache = [[NSMutableDictionary alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)enterBackground
{
    [_cache removeAllObjects];
}

- (UIImage *)imageWithColorHex:(NSString *)colorHex size:(CGSize)size corner:(float)corner
{
    NSString *key = [NSString stringWithFormat:@"%@:%.0fx%.0fo%.0f", colorHex, size.width, size.height, corner];
    UIImage *result = [_cache objectForKey:key];
    if (result==nil) {
        result = [[[CKCoreUtil imageWithColor:[BPCoreUtil colorWithHexString:colorHex]] resizeToSize:size] addCornerRadius:corner];
        [_cache safeSetObject:result forKey:key];
    }
    return result;
}

- (UIImage *)imageWithColorHex:(NSString *)colorHex
{
    NSString *key = [NSString stringWithFormat:@"%@:%.0fx%.0fo%.0f", colorHex, 1.0f, 1.0f, 0.0f];
    UIImage *result = [_cache objectForKey:key];
    if (result==nil) {
        result = [CKCoreUtil imageWithColor:[BPCoreUtil colorWithHexString:colorHex]];
        [_cache safeSetObject:result forKey:key];
    }
    return result;
}

- (UIImage *)imageWithCacheKey:(NSString *)key
{
    if ([[_cache allKeys] containsObject:key]) {
        UIImage *result = [_cache objectForKey:key];
        return result;
    }
    return nil;
}

- (UIImage *)setImage:(UIImage *)image withCacheKey:(NSString *)key
{
    [_cache safeSetObject:image forKey:key];
    return image;
}

+ (CKStaticImageManager *)sharedInstance
{
    static id instance = nil;
    @synchronized (self) {
        if (instance==nil) {
            instance = [[CKStaticImageManager alloc] init];
        }
    }
    return instance;
}

@end
