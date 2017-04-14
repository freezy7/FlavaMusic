//
//  BPNSMutableSetAdditions.m
//  BPCommon
//
//  Created by lizhengxing on 09/11/16.
//
//

#import "BPNSMutableSetAdditions.h"

@implementation NSMutableSet (vge)

- (void)safeAddObject:(id)anObject
{
    if (anObject) {
        [self addObject:anObject];
    }
}

@end
