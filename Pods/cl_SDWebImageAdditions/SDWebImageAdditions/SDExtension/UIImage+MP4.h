//
//  UIImage+MP4.h
//  Pods
//
//  Created by Wang Peng on 16/4/14.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (MP4)

@property (nonatomic, strong, readonly) NSData *mp4Data;

+ (NSString *)mp4PathWithCachePath:(NSString *)cachePath;

+ (UIImage *)sd_mp4WithData:(NSData *)data;

@end
