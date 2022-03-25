//
//  NSString+UdeskAVS.h
//  UdeskAVSExample
//
//  Created by Admin on 2021/8/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (UdeskAVS)

- (NSURL *)convertToURL;

- (BOOL)isNotEmpty;

@end

NS_ASSUME_NONNULL_END
