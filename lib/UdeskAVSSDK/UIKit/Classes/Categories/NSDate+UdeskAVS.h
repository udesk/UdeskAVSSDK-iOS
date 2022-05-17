//
//  NSDate+UdeskAVS.h
//  UdeskAVSExample
//
//  Created by Admin on 2022/4/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (UdeskAVS)

+ (NSDate *)uavs_dateWithString:(NSString *)dateString format:(NSString *)format;
                         
+ (NSDate *)uavs_dateWithString:(NSString *)dateString
                         format:(NSString *)format
                       timeZone:(NSTimeZone *)timeZone
                         locale:(NSLocale *)locale;

- (NSString *)uavs_stringWithFormat:(NSString *)format;

- (BOOL)uavs_isToday;

@end

NS_ASSUME_NONNULL_END
