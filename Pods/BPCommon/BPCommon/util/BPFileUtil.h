//
//  BPFileUtil.h
//  VGEUtil
//
//  Created by Hunter Huang on 8/13/11.
//  Copyright 2011 Hunter Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BPFileUtil : NSObject

+ (void)addSkipBackupAttributeToItemAtURL:(NSURL *)url;
+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)path;

/**
 获取系统document根目录
 */
+ (NSString *)getDocumentRootPath;
/**
 获取系统document根目录的指定下级目录，如果目录不存在，立即创建之。
 */
+ (NSString *)getDocumentPathWithDir:(NSString *)dir;
+ (NSString *)getDocumentPathWithDir:(NSString *)dir fileName:(NSString *)fileName;

/**
 获取系统caches根目录
 */
+ (NSString *)getCachesRootPath;

+ (NSString *)getCachesPathWithDir:(NSString *)dir;
+ (NSString *)getCachesPathWithDir:(NSString *)dir fileName:(NSString *)fileName;

/**
 相对目录绝对目录转换
 */
+ (NSString *)fullFilePathFromAnyPath:(NSString *)path;
+ (NSString *)documentFilePathFromAnyPath:(NSString *)path;

@end
