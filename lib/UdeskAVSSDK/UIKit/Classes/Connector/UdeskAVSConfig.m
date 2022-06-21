//
//  UdeskAVSConfig.m
//  UdeskAVSExample
//
//  Created by Admin on 2022/5/13.
//

#import "UdeskAVSConfig.h"
#import "UdeskAVSSDK.h"
#import "UdeskIndexViewController.h"

@implementation UdeskAVSConfig


+ (instancetype)defaultConfig{
    static UdeskAVSConfig *_config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _config = [[UdeskAVSConfig alloc] init];
        [_config defauleSetUp];
    });
    
    return _config;
}

- (void)defauleSetUp
{
    _isScreenShare = NO;
    _isMiniView = NO;
}

@end
