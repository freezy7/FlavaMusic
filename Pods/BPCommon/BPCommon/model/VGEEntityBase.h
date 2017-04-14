//
//  VGEEntityBase.h
//  TaobaoSeller
//
//  Created by Hunter Huang on 6/8/12.
//  Copyright (c) 2012 vge design. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VGEEntityBase : NSObject

+ (id)itemFromDict:(NSDictionary *)dict; // to be implemented by subclass
+ (NSArray *)itemsFromArray:(NSArray *)array;

+ (NSDictionary *)dictFromItem:(id)item; // to be implemented by subclass
+ (NSArray *)arrayFromItems:(NSArray *)array;


@end
