//
//  UdeskBundleUtils.h
//  UdeskSDK
//
//  Created by Udesk on 16/1/18.
//  Copyright © 2016年 Udesk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UdeskAVSBundleUtils : NSObject

+ (UIImage *)bundleImageNamed:(NSString *)imageName;

//多语言
NSString *getUDAVSLocalizedString(NSString *key);

@end
