//
//  VGEDataResult.m
//  BPCommon
//
//  Created by wangpeng on 8/23/13.
//
//

#import "VGEDataResult.h"

@implementation VGEDataResult

+ (VGEDataResult *)resultForUnknowError
{
    return [self resultWithFailMsg:@"未知错误"];
}

+ (VGEDataResult *)resultForNetworkError
{
    return [self resultWithFailMsg:@"网络不给力"];
}

+ (VGEDataResult *)resultForServerError
{
    return [self resultWithFailMsg:@"服务器打瞌睡了"];
}

+ (VGEDataResult *)resultWithSuccessData:(id)data
{
    VGEDataResult *item = [[self alloc] init];
    item.success = YES;
    item.data = data;
    return item;
}

+ (VGEDataResult *)resultWithFailMsg:(NSString *)msg
{
    VGEDataResult *item = [[self alloc] init];
    item.success = NO;
    item.msg = msg;
    return item;
}

@end
