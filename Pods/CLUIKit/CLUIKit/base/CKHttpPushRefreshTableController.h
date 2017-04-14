//
//  CLHttpPushRefreshTableController.h
//  CLCommon
//
//  Created by wangpeng on 12/6/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import "CKHttpTableController.h"
#import "CKPullRefreshHeaderView.h"
 
@interface CKHttpPushRefreshTableController : CKHttpTableController<CKPullRefreshHeaderViewDelegate> {
    @protected
    CKPullRefreshHeaderView *_refreshHeaderView;
}

- (void)didPullRefresh;

@end
