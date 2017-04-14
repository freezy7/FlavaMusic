//
//  BPReplaceHttp.m
//  BPCommon
//
//  Created by wangpeng on 4/19/13.
//
//

#import "BPReplaceHttp.h"

@interface BPReplaceHttp() {
    
}

@end

@implementation BPReplaceHttp

+ (BPReplaceHttp *)sharedInstance
{
    static id instance = nil;
    if (!instance) {
        instance = [[BPReplaceHttp alloc] init];
    }
    return instance;
}

#pragma mark - filter

- (BOOL)needIngnoreReplaceHttp:(NSString *)value
{
    if ([value rangeOfString:@"video.file.chelun.com"].length > 0) {
        return YES;
    } else if ([value rangeOfString:@"static.file.chelun.com"].length > 0) {
        return YES;
    } else if ([value rangeOfString:@"down.file.chelun.com"].length > 0) {
        return YES;
    } else if ([value rangeOfString:@"img.file.chelun.com"].length > 0) {
        return YES;
    } else if ([value rangeOfString:@"pimg.file.chelun.com"].length > 0) {
        return YES;
    } else if ([value rangeOfString:@"chelun.eclicks.cn"].length > 0) {
        return YES;
    } else if ([value rangeOfString:@"file.oa.chelun.com"].length > 0) { //测试环境
        return YES;
    }
    return NO;
}

+ (id)replaceHttpToHttps:(id)value needReplaceHttp:(BOOL)needReplaceHttp
{
    if (needReplaceHttp) {
        if ([value isKindOfClass:[NSString class]]) {
            if (![[BPReplaceHttp sharedInstance] needIngnoreReplaceHttp:value]) {
                NSString *valueStr = (NSString *)value;
                if ([valueStr hasPrefix:@"http://"]) {
                    valueStr = [valueStr stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
                    value = valueStr;
                }
            }
        }
    }
    if (value == nil) {
        value = @"";
    }
    return value;
}

+ (NSMutableDictionary *)filterNSNullFromDictionary:(NSDictionary *)dict needReplaceHttp:(BOOL)needReplaceHttp
{
    /*
     NSMutableDictionary *result = [NSMutableDictionary dictionary];
     [result setObject:[NSNull null] forKey:@"11"]; //支持过滤
     [result setObject:@"http://www.chelun.com" forKey:@"22"]; //支持过滤
     [result setObject:@{@"text":@"精",@"color":@"http://www.baidu.com", @"xxxx":[NSNull null]} forKey:@"33"];  //支持过滤
     [result setObject:@[@"lalala", [NSNull null]] forKey:@"44"]; //不支持过滤
     */
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    
    if ([dict isKindOfClass:[NSDictionary class]]) {
        for (NSString *key in [dict allKeys]) {
            id value = [dict objectForKey:key];
            if ([value isKindOfClass:[NSArray class]]) {
                [mutableDict setObject:[self filterNSNullFromArray:(NSArray *)value needReplaceHttp:needReplaceHttp] forKey:key];
            } else if ([value isKindOfClass:[NSDictionary class]]) {
                [mutableDict setObject:[self filterNSNullFromDictionary:(NSDictionary *)value needReplaceHttp:needReplaceHttp] forKey:key];
            } else {
                if (nil != value && [NSNull null] != value) {
                    id replaceValue = [self replaceHttpToHttps:value needReplaceHttp:needReplaceHttp];
                    [mutableDict setObject:replaceValue forKey:key];
                }
            }
        }
    }
    
    return mutableDict;
}

+ (NSMutableArray *)filterNSNullFromArray:(NSArray *)array needReplaceHttp:(BOOL)needReplaceHttp
{
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[array count]];
    
    if ([array isKindOfClass:[NSArray class]]) {
        for (id value in array) {
            if ([value isKindOfClass:[NSArray class]]) {
                [mutableArray addObject:[self filterNSNullFromArray:(NSArray *)value needReplaceHttp:needReplaceHttp]];
            } else if ([value isKindOfClass:[NSDictionary class]]) {
                [mutableArray addObject:[self filterNSNullFromDictionary:(NSDictionary *)value needReplaceHttp:needReplaceHttp]];
            } else {
                if (nil != value && [NSNull null] != value) {
                    id replaceValue = [self replaceHttpToHttps:value needReplaceHttp:needReplaceHttp];
                    [mutableArray addObject:replaceValue];
                }
            }
        }
    }
    
    return mutableArray;
}

@end
