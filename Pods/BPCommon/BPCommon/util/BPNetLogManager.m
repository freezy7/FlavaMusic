//
//  BPNetLogManager.m
//  BPCommon
//
//  Created by wangpeng on 15/7/6.
//
//

#import "BPNetLogManager.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"
#import "BPExecutorService.h"
#import "Reachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "BPNSMutableDictionaryAdditions.h"
#import "JSONKit.h"
#import "BPFileUtil.h"
#import "BPURLRequest.h"
#import "BPSystemParams.h"
#import "BPNSStringAdditions.h"
#import "BPNSDataAdditions.h"
#import "BPNSArrayAdditions.h"

#define APP_CONST_NET_LOG_TEST_SERVER_URL               @"https://app-dev.eclicks.cn:8501/app/stats/"
#define APP_CONST_NET_LOG_PRO_SERVER_URL              @"https://stats.chelun.com/app/stats/"

@interface BPNetLogManager ()

@property (atomic, strong) FMDatabaseQueue *dbQueue;
@property (atomic, strong) CTTelephonyNetworkInfo *networkInfo;
@property (atomic, strong) Reachability *reachability;

@end

@implementation BPNetLogManager

- (void)startWithIsProduction:(BOOL)isProduction
{
    self.enable = YES;
    self.isProduction = isProduction;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:[BPFileUtil getDocumentPathWithDir:@"log" fileName:@"nwl.dat"]];
        [_dbQueue inDatabase:^(FMDatabase *db) {
            if (![db tableExists:@"cache"]) {
                [db executeUpdate:@"CREATE TABLE cache (id INTEGER PRIMARY KEY AUTOINCREMENT, data BOLB)"];
            }
        }];
        
        [self uploadLogDataDelay];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadLogDataDelay) name:UIApplicationWillEnterForegroundNotification object:nil];
        
        self.reachability = [Reachability reachabilityForInternetConnection];
        self.networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    });
}

- (void)uploadLogDataDelay
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [BPExecutorService addBlockOnBackgroundThread:^{
            [self uploadLogDataInBg];
        }];
    });
}

- (void)uploadLogDataInBg
{
    NSMutableArray *list = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select * from cache limit 0, 500"];
        while ([rs next]) {
            id item = [NSKeyedUnarchiver unarchiveObjectWithData:[rs dataForColumn:@"data"]];
            unsigned long long pid = [rs unsignedLongLongIntForColumn:@"id"];
            if (item&&[item isKindOfClass:[NSDictionary class]]) {
                [list addObject:@{@"id":@(pid), @"data":item}];
            }
        }
        [rs close];
    }];
    if (list.count>0) {
        NSMutableArray *bodyList = [NSMutableArray array];
        
        for (NSDictionary *dict in list) {
            [bodyList safeAddObject:[dict objectForKey:@"data"]];
        }
        
        NSData *data = [bodyList JSONData];
        
        NSMutableDictionary *params = [[BPSystemParams sharedInstance] defaultParams];
        if (self.otherParams && [self.otherParams isKindOfClass:[NSDictionary class]]) {
            [params addEntriesFromDictionary:self.otherParams];
        }
        NSURL *url = [self.isProduction?APP_CONST_NET_LOG_PRO_SERVER_URL:APP_CONST_NET_LOG_TEST_SERVER_URL serializeURLWithParams:params];
        BPURLRequest *request = [BPURLRequest getRequestWithParams:nil httpMethod:@"POST" delegate:nil requestURL:[url absoluteString]];
        [request.asiRequest.requestHeaders setObject:@"raw" forKey:@"Content-Type"];
        [request.asiRequest setPostBody:[[NSData compressData:data] mutableCopy]];
        [request.asiRequest setPostLength:data.length];
        request.asiRequest.timeOutSeconds = 20.0f;
        
        [request startSynchronous];
        if (request.asiRequest.responseStatusCode==200) {
            [self.dbQueue inDatabase:^(FMDatabase *db) {
                NSNumber *sid =[[list firstObject] objectForKey:@"id"];
                NSNumber *eid =[[list lastObject] objectForKey:@"id"];
                if (sid&&eid) {
                    [db executeUpdate:@"delete from cache where id>=? and id<=?", sid, eid];
                }
            }];
        }
    }
}

- (void)addLogItem:(BPNetLogItem *)item
{
    if ([self.reachability isReachableViaWiFi]) {
        item.netType = @"WIFI";
    } else {
        if ([self.networkInfo respondsToSelector:@selector(currentRadioAccessTechnology)]) {
            NSString *typeStr = [self.networkInfo currentRadioAccessTechnology];
            item.netType = typeStr;
        }
    }
    
    NSString *subType = self.networkInfo.subscriberCellularProvider.carrierName;
    item.netSubType = subType;
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"replace into cache (data) values (?)", [NSKeyedArchiver archivedDataWithRootObject:[item dict]]];
    }];
}

+ (BPNetLogManager *)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BPNetLogManager alloc] init];
    });
    return instance;
}

@end


@implementation BPNetLogItem

- (NSDictionary *)dict
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableDictionary *clientInfo = [NSMutableDictionary dictionary];
    [clientInfo safeSetObject:self.netType forKey:@"network_type"];
    [clientInfo safeSetObject:self.netSubType forKey:@"network_sub_type"];
    [dict safeSetObject:clientInfo forKey:@"client_info"];
    NSMutableDictionary *httpInfo = [NSMutableDictionary dictionary];
    [httpInfo safeSetObject:[NSString stringWithFormat:@"%f", self.requestTime] forKey:@"request_time"];
    [httpInfo safeSetObject:self.method forKey:@"method"];
    [httpInfo safeSetObject:[NSString stringWithFormat:@"%zd", self.postLength] forKey:@"post_length"];
    [httpInfo safeSetObject:[NSString stringWithFormat:@"%zd", self.bodyLength] forKey:@"body_length"];
    [httpInfo safeSetObject:[NSString stringWithFormat:@"%zd", self.code] forKey:@"code"];
    [httpInfo safeSetObject:[NSString stringWithFormat:@"%zd", self.dataCode] forKey:@"data_code"];
    [httpInfo safeSetObject:self.jsonParse?@"1":@"0" forKey:@"json_parse"];
    [httpInfo safeSetObject:self.url forKey:@"url"];
    [httpInfo safeSetObject:[NSString stringWithFormat:@"%f", self.headerTime] forKey:@"header_time"];
    [httpInfo safeSetObject:[NSString stringWithFormat:@"%f", self.time] forKey:@"time"];
    [dict safeSetObject:httpInfo forKey:@"http"];
    return dict;
}

- (void)startLog
{
    _startTimestamp = [[NSDate date] timeIntervalSince1970];
}

- (void)receiveHeader
{
    _headerTime = [[NSDate date] timeIntervalSince1970] - _startTimestamp;
}

- (void)endLog
{
    _time = [[NSDate date] timeIntervalSince1970] - _startTimestamp;
    [[BPNetLogManager sharedInstance] addLogItem:self];
}

@end
