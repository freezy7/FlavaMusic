//
//  BPCoreUtil.h
//  VGEUtil
//
//  Created by Hunter Huang on 11/24/11.
//  Copyright (c) 2011 vge design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BPCoreUtil : NSObject

+ (BOOL)isNilOrNull:(id)obj;

+ (BOOL)isStringEmpty:(NSString *)str;

/**
 * @param If source is a string, just return; if source is a number, convert it to a string; otherwise, return nil
 */
+ (id) convertNSNullToNil: (id) source;
+ (NSString *)convertToString:(id)source;
+ (float)convertToFloat:(id)source;
+ (double)convertToDouble:(id)source;
+ (int)convertToInt:(id)source;
+ (bool)convertToBool:(id)source;

//////////////////////////// color ////////////////////////////
+ (UIColor *) colorWithHexValue: (uint)hexValue alpha:(float)alpha;
+ (UIColor *) colorWithHexString: (NSString*) hexStr alpha: (float) alpha;
+ (UIColor *) colorWithHexString: (NSString*) hexStr; //支持alphpa FFFFFF-95 (95为不透明度的百分比)
+ (NSString *)createUUID;

// 生成一个index随机数组，数组中的元素为包含NSUInteger的NSNumber
// 例如capacity为200，生成的数组包含是0到199，只不过顺序是随机的
+ (NSArray *)generateRadomIndexArrayWithCapacity:(NSUInteger)capacity;

// 设备信息
+ (NSString*)devicePlatform;

+ (CGFloat)screenOnePixel;

//压缩时Buffer需要的额外内存空间
+ (NSInteger)compressBufferExtra;

@end
