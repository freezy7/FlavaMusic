//
//  CLDataService.h
//  FlavaMusic
//
//  Created by R_flava_Man on 17/1/24.
//  Copyright © 2017年 R_style_Man. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface CLDataService : NSObject

+ (void)getRequestWithMethod:(NSString * _Nullable)method
                  parameters:(NSDictionary * _Nullable)parameters
                     success:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success
                     failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure;

@end
