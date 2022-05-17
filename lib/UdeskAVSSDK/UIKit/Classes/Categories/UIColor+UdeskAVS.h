//
//  UIColor+AVS.h
//  UdeskAVSExample
//
//  Created by Admin on 2022/4/26.
//

#import <UIKit/UIKit.h>

#ifndef UIColorHex
#define UIColorHex(_hex_)   [UIColor colorWithHexString:((__bridge NSString *)CFSTR(#_hex_))]
#endif

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (UdeskAVS)

+ (UIColor *) colorWithHexString: (NSString *)color;

@end

NS_ASSUME_NONNULL_END
