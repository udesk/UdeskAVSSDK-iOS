//
//  UdeskDateUtil.h
//  UdeskSDK
//
//  Created by Udesk on 16/6/3.
//  Copyright © 2016年 Udesk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UdeskAVSDateUtil : NSObject

//时间转换
+ (NSString *)udStringWithTimelineDate:(NSString *)dateStr;
//时间转换
+ (NSString *)udStringDateWithTimeInterval:(NSTimeInterval)timeInterval;

@end
