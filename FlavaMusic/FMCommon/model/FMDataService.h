//
//  FMDataService.h
//  FlavaMusic
//
//  Created by R_flava_Man on 16/2/19.
//  Copyright © 2016年 R_style_Man. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface FMDataService : NSObject

+ (void)getRequestWithMethod:(NSString * _Nullable)method parameters:(NSDictionary * _Nullable)parameters
                     success:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success
                     failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure;

@end
