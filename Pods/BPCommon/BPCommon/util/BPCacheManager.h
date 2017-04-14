//
//  BPCacheManager.h
//  BPCommon
//
//  Created by wangpeng on 11/27/13.
//
//

#import <Foundation/Foundation.h>

@interface BPCacheManager : NSObject

+ (BPCacheManager *)sharedInstance;

//清除过期缓存
- (void)clearExpiryCache;
- (void)clearCache;

//是否存在缓存
- (BOOL)containsCache:(NSString *)key;

//取得缓存内容
- (id)cacheForKey:(NSString *)key;
- (id)cacheForKey:(NSString *)key expiryDate:(NSDate **)expiryDate;

//根据trait取得缓存列表
- (NSArray *)cacheListForTrait:(NSString *)trait;

//根据trait取得key列表
- (NSArray *)keysListForTrait:(NSString *)trait;

//根据key删除缓存
- (void)removeCache:(NSString *)key;

//根据trait删除缓存
- (void)removeCacheWithTrait:(NSString *)trait;

//增加缓存
- (void)setCache:(id<NSCoding>)cache forKey:(NSString *)key;
- (void)setCache:(id<NSCoding>)cache forKey:(NSString *)key trait:(NSString *)trait;
- (void)setCache:(id<NSCoding>)cache forKey:(NSString *)key duration:(NSInteger)duration;
- (void)setCache:(id<NSCoding>)cache forKey:(NSString *)key trait:(NSString *)trait duration:(NSInteger)duration;

- (void)setCacheList:(NSArray *)cacheList forKeyList:(NSArray *)keyList trait:(NSString *)trait duration:(NSInteger)duration;

- (NSInteger)getSize;

@end
