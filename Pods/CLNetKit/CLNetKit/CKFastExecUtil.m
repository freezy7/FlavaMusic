//
//  CLFastExecUtil.m
//  CLCommon
//
//  Created by wangpeng on 14-8-18.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import "CKFastExecUtil.h"
#import "BPExecutorService.h"
#import "BPNSArrayAdditions.h"

@implementation CKFastExecUtil

+ (void)syncExecBlockList:(NSArray *)blockList
{
    //double time = [[NSDate date] timeIntervalSince1970];
    BOOL success[blockList.count];
    
    for (int i=0; i<blockList.count; i++) {
        [self checkExecBlock:blockList[i] success:&success[i]];
    }
    
    BOOL allSuccess = NO;
    while (!allSuccess) {
        BOOL result = YES;
        for (int i=0; i<blockList.count; i++) {
            if (success[i]==NO) {
                result = NO;
                break;
            }
        }
        allSuccess = result;
        [NSThread sleepForTimeInterval:0.1f];
    }
    
    //NSLog(@"\n----------------------------------\n%.3f\n----------------------------------", [[NSDate date] timeIntervalSince1970] - time);
}

+ (void)checkExecBlock:(void (^)(void))block success:(BOOL *)success
{
    if (block) {
        *success = NO;
        [BPExecutorService addBlockOnBackgroundThread:^{
            block();
            *success = YES;
        }];
    } else {
        *success = YES;
    }
}

+ (void)slowSyncExecBlockList:(NSArray *)blockList
{
    //double time = [[NSDate date] timeIntervalSince1970];
    for (int i=0; i<blockList.count; i++) {
        CKFastExecBlock block = [blockList safeObjectAtIndex:i];
        block();
    }
    //NSLog(@"\n----------------------------------\n%.3f\n----------------------------------", [[NSDate date] timeIntervalSince1970] - time);
}

@end
