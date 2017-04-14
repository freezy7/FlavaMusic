//
//  CKCoreUtil+Net.m
//  CLNetKit
//
//  Created by wangpeng on 16/1/13.
//  Copyright © 2016年 wangpeng. All rights reserved.
//

#import "CKCoreUtil+Net.h"
#import "CKReachabilityUtil.h"
#import "BPCoreUtil.h"
#import "SDWebImageManager.h"
#import "BPSDImageManagerAdditions.h"

@implementation CKCoreUtil (Net)

#pragma mark - 通过链接获得图片大小

+ (CGSize)sizeWithImageLink:(NSString *)imageLink
{
    NSArray *tmps;
    if ([imageLink hasSuffix:@".jpg"]) {
        tmps = [[[imageLink lastPathComponent] stringByReplacingOccurrencesOfString:@".jpg" withString:@""] componentsSeparatedByString:@"_"];
    } else if ([imageLink hasSuffix:@".gif"]) {
        tmps = [[[imageLink lastPathComponent] stringByReplacingOccurrencesOfString:@".gif" withString:@""] componentsSeparatedByString:@"_"];
    } else if ([imageLink hasSuffix:@".png"]) {
        tmps = [[[imageLink lastPathComponent] stringByReplacingOccurrencesOfString:@".png" withString:@""] componentsSeparatedByString:@"_"];
    } else if ([imageLink hasSuffix:@".mp4"]) {
        tmps = [[[imageLink lastPathComponent] stringByReplacingOccurrencesOfString:@".mp4" withString:@""] componentsSeparatedByString:@"_"];
    }
    
    if (tmps.count>=3) {
        return CGSizeMake([tmps[tmps.count-2] intValue], [tmps[tmps.count-1] intValue]);
    } else {
        return CGSizeZero;
    }
}

#pragma mark - 通过图片大小获得缩略图地址

+ (NSString *)thumbUrlWithImageLink:(NSString *)link size:(CGSize)size
{
    return [self thumbUrlWithImageLink:link size:size thumbSize:NULL];
}

+ (NSString *)thumbUrlWithImageLink:(NSString *)link size:(CGSize)size thumbSize:(CGSize *)thumbSize
{
    return [self thumbUrlWithImageLink:link size:size autoRetina:YES];
}

+ (NSString *)thumbUrlWithImageLink:(NSString *)link size:(CGSize)size autoRetina:(BOOL)autoRetina
{
    return [self thumbUrlWithImageLink:link size:size autoRetina:autoRetina type:0];
}

+ (NSString *)thumbUrlWithImageLink:(NSString *)link size:(CGSize)size autoRetina:(BOOL)autoRetina type:(NSInteger)type
{
    if ([BPCoreUtil isStringEmpty:link]) {
        return nil;
    }
    
    if ([CKReachabilityUtil sharedInstance].isWifi) {
        autoRetina = YES;
    }
    
    if (link&&([[[link pathExtension] lowercaseString] isEqualToString:@"gif"]||[[[link pathExtension] lowercaseString] isEqualToString:@"mp4"])&&![[link lowercaseString] hasPrefix:@"file://"]&&![link hasPrefix:@"/"]) {
        link =  [[link stringByDeletingPathExtension] stringByAppendingString:@".jpg"];
    }
    
    NSString *rlink = [self internalThumbUrlWithImageLink:link size:size  autoRetina:YES type:type];
    if (autoRetina==YES) {
        return rlink;
    } else {
        NSString *nlink = [self internalThumbUrlWithImageLink:link size:size  autoRetina:NO type:type];
        if ([nlink isEqualToString:rlink]) {
            return rlink;
        } else {
            NSURL *rurl = [NSURL URLWithString:rlink];
            if (rurl==nil) {
                return nil;
            }
            if ([[SDWebImageManager sharedManager] hasCacheForURL:rurl]) {
                return rlink;
            } else {
                return nlink;
            }
        }
    }
}

+ (NSString *)internalThumbUrlWithImageLink:(NSString *)link size:(CGSize)size autoRetina:(BOOL)autoRetina type:(NSInteger)type
{
    if (autoRetina) {
        CGFloat scale = [UIScreen mainScreen].scale;
        if (scale>2.f) {
            scale = 2.f;
        }
        size = CGSizeMake(size.width*scale, size.height*scale);
    }
    if (type==0) {
        if (size.width<=50&&size.height<=50) {
            return [link stringByAppendingString:@"_50_50.jpg"];
        } else if (size.width<=70&&size.height<=70) {
            return [link stringByAppendingString:@"_70_70.jpg"];
        } else if (size.width<=80&&size.height<=80) {
            return [link stringByAppendingString:@"_80_80.jpg"];
        } else if (size.width<=100&&size.height<=100) {
            return [link stringByAppendingString:@"_100_100.jpg"];
        } else if (size.width<=140&&size.height<=140) {
            return [link stringByAppendingString:@"_140_140.jpg"];
        } else if (size.width<=160&&size.height<=160) {
            return [link stringByAppendingString:@"_160_160.jpg"];
        } else if (size.width<=320&&size.height<=320) {
            return [link stringByAppendingString:@"_320_320.jpg"];
        } else {
            return [link stringByAppendingString:@"_640_640.jpg"];
        }
    } else if (type==2) {
        if (size.width<=320) {
            return [link stringByAppendingString:@"_320_0_x.jpg"];
        } else {
            return [link stringByAppendingString:@"_640_0_x.jpg"];
        }
    } else {
        if (size.width<=180&&size.height<=180) {
            return [link stringByAppendingString:@"_180_180_wh.jpg"];
        } else if (size.width<=225&&size.height<=360) {
            return [link stringByAppendingString:@"_360_360_wh.jpg"];
        } else if (size.width<=225&&size.height<=900) {
            return [link stringByAppendingString:@"_225_900_wh.jpg"];
        } else if (size.width<=360&&size.height<=360) {
            return [link stringByAppendingString:@"_360_360_wh.jpg"];
        } else {
            return [link stringByAppendingString:@"_450_1800_wh.jpg"];
        }
    }
}

+ (CGSize)thumbSizeWithSize:(CGSize)size imageSize:(CGSize)imageSize type:(NSInteger)type
{
    if (type==0) {
        return size;
    } else if (type==2) {
        if (imageSize.width>size.width) {
            return CGSizeMake(size.width, imageSize.height*size.width/imageSize.width);
        } else {
            return imageSize;
        }
    } else {
        float whb = imageSize.width/imageSize.height;
        if (whb<0.25) {
            imageSize.height = imageSize.width*4;
        } else if (whb>4) {
            imageSize.width = imageSize.height*4;
        }
        CGSize resultSize = CGSizeZero;
        if (imageSize.width>size.width) {
            resultSize.width = size.width;
            resultSize.height = size.width*imageSize.height/imageSize.width;
        } else {
            resultSize.width = imageSize.width;
            resultSize.height = imageSize.height;
        }
        if (resultSize.height>size.height) {
            resultSize.height = size.height;
            resultSize.width = size.height*imageSize.width/imageSize.height;
        }
        return resultSize;
    }
}

@end
