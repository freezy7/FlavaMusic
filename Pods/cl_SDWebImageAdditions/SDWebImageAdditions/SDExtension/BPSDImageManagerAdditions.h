//
//  BPSDImageManagerAdditions.h
//  BPCommon
//
//  Created by wangpeng on 14/11/14.
//
//

#import <Foundation/Foundation.h>
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+CLWebCache.h"
#import "UIButton+WebCache.h"
#import "UIButton+CLWebCache.h"

@interface SDWebImageManager (fix)

- (BOOL)hasCacheForURL:(NSURL *)url;
- (UIImage *)cacheImageForURL:(NSURL *)url;
- (NSString *)cachedThumbLinkWithImageLink:(NSString *)link;

@end
