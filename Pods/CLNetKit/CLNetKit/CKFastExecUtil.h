//
//  CLFastExecUtil.h
//  CLCommon
//
//  Created by wangpeng on 14-8-18.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CKFastExecBlock)(void);

@interface CKFastExecUtil : NSObject

+ (void)syncExecBlockList:(NSArray *)blockList;

+ (void)slowSyncExecBlockList:(NSArray *)blockList;

@end
