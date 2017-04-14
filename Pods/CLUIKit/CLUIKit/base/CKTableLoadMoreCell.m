//
//  CKTableLoadMoreCell.m
//  CLCommon
//
//  Created by wangpeng on 12/7/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import "CKTableLoadMoreCell.h"
#import "BPUIViewAdditions.h"

@implementation CKTableLoadMoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellBaseStyle = CKTableViewCellStyleBottom;
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_isTopLoad) {
        if (scrollView.contentOffset.y-scrollView.contentInset.top<=0.f) {
            if (self.state==CKTableLoadMoreNormal) {
                self.state = CKTableLoadMoreLoading;
            }
        }
    } else {
        if (scrollView.contentOffset.y-scrollView.contentInset.bottom>=scrollView.contentSize.height-scrollView.height) {
            if (self.state==CKTableLoadMoreNormal) {
                self.state = CKTableLoadMoreLoading;
            }
        }
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
{
    if (_isTopLoad) {
        if (scrollView.contentOffset.y-scrollView.contentInset.top<=0.f) {
            if (self.state==CKTableLoadMoreNormal) {
                self.state = CKTableLoadMoreLoading;
            }
        }
    } else {
        if (scrollView.contentOffset.y-scrollView.contentInset.bottom>=scrollView.contentSize.height-scrollView.height) {
            if (self.state==CKTableLoadMoreNormal) {
                self.state = CKTableLoadMoreLoading;
            }
        }
    }
    
    if (self.state==CKTableLoadMoreLoading&&![_delegate loadMoreCellIsLoading:self]) {
        [_delegate loadMoreCellDidStartLoad:self];
    }
}

- (void)startLoad
{
    self.state = CKTableLoadMoreLoading;
    [_delegate loadMoreCellDidStartLoad:self];
}

@end
