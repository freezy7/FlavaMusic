//
//  CKTableLoadMoreCell.h
//  CLCommon
//
//  Created by wangpeng on 12/7/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import "CKTableViewCell.h"

typedef enum {
    CKTableLoadMoreNormal,
    CKTableLoadMoreLoading,
    CKTableLoadMoreFailed
} CKTableLoadMoreState;

@class CKTableLoadMoreCell;

@protocol CKTableLoadMoreCellDelegate <NSObject>

- (void)loadMoreCellDidStartLoad:(CKTableLoadMoreCell *)cell;
- (BOOL)loadMoreCellIsLoading:(CKTableLoadMoreCell *)cell;

@end

@interface CKTableLoadMoreCell : CKTableViewCell

@property (nonatomic, weak) id<CKTableLoadMoreCellDelegate> delegate;
@property (nonatomic) CKTableLoadMoreState state;
@property (nonatomic) BOOL isTopLoad;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)startLoad;

@end
