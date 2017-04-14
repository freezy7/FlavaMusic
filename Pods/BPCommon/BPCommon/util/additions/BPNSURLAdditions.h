//
//  BPNSURLAdditions.h
//  BPCommon
//
//  Created by wangpeng on 15/4/1.
//
//

#import <Foundation/Foundation.h>

@interface NSURL (vge)

+ (NSURL *)safeFileURLWithPath:(NSString *)path;

@end
