//
//  BPNSDateAdditions.h
//  BPCommon
//
//  Created by hunter on 9/16/12.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (vge)

+ (NSDate *)localeDateWithTimeIntervalSince1970:(NSTimeInterval)timeInterval;
+ (NSDate *)localeDateWithTimeIntervalSince1970:(NSTimeInterval)timeInterval timeZone:(NSTimeZone *)timeZone;
- (NSDate *)gmtDateFromSystemTimeZone;
- (NSDate *)gmtDateFromTimeZone:(NSTimeZone *)timeZone;
- (NSDate *)dateByMoveDay:(NSInteger)day;
- (NSDate *)dateByMoveMonth:(NSInteger)month;
- (NSDate *)dateByMoveYear:(NSInteger)year;

- (NSComparisonResult)compareForDay:(NSDate *)date;
- (NSComparisonResult)compareForWeek:(NSDate *)date;
- (NSComparisonResult)compareForMonth:(NSDate *)date;
- (NSComparisonResult)compareForYear:(NSDate *)date;

@end
