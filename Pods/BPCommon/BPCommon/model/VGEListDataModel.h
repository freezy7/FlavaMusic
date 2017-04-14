//
//  VGEListDataModel.h
//  VGEUI
//
//  Created by Hunter Huang on 8/14/11.
//  Copyright 2011 Hunter Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VGEDataModel.h"

@interface VGEListDataModel : VGEDataModel

@property (nonatomic, readonly) BOOL canLoadMore;
@property (nonatomic, readonly) NSInteger fetchLimit;
@property (nonatomic, readonly) NSInteger startIndex;
@property (nonatomic, readonly) BOOL isReload;

- (id)initWithFetchLimit:(NSInteger)limit delegate:(id<VGEDataModelDelegate>)delegate;
- (id)initWithFetchLimit:(NSInteger)limit;

- (NSInteger)itemCount;
- (id)itemAtIndex:(NSInteger)index;

// start index is reset as 0
- (void)reload;

/**
 数据加载之后对数据进行处理。默认不作处理，直接返回原数据
 @param rawData 所有的数据
 @return 返回处理之后的数据
 */
- (NSMutableArray *)filterData:(NSMutableArray *)rawData;

- (BOOL)testCanLoadMoreWithNewResult:(NSArray *)newResult;

- (BOOL)autoCheckCanLoadMore;

@end
