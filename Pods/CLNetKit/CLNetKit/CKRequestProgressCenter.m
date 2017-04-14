//
//  CKRequestProgressCenter.m
//  CLCommon
//
//  Created by wangpeng on 14/11/17.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import "CKRequestProgressCenter.h"

@implementation CKRequestProgressCenter

+ (CKRequestProgressCenter *)sharedInstance
{
    static id instance = nil;
    @synchronized(self) {
        if (instance==nil) {
            instance = [[CKRequestProgressCenter alloc] init];
        }
    }
    return instance;
}

- (void)attachRequest:(ASIHTTPRequest *)request forUpload:(BOOL)upload fileUrl:(NSString *)fileUrl
{
    if (fileUrl==nil) return;
    
    if (upload) {
        request.uploadProgressDelegate = request;
    } else {
        request.downloadProgressDelegate = request;
    }
}

- (void)updateDownloadProgress:(float)progress forTagStr:(NSString *)tagStr
{
    [[NSNotificationCenter defaultCenter] postNotificationName:APP_EVENT_CHELUN_NETPROGRESS_DOWNLOAD_DID_UPDATE object:tagStr userInfo:@{@"progress":@(progress)}];
}

#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
}

- (void)request:(ASIHTTPRequest *)request didUpdateUploadProgress:(float)progress
{
    
}

- (void)request:(ASIHTTPRequest *)request didUpdateDownloadProgress:(float)progress
{
    
}

@end

@interface ASIHTTPRequest (CLUploadPorcessCenter) <ASIProgressDelegate>

@end

@implementation ASIHTTPRequest (CLUploadPorcessCenter)

- (void)setProgress:(float)newProgress
{
    if (self.uploadProgressDelegate==self) {
        if ([self.delegate respondsToSelector:@selector(request:didUpdateUploadProgress:)]) {
            [self.delegate request:self didUpdateUploadProgress:newProgress];
        }
    } else if (self.downloadProgressDelegate==self) {
        if ([self.delegate respondsToSelector:@selector(request:didUpdateDownloadProgress:)]) {
            [self.delegate request:self didUpdateDownloadProgress:newProgress];
        }
    }
}

@end
