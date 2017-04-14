//
//  CKRequestProgressCenter.h
//  CLCommon
//
//  Created by wangpeng on 14/11/17.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHttpRequest.h"

#define APP_EVENT_CHELUN_NETPROGRESS_DOWNLOAD_DID_UPDATE    @"app.event.chelun.netprogress.download.did.update"

@interface CKRequestProgressCenter : NSObject <ASIHTTPRequestDelegate>

- (void)attachRequest:(ASIHTTPRequest *)request forUpload:(BOOL)upload fileUrl:(NSString *)fileUrl;
- (void)updateDownloadProgress:(float)progress forTagStr:(NSString *)tagStr;

+ (CKRequestProgressCenter *)sharedInstance;

@end
