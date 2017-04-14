//
//  BPSystemParams.m
//  BPCommon
//
//  Created by wangpeng on 4/19/13.
//
//

#import "BPSystemParams.h"
#import "OpenUDID.h"
#import "BPNSStringAdditions.h"
#import "BPCoreUtil.h"
#import <AdSupport/ASIdentifierManager.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>


@implementation BPSystemParams

- (NSMutableDictionary *)defaultParams
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params = [self addSystemParamsInto:params];
    return params;
}

- (NSMutableDictionary *)addSystemParamsInto:(NSMutableDictionary *)params
{
    if (params==nil) {
        return [self defaultParams];
    } else {
        [params setObject:@"iOS" forKey:@"os"];
        [params setObject:[UIDevice currentDevice].systemVersion forKey:@"systemVersion"];
        [params setObject:[BPCoreUtil devicePlatform] forKey:@"model"];
        [params setObject:_app forKey:@"app"];
        [params setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"appVersion"];
        [params setObject:[OpenUDID value] forKey:@"openUDID"];
        if (_channel) {
            [params setObject:_channel forKey:@"appChannel"];
        }
        if ([self.class isJailbroken]) {
            [params setObject:@"1" forKey:@"jb"];
        }
        NSString *clientUDID = [self.class clientUDID];
        if (clientUDID.length>0) {
            [params setObject:clientUDID forKey:@"cUDID"];
        }
        if (_gdCityCode) {
            [params setObject:_gdCityCode forKey:@"_cityCode"];
        }
        return params;
    }
}

+ (BPSystemParams *)sharedInstance
{
    static id instance = nil;
    if (!instance) {
        instance = [[BPSystemParams alloc] init];
        [instance setApp:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]];
    }
    return instance;
}

- (NSString *)addSystemParamsIntoUrl:(NSString *)url
{
    if ([BPCoreUtil isStringEmpty:url]) {
        return @"";
    }
    
    return [[url serializeURLWithParams:[self defaultParams] httpMethod:@"GET"] absoluteString];
}

+ (BOOL)isJailbroken
{
    static BOOL isJB = NO;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"] ||
            [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/MobileSubstrate.dylib"] ||
            [[NSFileManager defaultManager] fileExistsAtPath:@"/bin/bash"] ||
            [[NSFileManager defaultManager] fileExistsAtPath:@"/usr/sbin/sshd"] ||
            [[NSFileManager defaultManager] fileExistsAtPath:@"/etc/apt"] ||
            [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"] ||
            [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://package/com.example.package"]])  {
            isJB = YES;
        }
    });

    return isJB;
}

+ (NSString *)clientUDID
{
    static NSString *clientUDID;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *array = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."];
        if ([[array firstObject] floatValue]>=7) {
            clientUDID = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        } else {
            clientUDID = [self macAddress];
        }
    });
    return clientUDID;
}

+ (NSString *)macAddress
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}

@end
