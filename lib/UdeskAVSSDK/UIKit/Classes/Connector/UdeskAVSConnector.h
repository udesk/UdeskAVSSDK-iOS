//
//  UdeskAVSConnector.h
//  UdeskAVSExample
//
//  Created by 陈历 on 2021/6/3.
//

#import <UIKit/UIKit.h>
#import "UdeskAVSConfig.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^UdeskAVSCompletion)(NSError * _Nullable error);

@class UdeskAVSParams;

@interface UdeskAVSConnector : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong, readonly)UdeskAVSConfig *sdkConfig;

@property (nonatomic, assign)BOOL isLeveling;

@property (nonatomic, weak) UINavigationController * baseUavsViewController;
@property (nonatomic, strong)UIViewController * _Nullable holdBaseViewController;

- (void)presentUdeskOnViewController:(UIViewController *)controller
                           sdkConfig:(UdeskAVSConfig *)config
                          completion:(UdeskAVSCompletion _Nullable)completion;

- (void)screenShowOnViewController:(UIViewController *)controller;

- (void)dismissWithLeveling;

@end

NS_ASSUME_NONNULL_END
