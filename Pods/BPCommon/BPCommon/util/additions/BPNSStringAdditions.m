//
//  BPNSStringAdditions.m
//  VGEUtil
//
//  Created by Hunter Huang on 11/23/11.
//  Copyright (c) 2011 vge design. All rights reserved.
//

#import "BPNSStringAdditions.h"
#import "BPNSDataAdditions.h"
#import <UIKit/UIKit.h>
#import "BPLogger.h"
#import "FBEncryptorAES.h"

@implementation NSString (vge)

- (BOOL)isWhitespaceAndNewlines {
    NSCharacterSet* space = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![space characterIsMember:c]) {
            return NO;
        }
    }
    return YES;
}

- (NSString*)md5Hash {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
}

- (NSString*)sha1Hash {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1Hash];
}

- (NSString *)aesEncryptBase64StringWithKeyString:(NSString*)keyString separateLines:(BOOL)separateLines
{
    return [FBEncryptorAES encryptBase64String:self keyString:keyString separateLines:separateLines];
}

- (NSString *)aesDecryptBase64StringWithKeyString:(NSString*)keyString
{
    return [FBEncryptorAES decryptBase64String:self keyString:keyString];
}

- (NSString *)urlEncoded {
    CFStringRef cfUrlEncodedString = CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                             (__bridge CFStringRef)self,NULL,
                                                                             (CFStringRef)@"+!*’();:@&=$,/?%#[]",
                                                                             kCFStringEncodingUTF8);
    
    NSString *urlEncoded = [NSString stringWithString:(__bridge NSString *)cfUrlEncodedString];
    CFRelease(cfUrlEncodedString);
    return urlEncoded;
}

- (NSString *)getUrlQueryString {
    NSString *str = nil;
    NSRange start = [self rangeOfString:@"?"];
    if (start.location != NSNotFound) {
        str = [self substringFromIndex:start.location+start.length-1];
    }
    return str;
}

- (NSString *)getUrlParamValueForkey:(NSString *)key {
    NSString *str = nil;
    NSString *params = [self getUrlQueryString]; // 返回的值包含“?”
    // 更精确的查找，为避免查找expires_in的时候返回的是r2_expires_in的值
    NSString *key1 = [NSString stringWithFormat:@"?%@=", key];
    NSRange start = [params rangeOfString:key1];
    if (start.location == NSNotFound) {
        key1 = [NSString stringWithFormat:@"&%@=", key];
        start = [params rangeOfString:key1];
    }
    if (start.location != NSNotFound) {
        NSRange end = [[params substringFromIndex:start.location+start.length] rangeOfString:@"&"];
        NSUInteger offset = start.location+start.length;
        str = end.location == NSNotFound ? [params substringFromIndex:offset] : [params substringWithRange:NSMakeRange(offset, end.location)];
        str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    return str;
}

- (NSURL *)serializeURLWithParams:(NSDictionary *)params {
    return [self serializeURLWithParams:params httpMethod:@"GET"];
}

- (NSURL *)serializeURLWithParams:(NSDictionary *)params httpMethod:(NSString *)httpMethod {
    
    if (params==nil) {
        return [NSURL URLWithString:self];
    }
    
    NSURL* parsedURL = [NSURL URLWithString:self];
    NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
    
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator]) {
        if (([[params valueForKey:key] isKindOfClass:[UIImage class]])
            ||([[params valueForKey:key] isKindOfClass:[NSData class]])) {
            if ([httpMethod isEqualToString:@"GET"]) {
                [BPLogger warn:@"can not use GET to upload a file"];
            }
            continue;
        }
        
        CFStringRef escaped_value = CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)[params objectForKey:key], NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
        CFRelease(escaped_value);
    }
    NSString* query = [pairs componentsJoinedByString:@"&"];
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", self, queryPrefix, query]];
}

- (BOOL)validateWithRegex:(NSString *)regex
{
    NSPredicate *validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [validate evaluateWithObject:self];
}

@end
