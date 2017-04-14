//
//  CKListDataModel.h
//  CLCommon
//
//  Created by wangpeng on 12/5/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import "VGEListDataModel.h"
#import "CKDataResult.h"

@interface CKListDataModel : VGEListDataModel

@property (nonatomic, readonly) NSString *cacheKey;
@property (nonatomic, readonly) NSInteger cacheDuration;
@property (nonatomic, readonly) NSString *trait;

- (void)loadCache;
- (void)clearCache;
- (CKDataResult *)cacheResult:(CKDataResult *)result;

- (void)moveObjectfromIndex:(NSInteger)indexF to:(NSInteger)indexT;
- (void)deleteObjectFromIndex:(NSInteger)index;

@end
