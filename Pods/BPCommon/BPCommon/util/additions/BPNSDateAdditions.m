//
//  BPNSDateAdditions.m
//  BPCommon
//
//  Created by hunter on 9/16/12.
//
//

#import "BPNSDateAdditions.h"

@implementation NSDate (vge)

+ (NSDate *)localeDateWithTimeIntervalSince1970:(NSTimeInterval)timeInterval {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSDate *GMTDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSInteger interval = [zone secondsFromGMTForDate:GMTDate];
    return [GMTDate dateByAddingTimeInterval:interval];
}

+ (NSDate *)localeDateWithTimeIntervalSince1970:(NSTimeInterval)timeInterval timeZone:(NSTimeZone *)timeZone
{
    NSDate *GMTDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSInteger interval = [timeZone secondsFromGMTForDate:GMTDate];
    return [GMTDate dateByAddingTimeInterval:interval];
}

- (NSDate *)gmtDateFromSystemTimeZone
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMT];
    return [self dateByAddingTimeInterval:-interval];
}

- (NSDate *)gmtDateFromTimeZone:(NSTimeZone *)timeZone
{
    NSInteger interval = [timeZone secondsFromGMT];
    return [self dateByAddingTimeInterval:-interval];
}

- (NSDate *)dateByMoveDay:(NSInteger)day
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self];
    [components setDay:day];
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByMoveMonth:(NSInteger)month
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:self];
    [components setMonth:month];
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByMoveYear:(NSInteger)year
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:self];
    [components setYear:year];
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}

- (NSComparisonResult)compareForDay:(NSDate *)date
{
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    if( [components1 year] > [components2 year] )
        return NSOrderedAscending;
    else if( [components1 year] < [components2 year] )
        return NSOrderedDescending;
    if( [components1 month] > [components2 month] )
        return NSOrderedAscending;
    else if( [components1 month] < [components2 month] )
        return NSOrderedDescending;
    if( [components1 day] > [components2 day] )
        return NSOrderedAscending;
    else if( [components1 day] < [components2 day] )
        return NSOrderedDescending;
    return NSOrderedSame;
}

- (NSComparisonResult)compareForWeek:(NSDate *)date
{
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSWeekCalendarUnit fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSWeekCalendarUnit fromDate:date];
    
    if( [components1 week] > [components2 week] )
        return NSOrderedAscending;
    else if( [components1 week] < [components2 week] )
        return NSOrderedDescending;
    
    return NSOrderedSame;
}

- (NSComparisonResult)compareForMonth:(NSDate *)date
{
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:date];
    
    if( [components1 year] > [components2 year] )
        return NSOrderedAscending;
    else if( [components1 year] < [components2 year] )
        return NSOrderedDescending;
    
    if( [components1 month] > [components2 month] )
        return NSOrderedAscending;
    else if( [components1 month] < [components2 month] )
        return NSOrderedDescending;
    
    return NSOrderedSame;
}

- (NSComparisonResult)compareForYear:(NSDate *)date
{
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:date];
    
    if( [components1 year] > [components2 year] )
        return NSOrderedAscending;
    else if( [components1 year] < [components2 year] )
        return NSOrderedDescending;
    
    return NSOrderedSame;
}

@end
