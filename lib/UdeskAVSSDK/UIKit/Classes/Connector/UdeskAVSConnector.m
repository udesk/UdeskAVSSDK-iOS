//
//  UdeskAVSConnector.m
//  UdeskAVSExample
//
//  Created by 陈历 on 2021/6/3.
//

#import "UdeskAVSConnector.h"
#import <UdeskAVSSDK/UdeskAVSSDK.h>
#import "UdeskIndexViewController.h"
#import "UIAlertController+UdeskAVS.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface UdeskAVSConnector () <UdeskFetchMerchantDelegate>

@property (nonatomic, weak) UIViewController *udeskPresentedViewController;
@property (nonatomic, copy) UdeskAVSCompletion resultCompletion;

@end

@implementation UdeskAVSConnector

+ (instancetype)sharedInstance{
    static UdeskAVSConnector *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[UdeskAVSConnector alloc] init];
    });
    
    return _sharedManager;
}

- (void)presentUdeskOnViewController:(UIViewController *)controller
                              params:(UdeskAVSParams *)params
                          completion:(UdeskAVSCompletion)completion{
    //检查摄像头权限
    
    self.udeskPresentedViewController = controller;
    self.resultCompletion = completion;
    UdeskAVSSDKManager *instance = [UdeskAVSSDKManager sharedInstance];
    [instance fetchMerchantInfo:params delegate:self];
}

#pragma mark - Private
- (void)judgeCameraLimits{
    
}

#pragma mark - UdeskAVSProtocol
- (void)didGetMerchantInfo:(NSDictionary *)trtcInfo{
    if (!self.udeskPresentedViewController ||
        ![self.udeskPresentedViewController isKindOfClass:[UIViewController class]]) {
        return;
    }
    
    UdeskIndexViewController *indexViewContrller = [[UdeskIndexViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:indexViewContrller];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.udeskPresentedViewController presentViewController:nav animated:YES completion:^{
        if (self.resultCompletion) {
            self.resultCompletion(nil);
        }
    }];
}

- (void)didGetMerchantInfoError:(NSError *)error{
    [UIAlertController udeskShowAlert:@"获取商户信息失败"
                     onViewController:self.udeskPresentedViewController
                           completion:^{
        if (self.resultCompletion) {
            self.resultCompletion(error);
        }
    }];
}


@end
