//
//  CLHttpPushRefreshLoadMoreTableController.m
//  CLCommon
//
//  Created by Huang Tao on 12/24/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import "CKHttpPushRefreshLoadMoreTableController.h"

@interface CKHttpPushRefreshLoadMoreTableController ()

@end

@implementation CKHttpPushRefreshLoadMoreTableController

- (void)dealloc
{
    _loadMoreCell.delegate = nil;
    _loadMoreCell = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _loadMoreCell = [self createLoadMoreCell];
    _loadMoreCell.delegate = self;
}

- (CKTableLoadMoreCell *)createLoadMoreCell
{
    return nil;
}

#pragma mark - VGEDataModelDelegate

- (void)dataModelDidFail:(VGEDataModel *)model
{
    [super dataModelDidFail:model];
    
    [_loadMoreCell setState:CKTableLoadMoreFailed];
}

- (void)dataModelDidFinish:(VGEDataModel *)model
{
    [super dataModelDidFinish:model];
    
    [_loadMoreCell setState:CKTableLoadMoreNormal];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[super scrollViewDidScroll:scrollView];
    
    [_loadMoreCell scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_loadMoreCell scrollViewDidEndDragging:scrollView];
}

#pragma mark - CLTableLoadMoreCellDelegate

- (void)loadMoreCellDidStartLoad:(CKTableLoadMoreCell *)cell
{
    if (![self.dataModel loading]&&[self.dataModel canLoadMore]) {
        [self.dataModel startLoad];
    } else if (_loadMoreCell.state==CKTableLoadMoreLoading) {
        _loadMoreCell.state = CKTableLoadMoreNormal;
    }
}

- (BOOL)loadMoreCellIsLoading:(CKTableLoadMoreCell *)cell
{
    return [self.dataModel loading];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView cellForRowAtIndexPath:indexPath]==_loadMoreCell) {
        if (_loadMoreCell.state==CKTableLoadMoreFailed) {
            [_loadMoreCell startLoad];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
