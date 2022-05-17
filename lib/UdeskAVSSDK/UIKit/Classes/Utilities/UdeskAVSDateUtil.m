//
//  UdeskDateUtil.m
//  UdeskSDK
//
//  Created by Udesk on 16/6/3.
//  Copyright © 2016年 Udesk. All rights reserved.
//

#import "UdeskAVSDateUtil.h"
#import "NSDate+UdeskAVS.h"

@interface UdeskAVSDateUtil()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation UdeskAVSDateUtil


+ (UdeskAVSDateUtil *)sharedFormatter
{
    static UdeskAVSDateUtil *_sharedFormatter = nil;
    
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        _sharedFormatter = [[UdeskAVSDateUtil alloc] init];
    });
    
    return _sharedFormatter;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setLocale:[NSLocale currentLocale]];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return self;
}

- (void)dealloc {
    _dateFormatter = nil;
}

#pragma mark - Formatter

- (NSString *)udStyleDateForDate:(NSDate *)date {
    
    if (!date) return @"";
    
    NSString *dateText = nil;
    NSString *timeText = nil;
    
    NSDate *today = [NSDate date];
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:today];
    
    if (dateComponents.year == todayComponents.year && dateComponents.month == todayComponents.month && dateComponents.day == todayComponents.day) {
        dateText = @"今天";
    } else {
        dateText = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    }
    
    timeText = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
    
    return [NSString stringWithFormat:@"%@ %@",dateText,timeText];
}
- (NSString *)udStyleDateForTimestamp:(NSTimeInterval)timestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    return [self udStyleDateForDate:date];
}

//时间转换
+ (NSString *)udStringWithTimelineDate:(NSString *)dateStr {
    if (!dateStr) return @"";
    
    NSDate *date = [UdeskAVSDateUtil dateWithTimelineString:dateStr];
    return [UdeskAVSDateUtil udStringWithDate:date];
}

//时间转换
+ (NSString *)udStringDateWithTimeInterval:(NSTimeInterval)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [UdeskAVSDateUtil udStringWithDate:date];
}

//时间转换
+ (NSString *)udStringWithDate:(NSDate *)date
{
    if (!date) return @"";
    static NSDateFormatter *formatterFullDate;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        formatterFullDate = [[NSDateFormatter alloc] init];
        [formatterFullDate setDateFormat:@"yy-M-dd HH:mm"];
        [formatterFullDate setLocale:[NSLocale currentLocale]];
    });
    
    NSDate *now = [NSDate new];
    NSTimeInterval delta = now.timeIntervalSince1970 - date.timeIntervalSince1970;
    
    
    NSDate *today = [NSDate date];
    NSCalendarUnit unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:unitFlags fromDate:date];
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:unitFlags fromDate:today];
    
    if (delta < -60 * 10) {
        return [formatterFullDate stringFromDate:date];
    } else if (dateComponents.year == todayComponents.year &&
               dateComponents.month == todayComponents.month &&
               dateComponents.day == todayComponents.day) {
        //今天
        return [NSString stringWithFormat:@"%02ld:%02ld",(long)dateComponents.hour,(long)dateComponents.minute];
    }
    else if (dateComponents.year == todayComponents.year) {
        return [NSString stringWithFormat:@"%02ld-%02ld %02ld:%02ld",dateComponents.month,dateComponents.day,(long)dateComponents.hour,(long)dateComponents.minute];
    }
    else {
        return [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld",dateComponents.year,dateComponents.month,dateComponents.day,(long)dateComponents.hour,(long)dateComponents.minute];
    }
}

+ (NSDate *)dateWithTimelineString:(NSString *)dateStr {

    if (!dateStr) return nil;
    
    NSDate *date;
    if ([dateStr rangeOfString:@"T"].location!= NSNotFound) {
        
        date = [NSDate uavs_dateWithString:dateStr format:@"yyyy-MM-dd'T'HH:mm:ss.SSSXXX" timeZone:[NSTimeZone localTimeZone] locale:[NSLocale systemLocale]];
    }
    else {
        date = [NSDate uavs_dateWithString:dateStr format:@"yyyy-MM-dd HH:mm:ss" timeZone:[NSTimeZone localTimeZone] locale:[NSLocale systemLocale]];
    }
    
    if (!date) {
        date = [NSDate uavs_dateWithString:dateStr format:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ" timeZone:[NSTimeZone localTimeZone] locale:[NSLocale systemLocale]];
    }
    
    if (!date) {
        date = [NSDate uavs_dateWithString:dateStr format:@"yyyy-MM-dd HH:mm:ssZ" timeZone:[NSTimeZone localTimeZone] locale:[NSLocale systemLocale]];
    }
    
    if (!date) {
        date = [NSDate uavs_dateWithString:dateStr format:@"yyyy-MM-dd'T'HH:mm:sszzz" timeZone:[NSTimeZone localTimeZone] locale:[NSLocale systemLocale]];
    }
    
    return date;
}

@end
