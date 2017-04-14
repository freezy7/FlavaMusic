//
//  BPNSMutableDictionaryAdditions.h
//  BPCommon
//
//  Created by wangpeng on 4/2/13.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (vge)

- (void)safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey;

@end

@interface NSDictionary (vge)

- (id)stringForKey:(id)aKey;
- (float)floatForKey:(id)aKey;
- (double)doubleForKey:(id)aKey;
- (int)intForKey:(id)aKey;
- (NSInteger)integerForKey:(id)aKey;
- (int)boolForKey:(id)aKey;

@end