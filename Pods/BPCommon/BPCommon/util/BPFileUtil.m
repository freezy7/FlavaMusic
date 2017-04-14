//
//  BPFileUtil.m
//  VGEUtil
//
//  Created by Hunter Huang on 8/13/11.
//  Copyright 2011 Hunter Huang. All rights reserved.
//

#import "BPFileUtil.h"
#import "RegexKitLite.h"
#import "BPNSURLAdditions.h"
#import <sys/xattr.h>

@implementation BPFileUtil

+ (void)addSkipBackupAttributeToItemAtURL:(NSURL *)url
{
    if([url respondsToSelector:@selector(setResourceValue:forKey:error:)])
    {
        [url setResourceValue:[NSNumber numberWithBool: YES] forKey:@"NSURLIsExcludedFromBackupKey"  error:nil];
    }
}

+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)path
{
    if ((floor(NSFoundationVersionNumber) < NSFoundationVersionNumber_iOS_5_1)) {
        const char* folderPath = [path fileSystemRepresentation];
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        int result = setxattr(folderPath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    } else {
        NSError *error = nil;
        NSURL* url = [NSURL safeFileURLWithPath:path];
        BOOL success = [url setResourceValue: [NSNumber numberWithBool: YES]
                                      forKey: NSURLIsExcludedFromBackupKey
                                       error: &error];
        return success;
    }
}

+ (NSString *)getDocumentRootPath {
    NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)getDocumentPathWithDir:(NSString *)dir {
    NSString *docDir = [[self getDocumentRootPath] stringByAppendingPathComponent:dir];
    if (![[NSFileManager defaultManager] fileExistsAtPath:docDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:docDir
								  withIntermediateDirectories:YES 
												   attributes:nil 
														error:NULL];
    }
    return docDir;
}

+ (NSString *)getDocumentPathWithDir:(NSString *)dir fileName:(NSString *)fileName {
	return [[self getDocumentPathWithDir:dir] stringByAppendingPathComponent:fileName];
}

+ (NSString *)getCachesRootPath {
    NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)getCachesPathWithDir:(NSString *)dir {
    NSString *docDir = [[self getCachesRootPath] stringByAppendingPathComponent:dir];
    if (![[NSFileManager defaultManager] fileExistsAtPath:docDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:docDir
								  withIntermediateDirectories:YES
												   attributes:nil
														error:NULL];
    }
    return docDir;
}

+ (NSString *)getCachesPathWithDir:(NSString *)dir fileName:(NSString *)fileName {
	return [[self getCachesPathWithDir:dir] stringByAppendingPathComponent:fileName];
}

+ (NSString *)fullFilePathFromAnyPath:(NSString *)path
{
    if (path.length==0) {
        return nil;
    }
    NSString *documentFilePath = [self documentFilePathFromAnyPath:path];
    NSString *fullPath = [[BPFileUtil getDocumentRootPath] stringByAppendingFormat:@"/%@", documentFilePath];
    NSString *fullDir = [fullPath stringByDeletingLastPathComponent];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:fullDir
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    return fullPath;
}

+ (NSString *)documentFilePathFromAnyPath:(NSString *)path
{
    if (path.length==0) {
        return nil;
    }
    if ([path hasPrefix:@"/var/mobile/"]) {
        return [path stringByReplacingOccurrencesOfRegex:@"/var/mobile/.+/Documents/" withString:@""];
    } else {
        return path;
    }
}

@end
