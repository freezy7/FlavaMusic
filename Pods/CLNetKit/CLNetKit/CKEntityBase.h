//
//  CKEntityBase.h
//  CLNetKit
//
//  Created by wangpeng on 16/1/7.
//  Copyright © 2016年 wangpeng. All rights reserved.
//

#import "VGEEntityBase.h"
#import "FMResultSet.h"
#import "BPNSMutableDictionaryAdditions.h"

@interface CKEntityBase : VGEEntityBase <NSCoding>

@property (nonatomic, strong) NSString *aaa;

+ (id)itemFromResultSet:(FMResultSet *)rs; // 抽象方法
+ (NSMutableArray *)itemsFromResultSet:(FMResultSet *)rs;

- (id)initWithDict:(NSDictionary *)dict;

@end
