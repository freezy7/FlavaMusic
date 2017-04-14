//
//  CKStaticImageManager.h
//  CLCommon
//
//  Created by wangpeng on 14-6-16.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKStaticImageManager : NSObject

//colorHax可以如下使用 @“cccccc-20” 20%代表颜色的透明度
- (UIImage *)imageWithColorHex:(NSString *)colorHex size:(CGSize)size corner:(float)corner;
- (UIImage *)imageWithColorHex:(NSString *)colorHex;
- (UIImage *)imageWithCacheKey:(NSString *)key;
- (UIImage *)setImage:(UIImage *)image withCacheKey:(NSString *)key;
+ (CKStaticImageManager *)sharedInstance;

@end
