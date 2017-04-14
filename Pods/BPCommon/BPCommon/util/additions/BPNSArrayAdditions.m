//
//  BPNSArrayAdditions.m
//  VGEUtil
//
//  Created by Hunter Huang on 11/27/11.
//  Copyright (c) 2011 vge design. All rights reserved.
//

#import "BPNSArrayAdditions.h"

@implementation NSMutableArray (vge)

- (void)safeAddObject:(id)anObject
{
    if (anObject) {
        [self addObject:anObject];
    }
}

- (id)safeObjectAtIndex:(NSUInteger)index
{
    if (index < [self count]) {
       return [self objectAtIndex:index];
    }
    return nil;
}

- (void)safeRemoveObjectAtIndex:(NSUInteger)index
{
    if (index < [self count]) {
        [self removeObjectAtIndex:index];
    }
}

@end

@implementation NSArray (vge)

- (NSString *)stringValueSeparatedByComma {
    NSMutableString *mStr = [NSMutableString string];
    for (int i=0; i<[self count]; i++) {
        NSString *str = [self objectAtIndex:i];
        if (i == 0) {
            [mStr appendString:str];
        } else {
            [mStr appendFormat:@",%@", str];
        }
    }
    return mStr;
}

- (id)safeObjectAtIndex:(NSUInteger)index
{
    if (index < [self count]) {
        return [self objectAtIndex:index];
    }
    return nil;
}

@end
