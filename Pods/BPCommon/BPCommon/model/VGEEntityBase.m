//
//  VGEEntityBase.m
//  TaobaoSeller
//
//  Created by Hunter Huang on 6/8/12.
//  Copyright (c) 2012 vge design. All rights reserved.
//

#import "VGEEntityBase.h"

@implementation VGEEntityBase

+ (id)itemFromDict:(NSDictionary *)dict {
    // to be implemented by subclass
    return nil;
}

+ (NSArray *)itemsFromArray:(NSArray *)array {
    if (array == nil) return nil;
    
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

+ (NSDictionary *)dictFromItem:(id)item {
    // to be implemented by subclass
    return nil;
}

+ (NSArray *)arrayFromItems:(NSArray *)array {
    if (array == nil) return nil;
    
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:[array count]];
    for (id item in array) {
        NSDictionary *dict = [self dictFromItem:item];
        if (dict)
            [mArray addObject:dict];
    }
    return mArray;
}

@end
