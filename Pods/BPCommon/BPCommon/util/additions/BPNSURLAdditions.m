//
//  BPNSURLAdditions.m
//  BPCommon
//
//  Created by wangpeng on 15/4/1.
//
//

#import "BPNSURLAdditions.h"

@implementation NSURL (vge)

+ (NSURL *)safeFileURLWithPath:(NSString *)path
{
    if (path) {
        return [self fileURLWithPath:path];
    } else {
        return nil;
    }
}

@end
