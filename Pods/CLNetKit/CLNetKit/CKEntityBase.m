//
//  CKEntityBase.m
//  CLNetKit
//
//  Created by wangpeng on 16/1/7.
//  Copyright © 2016年 wangpeng. All rights reserved.
//

#import "CKEntityBase.h"

@implementation CKEntityBase

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (id)itemFromResultSet:(FMResultSet *)rs
{
    return nil;
}

+ (NSMutableArray *)itemsFromResultSet:(FMResultSet *)rs
{
    NSMutableArray *accs = [NSMutableArray array];
    while ([rs next]) {
        id item = [self itemFromResultSet:rs];
        if (item) {
            [accs addObject:item];
        }
    }
    return accs;
}

+ (id)itemFromDict:(NSDictionary *)dict
{
    if (dict==nil) return nil;
    
    if (dict&&![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    return [[[self class] alloc] initWithDict:dict];
}

+ (NSArray *)itemsFromArray:(NSArray *)array {
    if (array == nil) return nil;
    
    if (array&&![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:[array count]];
    for (NSDictionary *dict in array) {
        if ((id)dict == [NSNull null]) {
            continue;
        }
        id item = [self itemFromDict:dict];
        if (item)
            [mArray addObject:item];
    }
    return mArray;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithDict:[aDecoder decodeObjectForKey:@"coder"]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[[self class] dictFromItem:self] forKey:@"coder"];
}

- (void)setNilValueForKey:(NSString *)key
{
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (nullable id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

@end
