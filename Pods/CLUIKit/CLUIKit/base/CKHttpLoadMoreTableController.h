//
//  CKHttpLoadMoreTableController.h
//  CLCommon
//
//  Created by Huang Tao on 12/24/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import "CKHttpTableController.h"
#import "CKTableLoadMoreCell.h"

@interface CKHttpLoadMoreTableController : CKHttpTableController<CKTableLoadMoreCellDelegate>

@property (nonatomic, strong, readonly) CKTableLoadMoreCell *loadMoreCell;

- (CKTableLoadMoreCell *)createLoadMoreCell;

@end
