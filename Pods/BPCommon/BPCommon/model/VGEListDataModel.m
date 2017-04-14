//
//  VGEListDataModel.m
//  VGEUI
//
//  Created by Hunter Huang on 8/14/11.
//  Copyright 2011 Hunter Huang. All rights reserved.
//

#import "VGEListDataModel.h"
#import "VGEDataModel-Private.h"

@interface VGEListDataModel()

@property (nonatomic, assign) BOOL canLoadMore;
@property (nonatomic, assign) NSInteger fetchLimit;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) BOOL isReload;

@end

@implementation VGEListDataModel

@synthesize canLoadMore, fetchLimit, startIndex, isReload;

- (id)initWithFetchLimit:(NSInteger)limit delegate:(id<VGEDataModelDelegate>)delegate
{
    if (self = [self initWithDelegate:delegate]) {
        self.fetchLimit = limit;
        self.startIndex = 0;
    }
    return self;
}

- (id)initWithFetchLimit:(NSInteger)limit
{
    if (self = [self initWithFetchLimit:limit delegate:nil]) {
        self.fetchLimit = limit;
        self.startIndex = 0;
    }
    return self;
}

- (BOOL)testCanLoadMoreWithNewResult:(NSArray *)newResult
{
    return [newResult count] >= fetchLimit;
}

- (void)loadProcess
{
    @autoreleasepool {
        self.result = [self loadData];
        
        if (self.result.success) {
            NSArray *result = [self parseData:self.result.data];
            if ([self autoCheckCanLoadMore]) {
                if (result && fetchLimit > 0 && [self testCanLoadMoreWithNewResult:result]) {
                    self.canLoadMore = YES;
                } else {
                    self.canLoadMore = NO;
                }
            }
            
            id data;
            
            if (isReload) {
                data = result;
            } else {
                NSMutableArray *mArray = [NSMutableArray arrayWithArray:self.data];
                [mArray addObjectsFromArray:result];
                data = mArray;
            }
            self.startIndex = [data count];
            
            // 对数据进行额外处理
            data = [self filterData:data];
            @synchronized (self.delegate) {
                self.data = data;
            }
            self.lastUpdatedTime = [NSDate date];
        } else {
            if (isReload) {
                id data = [self defaultData];
                @synchronized (self.delegate) {
                    self.data = data;
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self willFinishLoadOnMainThread];
            
            [self notifyDelegateWithMethod:@selector(dataModelWillFinish:)];
            self.loading = NO;
            
            if (self.result.success) {
                [self notifyDelegateWithMethod:@selector(dataModelDidSuccess:)];
            } else {
                [self notifyDelegateWithMethod:@selector(dataModelDidFail:)];
            }
            
            [self notifyDelegateWithMethod:@selector(dataModelDidFinish:)];
            
            self.isReload = NO;
        });
    }
}

- (void)startLoad
{
    if (!self.loading) {
        if ([self.delegate respondsToSelector:@selector(dataModelPrepareStart:)]) {
            [self.delegate performSelector:@selector(dataModelPrepareStart:) withObject:self];
        }
        self.loading = YES;
        [self notifyDelegateWithMethod:@selector(dataModelWillStart:)];
        if (self.loadInBackground) {
            [self performSelectorInBackground:@selector(loadProcess) withObject:nil];
        } else {
            [self loadProcess];
        }
    }
}

- (void)reload
{
    self.isReload = YES;
    self.startIndex = 0;
    [self startLoad];
}

- (NSInteger)itemCount
{
    if (self.data&&[self.data respondsToSelector:@selector(count)]) {
        return [self.data count];
    } else {
        return 0;
    }
}

- (id)itemAtIndex:(NSInteger)index
{
    if (self.data&&index>=0&&index<[self.data count]) {
        return [self.data objectAtIndex:index];
    } else {
        return nil;
    }
}

- (NSMutableArray *)filterData:(NSMutableArray *)rawData {
    return rawData;
}

- (BOOL)autoCheckCanLoadMore
{
    return YES;
}

@end
