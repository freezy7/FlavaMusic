//
//  BPNSMutableDictionaryAdditions.m
//  BPCommon
//
//  Created by wangpeng on 4/2/13.
//
//

#import "BPNSMutableDictionaryAdditions.h"
#import "BPCoreUtil.h"

@implementation NSMutableDictionary (vge)

- (void)safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject&&aKey) {
        [self setObject:anObject forKey:aKey];
    }
}

@end


@implementation NSDictionary (vge)

- (id)stringForKey:(id)aKey
{
    return [BPCoreUtil convertToString:[self objectForKey:aKey]];
}

- (float)floatForKey:(id)aKey
{
    return [BPCoreUtil convertToFloat:[self objectForKey:aKey]];
}

- (double)doubleForKey:(id)aKey
{
    return [BPCoreUtil convertToDouble:[self objectForKey:aKey]];
}

- (int)intForKey:(id)aKey
{
    return [BPCoreUtil convertToInt:[self objectForKey:aKey]];
}

- (int)boolForKey:(id)aKey
{
    return [BPCoreUtil convertToBool:[self objectForKey:aKey]];
}

- (NSInteger)integerForKey:(id)aKey
{
    id source = [self objectForKey:aKey];
    if ([source isKindOfClass:[NSString class]]) {
        return [source integerValue];
    } else if ([source isKindOfClass:[NSNumber class]]) {
        return [source integerValue];
    } else {
        return 0;
    }
}

@end