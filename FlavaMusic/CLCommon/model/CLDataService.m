//
//  CLDataService.m
//  FlavaMusic
//
//  Created by R_flava_Man on 17/1/24.
//  Copyright © 2017年 R_style_Man. All rights reserved.
//

#import "CLDataService.h"

@implementation CLDataService

+ (void)getRequestWithMethod:(NSString * _Nullable)method
                  parameters:(NSDictionary * _Nullable)parameters
                     success:(void (^)(NSURLSessionDataTask * _Nullable, id _Nullable))success
                     failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nullable))failure
{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
//    
//    NSMutableDictionary *parDict = [NSMutableDictionary dictionaryWithDictionary:parameters];
//    [parDict setObject:APP_TAOBAO_KEY forKey:@"app_key"];
//    [parDict setObject:method forKey:@"method"];
//    [parDict setObject:@"json" forKey:@"format"];
//    [parDict setObject:@"2.0" forKey:@"v"];
//    [parDict setObject:@"md5" forKey:@"sign_method"];
//    [parDict setObject:timestamp forKey:@"timestamp"];
//    
//    NSString *sign = [[self class] mapParameters:parDict];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@",APP_BAOJIA_SERVER, method];
    
    [AFHTTPSessionManager manager].responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [[AFHTTPSessionManager manager] GET:requestUrl parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
        failure(task, error);
    }];
}


@end
