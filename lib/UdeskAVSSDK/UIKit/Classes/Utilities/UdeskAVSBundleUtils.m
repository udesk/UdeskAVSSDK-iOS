//
//  UdeskBundleUtils.m
//  UdeskSDK
//
//  Created by Udesk on 16/1/18.
//  Copyright © 2016年 Udesk. All rights reserved.
//

#import "UdeskAVSBundleUtils.h"
#import "UAVSLanguageConfig.h"

@implementation UdeskAVSBundleUtils

+ (UIImage *)bundleImageNamed:(NSString *)imageName
{
    NSBundle *resourcesBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[UdeskAVSBundleUtils class]] pathForResource:@"UdeskAVSBundle" ofType:@"bundle"]];
    
    if (resourcesBundle == nil) {
        resourcesBundle = [NSBundle mainBundle];
    }
    
    UIImage *image = [UIImage imageNamed:imageName inBundle:resourcesBundle compatibleWithTraitCollection:nil];;
 
    return image;
}

//多语言
NSString *getUDAVSLocalizedString(NSString *key){
    
    return [[UAVSLanguageConfig sharedConfig] getStringForKey:key withTable:@"UAVSLocalizable"];
}


@end
