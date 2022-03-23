//
//  NSString+UdeskAVS.m
//  UdeskAVSExample
//
//  Created by Admin on 2021/8/20.
//

#import "NSString+UdeskAVS.h"

@implementation NSString (UdeskAVS)

- (NSURL *)convertToURL
{
    NSString *urlString = self;
    if (@available(iOS 9.0, *)) {
        // iOS 9之后使用
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//编码
    }else{
        // 在对URL中的中文进行转码时，iOS 9之前我们使用
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//编码
    }
    return [NSURL URLWithString:urlString];
}

- (BOOL)isNotEmpty
{
    return self.length;
}

@end
