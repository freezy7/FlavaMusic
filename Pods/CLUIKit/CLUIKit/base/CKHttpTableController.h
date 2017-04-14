//
//  CKHttpTableController.h
//  CLCommon
//
//  Created by wangpeng on 11/11/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import "CKTableController.h"
#import "CKListDataModel.h"

@interface CKHttpTableController : CKTableController <VGEDataModelDelegate> {
    @protected
    BOOL _refreshOneTimeWhenAppear;
}

@property (nonatomic, strong, readonly) CKListDataModel *dataModel;
@property (nonatomic) BOOL disableNoDataView;
@property (nonatomic, readonly) BOOL refreshOneTimeWhenAppear;
@property (nonatomic, readonly) BOOL isDataModelLoadedFromNet;


- (CKListDataModel *)createDataModel;

- (void)refresh;
- (void)reloadData;
- (void)enableRefreshOneTimeWhenAppear;
- (BOOL)haveCacheOrData;
- (void)reloadWithNoDataView;
- (void)changeDataModel:(CKListDataModel *)model;

@end
