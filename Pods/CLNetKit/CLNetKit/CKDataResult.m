//
//  CKDataResult.m
//  CLCommon
//
//  Created by wangpeng on 11/19/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import "CKDataResult.h"
#import "BPNSMutableDictionaryAdditions.h"

@implementation CKDataResult

+ (CKDataResult *)resultForNotLoginError
{
    CKDataResult *result = (CKDataResult *)[self resultWithFailMsg:@"请先登录一下吧"];
    result.code = CKDataResultNotLogin;
    return result;
}

+ (CKDataResult *)resultForUploadError
{
    return (CKDataResult *)[self resultWithFailMsg:@"上传出错了"];
}

+ (id)resultForServerError
{
    CKDataResult *result = [super resultForServerError];
    result.code = CKDataResultServerError;
    return result;
}

+ (id)resultForNetworkError
{
    CKDataResult *result = [super resultForNetworkError];
    result.code = CKDataResultNetworkError;
    return result;
}

+ (NSDictionary *)dictFromItem:(CKDataResult *)item
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict safeSetObject:[NSString stringWithFormat:@"%d", item.code] forKey:@"code"];
    [dict safeSetObject:item.msg forKey:@"msg"];
    [dict safeSetObject:item.data forKey:@"data"];
    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)itemFromDict:(NSDictionary *)dict
{
    if (dict==nil) return nil;
    
    return [[[self class] alloc] initWithDict:dict];
}

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.code = [dict intForKey:@"code"];
        self.success = self.code==1;
        self.msg = [dict stringForKey:@"msg"];
        self.data = [dict objectForKey:@"data"];
    }
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithDict:[aDecoder decodeObjectForKey:@"coder"]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[[self class] dictFromItem:self] forKey:@"coder"];
}

@end
