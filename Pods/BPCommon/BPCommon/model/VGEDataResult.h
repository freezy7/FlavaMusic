//
//  VGEDataResult.h
//  BPCommon
//
//  Created by wangpeng on 8/23/13.
//
//

#import <Foundation/Foundation.h>
#import "VGEEntityBase.h"

@interface VGEDataResult : VGEEntityBase

@property (nonatomic) BOOL success;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) id data;

+ (id)resultForUnknowError;
+ (id)resultForNetworkError;
+ (id)resultForServerError;

+ (VGEDataResult *)resultWithSuccessData:(id)data;
+ (VGEDataResult *)resultWithFailMsg:(NSString *)msg;


@end
