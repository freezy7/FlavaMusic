//
//  BPSDImageManagerAdditions.m
//  BPCommon
//
//  Created by wangpeng on 14/11/14.
//
//

#import "BPSDImageManagerAdditions.h"

@implementation SDWebImageManager (fix)

- (BOOL)hasCacheForURL:(NSURL *)url
{
    NSString *key = [self cacheKeyForURL:url];
    if ([self.imageCache imageFromMemoryCacheForKey:key] != nil) return YES;
    BOOL exists = NO;
    // this is an exception to access the filemanager on another queue than ioQueue, but we are using the shared instance
    // from apple docs on NSFileManager: The methods of the shared NSFileManager object can be called from multiple threads safely.
    exists = [[NSFileManager defaultManager] fileExistsAtPath:[self.imageCache defaultCachePathForKey:key]];
    
    if (!exists) {
        exists = [[NSFileManager defaultManager] fileExistsAtPath:[self.imageCache defaultCachePathForKey:key].stringByDeletingPathExtension];
    }
    return exists;
}

- (UIImage *)cacheImageForURL:(NSURL *)url
{
    return [[SDImageCache sharedImageCache] imageFromCacheForKey:[self cacheKeyForURL:url]];
}

- (NSString *)cachedThumbLinkWithImageLink:(NSString *)link
{
    if ([[[link pathExtension] lowercaseString] isEqualToString:@"gif"]) {
        link =  [[link stringByDeletingPathExtension] stringByAppendingString:@".jpg"];
    }
    NSString *result = link;
    if ([self hasCacheForURL:[NSURL URLWithString:result]]) return result;
    result = [NSString stringWithFormat:@"%@_450_1800_wh.jpg", link];
    if ([self hasCacheForURL:[NSURL URLWithString:result]]) return result;
    result = [NSString stringWithFormat:@"%@_360_360_wh.jpg", link];
    if ([self hasCacheForURL:[NSURL URLWithString:result]]) return result;
    result = [NSString stringWithFormat:@"%@_225_900_wh.jpg", link];
    if ([self hasCacheForURL:[NSURL URLWithString:result]]) return result;
    result = [NSString stringWithFormat:@"%@_180_180_wh.jpg", link];
    if ([self hasCacheForURL:[NSURL URLWithString:result]]) return result;
    result = [NSString stringWithFormat:@"%@_640_640.jpg", link];
    if ([self hasCacheForURL:[NSURL URLWithString:result]]) return result;
    result = [NSString stringWithFormat:@"%@_320_320.jpg", link];
    if ([self hasCacheForURL:[NSURL URLWithString:result]]) return result;
    result = [NSString stringWithFormat:@"%@_160_160.jpg", link];
    if ([self hasCacheForURL:[NSURL URLWithString:result]]) return result;
    result = [NSString stringWithFormat:@"%@_140_140.jpg", link];
    if ([self hasCacheForURL:[NSURL URLWithString:result]]) return result;
    result = [NSString stringWithFormat:@"%@_100_100.jpg", link];
    if ([self hasCacheForURL:[NSURL URLWithString:result]]) return result;
    result = [NSString stringWithFormat:@"%@_80_80.jpg", link];
    if ([self hasCacheForURL:[NSURL URLWithString:result]]) return result;
    result = [NSString stringWithFormat:@"%@_70_70.jpg", link];
    if ([self hasCacheForURL:[NSURL URLWithString:result]]) return result;
    result = [NSString stringWithFormat:@"%@_50_50.jpg", link];
    if ([self hasCacheForURL:[NSURL URLWithString:result]]) return result;
    result = [NSString stringWithFormat:@"%@_320_0_x.jpg", link];
    if ([self hasCacheForURL:[NSURL URLWithString:result]]) return result;
    result = [NSString stringWithFormat:@"%@_640_0_x.jpg", link];
    if ([self hasCacheForURL:[NSURL URLWithString:result]]) return result;
    return nil;
}

@end
