//
//  BPSystemParams.h
//  BPCommon
//
//  Created by wangpeng on 4/19/13.
//
//

#import <Foundation/Foundation.h>

@interface BPSystemParams : NSObject

@property (nonatomic, strong) NSString *app;
@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *gdCityCode;

- (NSMutableDictionary *)defaultParams;
- (NSMutableDictionary *)addSystemParamsInto:(NSMutableDictionary *)params;

/**
 在指定url的后面添加系统参数，生成新的url
 */
- (NSString *)addSystemParamsIntoUrl:(NSString *)url;

/**
 判断是否越狱
 */
+ (BOOL)isJailbroken;

+ (BPSystemParams *)sharedInstance;

@end
