//
//  CKDataResult.h
//  CLCommon
//
//  Created by wangpeng on 11/19/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import "VGEDataResult.h"

enum CKDataResultStatus {
    CKDataResultNetworkError = -2,
    CKDataResultServerError = -1,
    CKDataResultNotLogin = 3
    };

@interface CKDataResult : VGEDataResult <NSCoding>{
    
}

@property (nonatomic, assign) int code;

- (id)initWithDict:(NSDictionary *)dict;

+ (CKDataResult *)resultForNotLoginError;
+ (CKDataResult *)resultForUploadError;

@end
