//
//  NSDate+UdeskAVS.m
//  UdeskAVSExample
//
//  Created by Admin on 2022/4/26.
//

#import "NSDate+UdeskAVS.h"

@implementation NSDate (UdeskAVS)

+ (NSDate *)uavs_dateWithString:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

+ (NSDate *)uavs_dateWithString:(NSString *)dateString
                         format:(NSString *)format
                       timeZone:(NSTimeZone *)timeZone
                         locale:(NSLocale *)locale {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    if (timeZone) [formatter setTimeZone:timeZone];
    if (locale) [formatter setLocale:locale];
    return [formatter dateFromString:dateString];
}

- (NSString *)uavs_stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromDate:self];
}
- (BOOL)uavs_isToday {
    if (fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24) return NO;
    //return [NSDate new].day == self.day;
    NSDate *today = [NSDate date];
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:today];
    
    return (dateComponents.year == todayComponents.year &&
            dateComponents.month == todayComponents.month &&
            dateComponents.day == todayComponents.day);
    
}
@end
