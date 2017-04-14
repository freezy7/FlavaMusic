//
//  BPURLRequest.h
//  YHHB
//
//  Created by Hunter Huang on 11/23/11.
//  Copyright (c) 2011 vge design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

extern NSString *const APP_EVENT_NETWORK_ERROR;

@protocol BPURLRequestDelegate;

@interface BPURLRequest : NSObject

@property (nonatomic, unsafe_unretained) id<BPURLRequestDelegate> delegate;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *httpMethod;
/**
 * taobao application level parameters 
 */
@property (nonatomic, strong) NSMutableDictionary *params;
/**
 * do not use it unless the return value of startSynchronous method is unable to meet the demand 
 */
@property (nonatomic, strong) NSData *responseData;

@property (nonatomic, strong) NSString *signKey;

@property (nonatomic, strong) ASIFormDataRequest *asiRequest;

@property (nonatomic) BOOL enableLog;

@property (nonatomic) int type; //根据初始化的方法生成type
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, strong) NSString *paramsStr;

- (void)sign;

/**
 * type:0
 * Generate request without cache management.
 * If you wanna call startSynchronous, set delegate as nil;
 * If you wanna call startAsynchronous, set delegate as non-nil value;
 */
+ (BPURLRequest *)getRequestWithParams:(NSMutableDictionary *)params
                                httpMethod:(NSString *)httpMethod
                                  delegate:(id<BPURLRequestDelegate>)delegate
                                requestURL:(NSString *)url;

/**
 * type:1
 * 用于上传文件，请求方式为POST
 */
+ (BPURLRequest *)getPostFileRequestWithParams:(NSMutableDictionary *)params
                                      delegate:(id<BPURLRequestDelegate>)delegate
                                   contentType:(NSString *)contentType
                                    requestURL:(NSString *)url;

/**
 type:2
 请求方式为POST
 @param params 键值对组成的字符串，例如@"key1", @"value1"; @"key1", @"value2"; @"key2", @"value3"
 支持相同key存在
 */
+ (BPURLRequest *)getRequestWithKeyValue:(NSString *)params
                                delegate:(id<BPURLRequestDelegate>)delegate
                              requestURL:(NSString *)url;

- (id)startSynchronous;
- (id)startSynchronousForResponseData;

// 异步请求需要保证request对象在delegate回调之前不被释放
- (void)startAsynchronous;

- (BPURLRequest *)copyRequestWithAddParams:(NSMutableDictionary *)addParams;

@end

@protocol BPURLRequestDelegate <NSObject>

@optional

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 */
- (void)request:(BPURLRequest *)request didFinishLoad:(id)result;

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(BPURLRequest *)request didFailWithError:(NSError *)error;

@end
