//
//  CKUIManager.m
//  CLUIKit
//
//  Created by wangpeng on 16/1/6.
//  Copyright © 2016年 wangpeng. All rights reserved.
//

#import "CKUIManager.h"

static id ckUIManager = nil;

@implementation CKUIManager

+ (void)setup:(id<CKUIManagerDelegate>)manager
{
    ckUIManager = manager;
}

+ (id<CKUIManagerDelegate>)sharedManager
{
    NSAssert(ckUIManager!=nil, @"使用CKUIKit需要在此设置Manager");
    return ckUIManager;
}

@end
