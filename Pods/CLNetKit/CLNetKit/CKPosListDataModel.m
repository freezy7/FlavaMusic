//
//  CKPosListDataModel.m
//  CLCommon
//
//  Created by wangpeng on 12/25/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import "CKPosListDataModel.h"

@implementation CKPosListDataModel

- (void)reload
{
    _pos = nil;
    _more = nil;
    [super reload];
}

- (id)parseData:(id)data
{
    _pos = [data stringForKey:@"pos"];
    _more = [data stringForKey:@"more"];
    return data;
}

- (BOOL)testCanLoadMoreWithNewResult:(NSArray *)newResult
{
    if (_more) {
        return [_more intValue]>0;
    } else {
        return [super testCanLoadMoreWithNewResult:newResult];
    }
}

@end
