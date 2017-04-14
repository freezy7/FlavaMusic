//
//  BPNetLogManager.h
//  BPCommon
//
//  Created by wangpeng on 15/7/6.
//
//

#import <Foundation/Foundation.h>

@class BPNetLogItem;

@interface BPNetLogManager : NSObject

@property (nonatomic) BOOL enable;
@property (nonatomic) BOOL isProduction;//是否为生产环境，默认为否
@property (nonatomic, strong) NSDictionary *otherParams;

+ (BPNetLogManager *)sharedInstance;
- (void)startWithIsProduction:(BOOL)isProduction;
- (void)addLogItem:(BPNetLogItem *)item;

@end

@interface BPNetLogItem : NSObject

@property (nonatomic) CGFloat requestTime;
@property (nonatomic) NSTimeInterval startTimestamp;
@property (nonatomic, strong) NSString *netType;
@property (nonatomic, strong) NSString *netSubType;
@property (nonatomic) CGFloat headerTime;
@property (nonatomic) CGFloat time;
@property (nonatomic, strong) NSString *url;
@property (nonatomic) int code;
@property (nonatomic) unsigned long long bodyLength;
@property (nonatomic) BOOL jsonParse;
@property (nonatomic) int dataCode;
@property (nonatomic) unsigned long long postLength;
@property (nonatomic, strong) NSString *method;

- (void)startLog;
- (void)receiveHeader;
- (void)endLog;

- (NSDictionary *)dict;

@end