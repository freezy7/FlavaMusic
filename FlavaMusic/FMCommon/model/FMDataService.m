//
//  FMDataService.m
//  FlavaMusic
//
//  Created by R_flava_Man on 16/2/19.
//  Copyright © 2016年 R_style_Man. All rights reserved.
//

#import "FMDataService.h"
#import "NSString+MD5.h"

@implementation FMDataService

+ (void)getRequestWithMethod:(NSString * _Nullable)method parameters:(NSDictionary * _Nullable)parameters success:(void (^)(NSURLSessionDataTask * _Nullable, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nullable))failure
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    
    NSMutableDictionary *parDict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [parDict setObject:APP_TAOBAO_KEY forKey:@"app_key"];
    [parDict setObject:method forKey:@"method"];
    [parDict setObject:@"json" forKey:@"format"];
    [parDict setObject:@"2.0" forKey:@"v"];
    [parDict setObject:@"md5" forKey:@"sign_method"];
    [parDict setObject:timestamp forKey:@"timestamp"];
    
    NSString *sign = [[self class] mapParameters:parDict];
    
    [parDict setObject:sign forKey:@"sign"];
    
    [AFHTTPSessionManager manager].responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [[AFHTTPSessionManager manager] GET:APP_TAOBAO_SERVER parameters:parDict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
        failure(task, error);
    }];
}

+ (NSString *)mapParameters:(NSDictionary *)parameters
{
    NSString *signKey = nil;
    NSMutableArray *keyArr = [NSMutableArray arrayWithArray:[parameters allKeys]];
    for (int i = 0; i < keyArr.count; i++) {
        for (int j = i + 1; j < keyArr.count; j++) {
            NSString *ikey = [keyArr objectAtIndex:i];
            NSString *jkey = [keyArr objectAtIndex:j];
            unichar ichars = [ikey characterAtIndex:0];
            unichar jchars = [jkey characterAtIndex:0];
            if (jchars < ichars) {
                [keyArr replaceObjectAtIndex:i withObject:jkey];
                [keyArr replaceObjectAtIndex:j withObject:ikey];
            }
        }
    }
    for (NSString *key in keyArr) {
        if (signKey == nil) {
            signKey = [NSString stringWithFormat:@"%@%@",key, [parameters objectForKey:key]];
        } else {
            signKey = [signKey stringByAppendingFormat:@"%@%@",key, [parameters objectForKey:key]];
        }
        
    }
    signKey = [NSString stringWithFormat:@"%@%@%@",APP_TAOBAO_SECRET, signKey, APP_TAOBAO_SECRET];
    
    NSString *md5Key = [signKey MD5Digest];
    
    return [md5Key uppercaseString];
}

//普通字符串转换为十六进制的。

+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr]; 
    } 
    return hexStr; 
}

@end
