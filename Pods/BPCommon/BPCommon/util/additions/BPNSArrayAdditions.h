//
//  BPNSArrayAdditions.h
//  VGEUtil
//
//  Created by Hunter Huang on 11/27/11.
//  Copyright (c) 2011 vge design. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (vge)

- (void)safeAddObject:(id)anObject;

- (id)safeObjectAtIndex:(NSUInteger)index;

- (void)safeRemoveObjectAtIndex:(NSUInteger)index;

@end

@interface NSArray (vge)

- (NSString *)stringValueSeparatedByComma;

- (id)safeObjectAtIndex:(NSUInteger)index;

@end
