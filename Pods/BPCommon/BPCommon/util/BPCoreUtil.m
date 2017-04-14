//
//  BPCoreUtil.m
//  VGEUtil
//
//  Created by Hunter Huang on 11/24/11.
//  Copyright (c) 2011 vge design. All rights reserved.
//

#import "BPCoreUtil.h"
#include <sys/sysctl.h>

@implementation BPCoreUtil

+ (BOOL)isNilOrNull:(id)obj {
    if (obj == nil || obj == [NSNull null]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isStringEmpty:(NSString *)str {
    if (str == nil) {
        return YES;
    }
    str = [NSString stringWithFormat:@"%@", str];
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}

+ (id) convertNSNullToNil: (id) source{
    if (source == [NSNull null]) {
        return nil;
    }
    return source;
}

+ (bool)convertToBool:(id)source {
    if (source == [NSNull null]) {
        return NO;
    } 
    return [source boolValue];
}

+ (NSString *)convertToString:(id)source {
    if ([source isKindOfClass:[NSString class]]) {
        return source;
    } else if ([source isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@", source];
    } else {
        return nil;
    }
}

+ (float)convertToFloat:(id)source {
    if ([source isKindOfClass:[NSString class]]) {
        return [source floatValue];
    } else if ([source isKindOfClass:[NSNumber class]]) {
        return [source floatValue];
    } else {
        return 0;
    }
}

+ (double)convertToDouble:(id)source {
    if ([source isKindOfClass:[NSString class]]) {
        return [(NSString *)source doubleValue];
    } else if ([source isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)source doubleValue];
    } else {
        return 0;
    }
}


+ (int)convertToInt:(id)source {
    if ([source isKindOfClass:[NSString class]]) {
        return [source intValue];
    } else if ([source isKindOfClass:[NSNumber class]]) {
        return [source intValue];
    } else {
        return 0;
    }
}

+ (UIColor *)colorWithHexValue:(uint)hexValue alpha:(float)alpha {
    NSArray *array = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."];
    if ([[array firstObject] floatValue] >= 10) {
        return [UIColor
                colorWithDisplayP3Red:((float)((hexValue & 0xFF0000) >> 16))/255.0
                green:((float)((hexValue & 0xFF00) >> 8))/255.0
                blue:((float)(hexValue & 0xFF))/255.0
                alpha:alpha];

    }
    return [UIColor
            colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
            green:((float)((hexValue & 0xFF00) >> 8))/255.0
            blue:((float)(hexValue & 0xFF))/255.0
            alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString*)hexString alpha:(float)alpha {
    if (hexString == nil || (id)hexString == [NSNull null]) {
        return nil;
    }
    UIColor *col;
    if (![hexString hasPrefix:@"#"]) {
        hexString = [NSString stringWithFormat:@"#%@", hexString];
    }
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#"
                                                     withString:@"0x"];
    uint hexValue;
    if ([[NSScanner scannerWithString:hexString] scanHexInt:&hexValue]) {
        col = [self colorWithHexValue:hexValue alpha:alpha];
    } else {
        // invalid hex string
        col = [UIColor clearColor];
    }
    return col;
}

+ (UIColor *) colorWithHexString: (NSString*) hexStr
{
    NSArray *hexArray = [hexStr componentsSeparatedByString:@"-"];
    if (hexArray.count==2) {
        return [BPCoreUtil colorWithHexString:hexArray[0] alpha:[hexArray[1] floatValue]/100.0f];
    } else {
        return [BPCoreUtil colorWithHexString:hexStr alpha:1.0f];
    }
}

+ (NSString *)createUUID {
    // Create universally unique identifier (object)
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    
    // Get the string representation of CFUUID object.
    CFStringRef cfStr = CFUUIDCreateString(kCFAllocatorDefault, uuidObject);
    NSString *uuidStr = (__bridge NSString *)cfStr;
    
    CFRelease(uuidObject);
    CFRelease(cfStr);
    
    return uuidStr;
}

+ (void)moveRandomObjectFromArray:(NSMutableArray *)fromArr toArray:(NSMutableArray *)toArr
{
    if (fromArr.count>0) {
        int index = arc4random()%fromArr.count;
        [toArr addObject:fromArr[index]];
        [fromArr removeObjectAtIndex:index];
        [self moveRandomObjectFromArray:fromArr toArray:toArr];
    }
}

+ (NSArray *)generateRadomIndexArrayWithCapacity:(NSUInteger)capacity
{
    NSMutableArray *fromArr = [NSMutableArray arrayWithCapacity:capacity];
    for (int i=0; i<capacity; i++) {
        [fromArr addObject:@(i)];
    }
    NSMutableArray *toArr = [NSMutableArray arrayWithCapacity:capacity];
    [self moveRandomObjectFromArray:fromArr toArray:toArr];
    return toArr;
}

+ (NSString*)devicePlatform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    return platform;
}

+ (CGFloat)screenOnePixel
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (size.width == 414) {
        return 0.385f;
    } else {
        if ([UIScreen mainScreen].scale < 2) {
            return 1.0f;
        }
        return 0.5f;
    }
}

+ (NSInteger)compressBufferExtra
{
    return 100;
}


@end
