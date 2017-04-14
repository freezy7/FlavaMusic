//
//  CKHttpPushRefreshLoadMoreTableController.h
//  CLCommon
//
//  Created by Huang Tao on 12/24/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import "CKHttpPushRefreshTableController.h"
#import "CKTableLoadMoreCell.h"

@interface CKHttpPushRefreshLoadMoreTableController : CKHttpPushRefreshTableController<CKTableLoadMoreCellDelegate>

@property (nonatomic, strong, readonly) CKTableLoadMoreCell *loadMoreCell;

- (CKTableLoadMoreCell *)createLoadMoreCell;

@end
