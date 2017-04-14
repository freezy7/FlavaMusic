//
//  BPReplaceHttp.h
//  BPCommon
//
//  Created by wangpeng on 4/19/13.
//
//

#import <Foundation/Foundation.h>

@interface BPReplaceHttp : NSObject

+ (BPReplaceHttp *)sharedInstance;

#pragma mark - 过滤NSNULL 替换http://为https://
+ (id)replaceHttpToHttps:(id)value needReplaceHttp:(BOOL)needReplaceHttp;
+ (NSMutableArray *)filterNSNullFromArray:(NSArray *)array needReplaceHttp:(BOOL)needReplaceHttp;
+ (NSMutableDictionary *)filterNSNullFromDictionary:(NSDictionary *)dict needReplaceHttp:(BOOL)needReplaceHttp;


@end
