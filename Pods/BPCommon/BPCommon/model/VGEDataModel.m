//
//  VGEDataModel.m
//  VGEUI
//
//  Created by Hunter Huang on 8/14/11.
//  Copyright 2011 Hunter Huang. All rights reserved.
//

#import "VGEDataModel.h"
#import "VGEDataModel-Private.h"

@implementation VGEDataModel

- (void)dealloc
{
    self.data = nil;
}

- (id)initWithDelegate:(id<VGEDataModelDelegate>)delegate
{
    if (self = [super init]) {
        self.delegate = delegate;
        self.loadInBackground = YES;
        self.callDelegateOnMainThread = YES;
    }
    return self;
}

- (id)init
{
    return [self initWithDelegate:nil];
}

- (VGEDataResult *)loadData
{
    return nil;
}

- (id)parseData:(id)data
{
    return data;
}

- (id)defaultData
{
    return nil;
}

- (void)notifyDelegateWithMethod:(SEL)method
{
    if (_delegate&&[_delegate respondsToSelector:method]) {
        if (_callDelegateOnMainThread) {
            if ([NSThread isMainThread]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [_delegate performSelector:method withObject:self];
#pragma clang diagnostic pop
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [_delegate performSelector:method withObject:self];
#pragma clang diagnostic pop
                });
            }
            
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [_delegate performSelector:method withObject:self];
#pragma clang diagnostic pop
        }
    }
}

- (void)loadProcess
{
    @autoreleasepool {
        self.loading = YES;
        
        [self notifyDelegateWithMethod:@selector(dataModelWillStart:)];
        
        self.result = [self loadData];
        if (self.result.success) {
            self.data = [self parseData:self.result.data];
        }
        
        self.lastUpdatedTime = [NSDate date];
        
        [self notifyDelegateWithMethod:@selector(dataModelWillFinish:)];
        self.loading = NO;
        
        if (_result.success) {
            [self notifyDelegateWithMethod:@selector(dataModelDidSuccess:)];
        } else {
            [self notifyDelegateWithMethod:@selector(dataModelDidFail:)];
        }
        [self notifyDelegateWithMethod:@selector(dataModelDidFinish:)];
    }
}

- (void)startLoad
{
    if (!_loading) {
        if ([self.delegate respondsToSelector:@selector(dataModelPrepareStart:)]) {
            [self.delegate performSelector:@selector(dataModelPrepareStart:) withObject:self];
        }
        if (_loadInBackground) {
            [self performSelectorInBackground:@selector(loadProcess) withObject:nil];
        } else {
            [self loadProcess];
        }
    }
}

- (void)reload
{
    [self startLoad];
}

- (void)willFinishLoadOnMainThread
{
    
}

@end
