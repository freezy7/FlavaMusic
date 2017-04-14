//
//  BPExecutorService.h
//  BPCommon
//
//  Created by Huang Tao on 7/11/13.
//
//

#import <Foundation/Foundation.h>

@interface BPExecutorService : NSObject {
    NSOperationQueue *_queue;
}

@property (nonatomic, assign) int maxConcurrentCount; // 默认为3

+ (void)addBlockOnMainThread:(void (^)(void))block;

+ (void)addBlockOnBackgroundThread:(void (^)(void))block;

+ (void)addFinishBlockOnCurrentThread:(void (^)(void))finishBlock testFinished:(BOOL (^)(void))testFinished;

+ (void)addFinishBlockOnBackgroundThread:(void (^)(void))finishBlock testFinished:(BOOL (^)(void))testFinished;

+ (BPExecutorService *)sharedInstance;

- (void)addOperationWithTarget:(id)target selector:(SEL)sel object:(id)arg;
#if NS_BLOCKS_AVAILABLE
- (void)addOperationWithBlock:(void (^)(void))block;
#endif

- (void)addOperation:(NSOperation *)op;

- (void)cancelAllOperations;

@end
