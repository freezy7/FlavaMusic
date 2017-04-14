//
//  BPURLRequest.m
//  YHHB
//
//  Created by Hunter Huang on 11/23/11.
//  Copyright (c) 2011 vge design. All rights reserved.
//

#import "BPURLRequest.h"
#import "BPNSStringAdditions.h"
#import "JSONKit.h"
#import "BPLogger.h"
#import "Reachability.h"
#import <CommonCrypto/CommonDigest.h>
#import "BPNetLogManager.h"
#import "BPReplaceHttp.h"

NSString *const APP_EVENT_NETWORK_ERROR = @"app.event.network.error";

@interface BPURLRequest() <ASIHTTPRequestDelegate, ASIProgressDelegate> {
    double progress;
    BPNetLogItem *_logItem;
}

@end

@implementation BPURLRequest

@synthesize delegate, url, httpMethod, params, responseData, asiRequest;

+ (BPURLRequest *)getRequestWithParams:(NSMutableDictionary *)params 
                                httpMethod:(NSString *)httpMethod 
                                  delegate:(id<BPURLRequestDelegate>)delegate 
                                requestURL:(NSString *)url {
    BPURLRequest *request = [[self alloc] init];
    request.delegate = delegate;
    request.httpMethod = httpMethod;
    request.params = params;
    request.url = url;
    request.responseData = nil;
    request.type = 0;
    
    ASIFormDataRequest *asiRequest;
    if (httpMethod && [httpMethod isEqualToString:@"POST"]) {
        asiRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        for (NSString *key in params.allKeys) {
            if ([[params objectForKey:key] isKindOfClass:[NSData class]]) {
                [asiRequest setData:[params objectForKey:key] forKey:key];
            } else {
                [asiRequest setPostValue:[params objectForKey:key] forKey:key];
            }
        }
    } else {
        asiRequest = [ASIHTTPRequest requestWithURL:[url serializeURLWithParams:params httpMethod:httpMethod]];
    }
    if (delegate) {
        asiRequest.delegate = request;
    }
    request.asiRequest = asiRequest;
    return request;
}

+ (BPURLRequest *)getRequestWithKeyValue:(NSString *)params delegate:(id<BPURLRequestDelegate>)delegate requestURL:(NSString *)url {
    BPURLRequest *request = [[self alloc] init];
    request.delegate = delegate;
    request.httpMethod = @"POST";
    request.params = nil;
    request.url = url;
    request.responseData = nil;
    request.paramsStr = params;
    request.type = 2;
    
    ASIFormDataRequest *asiRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    NSArray *tokens = [params componentsSeparatedByString:@";"];
    for (NSString *keyValue in tokens) {
        NSArray *kvTokens = [keyValue componentsSeparatedByString:@","];
        if (kvTokens && kvTokens.count>1) {
            [asiRequest addPostValue:[kvTokens objectAtIndex:1] forKey:[kvTokens objectAtIndex:0]];
        }
    }
    BPLog(@"request url:%@", url);
    
    if (delegate) {
        asiRequest.delegate = request;
    }
    request.asiRequest = asiRequest;
    return request;
}

+ (BPURLRequest *)getPostFileRequestWithParams:(NSMutableDictionary *)params
                                      delegate:(id<BPURLRequestDelegate>)delegate
                                   contentType:(NSString *)contentType
                                    requestURL:(NSString *)url {
    BPURLRequest *request = [[self alloc] init];
    request.delegate = delegate;
    request.httpMethod = @"POST";
    request.params = params;
    request.url = url;
    request.responseData = nil;
    request.contentType = contentType;
    request.type = 1;
    
    ASIFormDataRequest *asiRequest;
    asiRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    asiRequest.timeOutSeconds = 2*60; // 文件上传timeout时间加长
    asiRequest.uploadProgressDelegate = self;
    for (NSString *key in params.allKeys) {
        id value = [params objectForKey:key];
        if ([value isKindOfClass:[NSData class]]) {
            [asiRequest addData:value withFileName:key andContentType:contentType forKey:key];
        } else {
            [asiRequest setPostValue:value forKey:key];
        }
    }
    BPLog(@"request url:%@", url);
    if (delegate) {
        asiRequest.delegate = request;
    }
    request.asiRequest = asiRequest;
    return request;
}

- (BPURLRequest *)copyRequestWithAddParams:(NSMutableDictionary *)addParams
{
    BPURLRequest *request;
    if (self.type==1) {
        NSMutableDictionary *dict = [self.params mutableCopy];
        if (addParams && [addParams isKindOfClass:[NSDictionary class]]) {
            [dict addEntriesFromDictionary:addParams];
        }
        request = [self.class getPostFileRequestWithParams:dict delegate:self.delegate contentType:self.contentType requestURL:self.url];
    } else if (self.type==2) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSArray *tokens = [self.paramsStr componentsSeparatedByString:@";"];
        for (NSString *keyValue in tokens) {
            NSArray *kvTokens = [keyValue componentsSeparatedByString:@","];
            [dict setObject:kvTokens[1] forKey:kvTokens[0]];
        }
        if (addParams && [addParams isKindOfClass:[NSDictionary class]]) {
            [dict addEntriesFromDictionary:addParams];
        }
        NSMutableString *str = [NSMutableString string];
        for (NSString *key in dict) {
            if (str.length>0) {
                [str appendString:@";"];
            }
            [str appendFormat:@"%@,%@", key, dict[key]];
        }
        request = [self.class getRequestWithKeyValue:str delegate:self.delegate requestURL:self.url];
    } else {
        NSMutableDictionary *dict = [self.params mutableCopy];
        if (addParams && [addParams isKindOfClass:[NSDictionary class]]) {
            [dict addEntriesFromDictionary:addParams];
        }
        request = [self.class getRequestWithParams:dict httpMethod:self.httpMethod delegate:self.delegate requestURL:self.url];
    }
    request.signKey = self.signKey;
    return request;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.enableLog = [BPNetLogManager sharedInstance].enable;
    }
    return self;
}

- (void)setEnableLog:(BOOL)enableLog
{
    _enableLog = enableLog;
    if (_enableLog) {
        _logItem = [[BPNetLogItem alloc] init];
    } else {
        _logItem = nil;
    }
}

- (NSData *)responseData
{
    return asiRequest.responseData;
}

- (id)parseResponse:(NSString *)str
{
    id result = [str objectFromJSONString];
    if ([result isKindOfClass:[NSDictionary class]]) {
        result = [BPReplaceHttp filterNSNullFromDictionary:result needReplaceHttp:NO];
    }
    return result;
}

- (void)sign
{
    NSString *link = [asiRequest.url description];
    NSRange range = [link rangeOfString:@"?"];
    if (range.length>0||[[httpMethod uppercaseString] isEqualToString:@"POST"]) {
        NSString *par = nil;
        if (range.length==0) {
            link = [link stringByAppendingString:@"?"];
            par = @"";
        } else {
            par = [link substringFromIndex:range.location+1];
        }
        
        NSString *getSign = [[[[par stringByAppendingString:@"&"] md5Hash] stringByAppendingString:_signKey] md5Hash];
        if ([[httpMethod uppercaseString] isEqualToString:@"POST"]) {
            unsigned char result[CC_MD5_DIGEST_LENGTH];
            [asiRequest buildPostBody];
            CC_MD5([asiRequest.postBody bytes], (CC_LONG)[asiRequest.postBody length], result);
            NSString *bodyMD5 = [NSString stringWithFormat:
             @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
             result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
             ];
            NSString *sign = [[getSign stringByAppendingString:[[bodyMD5 stringByAppendingString:_signKey] md5Hash]] md5Hash];
            asiRequest.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@&sign=%@", link, sign]];
        } else {
            asiRequest.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@&sign=%@", link, getSign]];
        }
    }
}

- (void)startLog
{
    if (!_logItem) {
        return;
    }
    
    __strong BPNetLogItem *logItem = _logItem;
    __strong ASIHTTPRequest *request = asiRequest;
    
    logItem.url = request.url.absoluteString;
    [logItem startLog];
    
    [asiRequest setHeadersReceivedOnBackgroundThreadBlock:^(NSDictionary *responseHeaders) {
        [logItem setMethod:request.requestMethod];
        [logItem setPostLength:request.postLength];
        [logItem receiveHeader];
    }];
}

- (void)endLogWithResult:(id)result hasParse:(BOOL)hasParse
{
    BPNetLogItem *logItem = _logItem;
    ASIHTTPRequest *request = asiRequest;
    if ([[request.responseHeaders objectForKey:@"X-Server"] rangeOfString:@"chelun"].length==0) {
        return;
    }
    logItem.bodyLength = request.postBody.length;
    logItem.code = request.responseStatusCode;
    if (!hasParse) {
        result = [self parseResponse:asiRequest.responseString];
    }
    if (result) {
        logItem.jsonParse = YES;
        if ([result isKindOfClass:[NSDictionary class]]) {
            id codeNum = [result objectForKey:@"code"];
            if ([codeNum isKindOfClass:[NSNumber class]]||[codeNum isKindOfClass:[NSString class]]) {
                _logItem.dataCode = [codeNum intValue];
            }
        }
    }
    [logItem endLog];
}

- (id)startSynchronous {
    if (![[Reachability reachabilityForInternetConnection] isReachable]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:APP_EVENT_NETWORK_ERROR object:nil];
        return nil;
    }
    if (_signKey) {
        [self sign];
    }
    [self startLog];
    [asiRequest startSynchronous];
    BPLog(@"request url:\n%@", asiRequest.url);
    BPLog(@"response \n status code:%d, msg:%@, error:%@", asiRequest.responseStatusCode, asiRequest.responseStatusMessage, asiRequest.error);
    BPLog(@"response:\n%@", asiRequest.responseString);
    // parse the response
    id result = [self parseResponse:asiRequest.responseString];
    [self endLogWithResult:result hasParse:YES];
    return result;
}

- (id)startSynchronousForResponseData
{
    if (![[Reachability reachabilityForInternetConnection] isReachable]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:APP_EVENT_NETWORK_ERROR object:nil];
        return nil;
    }
    if (_signKey) {
        [self sign];
    }
    [self startLog];
    [asiRequest startSynchronous];
    BPLog(@"response status code:%d, msg:%@, error:%@", asiRequest.responseStatusCode, asiRequest.responseStatusMessage, asiRequest.error);
    [self endLogWithResult:nil hasParse:NO];
    return asiRequest.responseData;
}

- (void)startAsynchronous {
    if (![[Reachability reachabilityForInternetConnection] isReachable]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:APP_EVENT_NETWORK_ERROR object:nil];
        return;
    }
    if (_signKey) {
        [self sign];
    }
    [asiRequest setCompletionBlock:^{
        
    }];
    [self startLog];
    [asiRequest startAsynchronous];
    __strong BPURLRequest *request = self;
    [asiRequest setCompletionBlock:^{
        [request endLogWithResult:nil hasParse:NO];
    }];
}

#pragma mark ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request {
    BPLog(@"asi request finished, %@", asiRequest.url);
    if (delegate && [delegate respondsToSelector:@selector(request:didFinishLoad:)]) {
        [delegate request:self didFinishLoad:[self parseResponse:asiRequest.responseString]];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    BPLog(@"asi request failed, %@", asiRequest.error);
    if (delegate && [delegate respondsToSelector:@selector(request:didFailWithError:)]) {
        [delegate request:self didFailWithError:asiRequest.error];
    }
}

#pragma mark - ASIProgressDelegate

- (void)request:(ASIHTTPRequest *)request incrementUploadSizeBy:(long long)newLength {
    progress += request.totalBytesSent/request.postLength;
    BPLog(@"upload progress:%f, this bytes:%lld", progress, newLength);
}

@end
