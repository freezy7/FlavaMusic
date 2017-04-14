//
//  BPExecutorService.m
//  BPCommon
//
//  Created by Huang Tao on 7/11/13.
//
//

#import "BPExecutorService.h"

@implementation BPExecutorService

- (id)init
{
    self = [super init];
    if (self) {
        _queue = [[NSOperationQueue alloc] init];
        [self setMaxConcurrentCount:3];
    }
    return self;
}

+ (void)addBlockOnMainThread:(void (^)(void))block
{
    dispatch_async(dispatch_get_main_queue(), ^{
        block();
    });
}

+ (void)addBlockOnBackgroundThread:(void (^)(void))block
{
    [self performSelectorInBackground:@selector(runBlockInBackground:) withObject:block];
}

+ (void)addFinishBlockOnCurrentThread:(void (^)(void))finishBlock testFinished:(BOOL (^)(void))testFinished
{
    NSAssert(![[NSThread currentThread] isEqual:[NSThread mainThread]], @"主线程调用此方法会卡UI");
    
    if (!testFinished) {
        if (finishBlock) {
            finishBlock();
        }
    } else {
        while (!testFinished()) {
            [NSThread sleepForTimeInterval:0.1f];
        }
        if (finishBlock) {
            finishBlock();
        }
    }
}

+ (void)addFinishBlockOnBackgroundThread:(void (^)(void))finishBlock testFinished:(BOOL (^)(void))testFinished
{
    if (!testFinished) {
        if (finishBlock) {
            finishBlock();
        }
    } else {
        [self addBlockOnBackgroundThread:^{
            while (!testFinished()) {
                [NSThread sleepForTimeInterval:0.1f];
            }
            if (finishBlock) {
                finishBlock();
            }
        }];
    }
}

+ (void)runBlockInBackground:(void (^)(void))block
{
    @autoreleasepool {
        block();
    }
}

+ (BPExecutorService *)sharedInstance
{
    static id instance = nil;
    @synchronized (self) {
        if (!instance) {
            instance = [[BPExecutorService alloc] init];
        }
    }
    return instance;
}

- (void)setMaxConcurrentCount:(int)maxConcurrentCount
{
    _maxConcurrentCount = maxConcurrentCount;
    
    _queue.maxConcurrentOperationCount = _maxConcurrentCount;
}

- (void)addOperation:(NSOperation *)op
{
    [_queue addOperation:op];
}

- (void)addOperationWithTarget:(id)target selector:(SEL)sel object:(id)arg
{
    NSInvocationOperation *io = [[NSInvocationOperation alloc] initWithTarget:target selector:sel object:arg];
    [_queue addOperation:io];
}

- (void)cancelAllOperations
{
    [_queue cancelAllOperations];
}

#if NS_BLOCKS_AVAILABLE
- (void)addOperationWithBlock:(void (^)(void))block
{
    [_queue addOperationWithBlock:block];
}
#endif

@end
