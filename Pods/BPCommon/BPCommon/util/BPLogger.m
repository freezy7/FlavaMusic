//
//  BPLogger.m
//  VGEUtil
//
//  Created by Hunter Huang on 8/13/11.
//  Copyright 2011 Hunter Huang. All rights reserved.
//

#import "BPLogger.h"

// error level by default
static BPLogLevel _level = BPLogLevelError;

@implementation BPLogger

+ (void)setLogLevel:(BPLogLevel)level
{
    _level = level;
}

+ (void)debug:(NSString *)format, ...
{
    if (_level <= BPLogLevelDebug) {
        va_list argList;
        va_start(argList, format);
        NSLogv(format, argList);
        va_end(argList);
    }
}

+ (void)info:(NSString *)format, ...
{
    if (_level <= BPLogLevelInfo) {
        va_list argList;
        va_start(argList, format);
        NSLogv(format, argList);
        va_end(argList);
    }
}

+ (void)warn:(NSString *)format, ...
{
    if (_level <= BPLogLevelWarn) {
        va_list argList;
        va_start(argList, format);
        NSLogv(format, argList);
        va_end(argList);
    }
}

+ (void)error:(NSString *)format, ...
{
    if (_level <= BPLogLevelError) {
        va_list argList;
        va_start(argList, format);
        NSLogv(format, argList);
        va_end(argList);
    }
}

+ (void)fatal:(NSString *)format, ...
{
    if (_level <= BPLogLevelFatal) {
        va_list argList;
        va_start(argList, format);
        NSLogv(format, argList);
        va_end(argList);
    }
}

+ (void)debugWithRect:(CGRect)rect prefix:(NSString *)prefix {
    [self debug:@"%@ Rect:(%f, %f, %f, %f)", prefix, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height];
}

+ (void)debugWithPoint:(CGPoint)point prefix:(NSString *)prefix {
    [self debug:@"%@ Point:(%f, %f)", prefix, point.x, point.y];
}

+ (void)debugWithSize:(CGSize)size prefix:(NSString *)prefix {
    [self debug:@"%@ Size:(%f, %f)", prefix, size.width, size.height];
}

@end
