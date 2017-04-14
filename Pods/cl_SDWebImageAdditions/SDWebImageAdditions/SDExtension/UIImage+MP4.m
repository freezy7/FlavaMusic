//
//  UIImage+MP4.m
//  Pods
//
//  Created by Wang Peng on 16/4/14.
//
//

#import "UIImage+MP4.h"
#import <objc/runtime.h>

static char mp4DataKey;

@implementation UIImage (MP4)

@dynamic mp4Data;

- (void)setMp4Data:(NSData *)mp4Data
{
    objc_setAssociatedObject(self, &mp4DataKey, mp4Data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSData *)mp4Data
{
    return objc_getAssociatedObject(self, &mp4DataKey);
}

+ (NSString *)mp4PathWithCachePath:(NSString *)cachePath
{
    NSString *mp4Path = [cachePath stringByAppendingString:@".mp4"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:mp4Path]) {
        [[NSFileManager defaultManager] linkItemAtURL:[NSURL fileURLWithPath:cachePath] toURL:[NSURL fileURLWithPath:mp4Path] error:nil];
    }
    return mp4Path;
}

+ (UIImage *)sd_mp4WithData:(NSData *)data
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [image setMp4Data:data];
    return image;
}

@end