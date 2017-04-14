//
//  CKReachabilityUtil.m
//  CLCommon
//
//  Created by wangpeng on 1/19/14.
//  Copyright (c) 2014 eclicks. All rights reserved.
//

#import "CKReachabilityUtil.h"

@implementation CKReachabilityUtil

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    self = [super init];
    if (self) {
        _reachability = [Reachability reachabilityForInternetConnection];
        _isWifi = _reachability.isReachableViaWiFi;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_reachability startNotifier];
        });
    }
    return self;
}

- (void)reachabilityChanged:(NSNotification *)notification
{
    Reachability *info = notification.object;
    if (info.isReachableViaWiFi) {
        _isWifi = YES;
    } else {
        _isWifi = NO;
    }
}

+ (CKReachabilityUtil *)sharedInstance
{
    static id instance = nil;
    @synchronized (self) {
        if (instance==nil) {
            instance = [[CKReachabilityUtil alloc] init];
        }
    }
    return instance;
}

@end
