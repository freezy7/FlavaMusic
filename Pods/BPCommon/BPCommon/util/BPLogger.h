//
//  BPLogger.h
//  VGEUtil
//
//  Created by Hunter Huang on 8/13/11.
//  Copyright 2011 Hunter Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

#if DEBUG
#define BPLog(...) NSLog(__VA_ARGS__)
#else
#define BPLog(...) /* */
#endif

typedef enum {
    BPLogLevelDebug=0,
    BPLogLevelInfo,
    BPLogLevelWarn,
    BPLogLevelError,
    BPLogLevelFatal
} BPLogLevel;

@interface BPLogger : NSObject

// default error level
+ (void)setLogLevel:(BPLogLevel)level;

+ (void)debug:(NSString *)format, ...;
+ (void)info:(NSString *)format, ...;
+ (void)warn:(NSString *)format, ...;
+ (void)error:(NSString *)format, ...;
+ (void)fatal:(NSString *)format, ...;

+ (void)debugWithRect:(CGRect)rect prefix:(NSString *)prefix;
+ (void)debugWithPoint:(CGPoint)point prefix:(NSString *)prefix;
+ (void)debugWithSize:(CGSize)size prefix:(NSString *)prefix;

@end
