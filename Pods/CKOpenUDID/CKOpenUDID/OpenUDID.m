//
//  OpenUDID.m
//  KeychainDemo
//
//  Created by wangpeng on 16/1/20.
//  Copyright © 2016年 iimgal. All rights reserved.
//

#import "OpenUDID.h"
#import "CKUDIDManager.h"

@implementation OpenUDID

+ (NSString *)value
{
    return [CKUDIDManager getOpenUdid];
}

@end
