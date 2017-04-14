//
//  CLListDataModel.m
//  CLCommon
//
//  Created by wangpeng on 12/5/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import "CKListDataModel.h"
#import "BPCacheManager.h"

@implementation CKListDataModel

@dynamic cacheKey;
@dynamic cacheDuration;
@dynamic trait;

- (NSString *)cacheKey
{
    return nil;
}

- (NSString *)trait
{
    return nil;
}

- (NSInteger)cacheDuration
{
    return 0;
}

- (void)loadCache
{
    if (self.cacheKey) {
        CKDataResult *result = [[BPCacheManager sharedInstance] cacheForKey:self.cacheKey];
        if (result) {
            [self setValue:result forKey:@"_result"];
            [self setValue:[self filterData:[self parseData:result.data]] forKey:@"_data"];
        }
    }
}

- (void)clearCache
{
    if (self.cacheKey) {
        [[BPCacheManager sharedInstance] removeCache:self.cacheKey];
    }
}

- (CKDataResult *)cacheResult:(CKDataResult *)result
{
    if (self.cacheKey&&self.isReload) {
        if (result.success) {
            if (self.cacheDuration>0) {
                [[BPCacheManager sharedInstance] setCache:result forKey:self.cacheKey trait:self.trait duration:self.cacheDuration];
            } else {
                [[BPCacheManager sharedInstance] setCache:result forKey:self.cacheKey trait:self.trait];
            }
        } else if (result.code!=CKDataResultNotLogin) {
            if ([[BPCacheManager sharedInstance] containsCache:self.cacheKey]) {
                result = [[BPCacheManager sharedInstance] cacheForKey:self.cacheKey];
            }
        }
        return result;
    } else {
        return result;
    }
}

- (void)moveObjectfromIndex:(NSInteger)indexF to:(NSInteger)indexT
{
    if (self.data) {
        [self.data moveObjectsAtIndexes:[NSIndexSet indexSetWithIndex:indexF] toIndex:indexT];
    }
}

- (void)deleteObjectFromIndex:(NSInteger)index
{
    if (self.data) {
        if (index < [self.data count]) {
            [self.data removeObjectAtIndex:index];
        }
    }
}

@end
