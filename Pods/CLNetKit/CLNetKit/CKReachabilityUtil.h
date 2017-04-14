//
//  CKReachabilityUtil.h
//  CLCommon
//
//  Created by wangpeng on 1/19/14.
//  Copyright (c) 2014 eclicks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface CKReachabilityUtil : NSObject

@property (nonatomic, strong, readonly) Reachability *reachability;
@property (nonatomic) BOOL isWifi;

+ (CKReachabilityUtil *)sharedInstance;

@end
