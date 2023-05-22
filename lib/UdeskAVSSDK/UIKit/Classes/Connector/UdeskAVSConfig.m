//
//  UdeskAVSConfig.m
//  UdeskAVSExample
//
//  Created by Admin on 2022/5/13.
//

#import "UdeskAVSConfig.h"
#import "UdeskAVSSDK.h"
#import "UdeskIndexViewController.h"
#import "UAVSLanguageConfig.h"
#import "UdeskAVSConnector.h"

@implementation UdeskAVSConfig


+ (instancetype)defaultConfig{
    UdeskAVSConfig *_config = [[UdeskAVSConfig alloc] init];
    return _config;
}

+ (UdeskAVSConfig *)currentConfig
{
    return  [UdeskAVSConnector sharedInstance].sdkConfig;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setConfigToDefault];
    }
    return self;
}

- (void)setLanguage:(NSString *)language{
    NSString * defaultWaitAnswerText = getUDAVSLocalizedString(@"uavs_tip_defaultWaitAnswer");
    NSString * defaultQueueTipsText = getUDAVSLocalizedString(@"uavs_tip_defaultQueueUp");
    
    [UAVSLanguageConfig sharedConfig].language = language;
    
    //刷新默认文案
    if ([self.defaultWaitAnswerText isEqualToString:defaultWaitAnswerText]) {
        self.defaultWaitAnswerText = getUDAVSLocalizedString(@"uavs_tip_defaultWaitAnswer");
    }
    if ([self.defaultQueueTipsText isEqualToString:defaultQueueTipsText]) {
        self.defaultQueueTipsText = getUDAVSLocalizedString(@"uavs_tip_defaultQueueUp");
    }
}

- (void)setConfigToDefault {
    self.isScreenShare = NO;
    self.isMiniView = NO;
    self.defaultWaitAnswerText = getUDAVSLocalizedString(@"uavs_tip_defaultWaitAnswer");
    self.defaultQueueTipsText = getUDAVSLocalizedString(@"uavs_tip_defaultQueueUp");
}

@end
