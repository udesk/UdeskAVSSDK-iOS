//
//  UdeskAVSConnector.m
//  UdeskAVSExample
//
//  Created by 陈历 on 2021/6/3.
//

#import "UdeskAVSConnector.h"
#import "UdeskAVSSDK.h"
#import "UdeskIndexViewController.h"
#import "UIAlertController+UdeskAVS.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UdeskAVSBundleUtils.h"
#import "UAVSSurveyView.h"

@interface UdeskAVSConnector () <UdeskFetchMerchantDelegate>

@property (nonatomic, weak) UIViewController *udeskPresentedViewController;
@property (nonatomic, copy) UdeskAVSCompletion resultCompletion;

@property (nonatomic, strong, readwrite)UdeskAVSConfig *sdkConfig;

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
                           sdkConfig:(UdeskAVSConfig *)config
                          completion:(UdeskAVSCompletion)completion
{
    self.udeskPresentedViewController = controller;
    self.resultCompletion = completion;
    self.sdkConfig = config;
    UdeskAVSSDKManager *instance = [UdeskAVSSDKManager sharedInstance];
    [instance fetchMerchantInfo:config.sdkParam delegate:self];
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
    self.baseUavsViewController = nav;
    [self.udeskPresentedViewController presentViewController:nav animated:YES completion:^{
        if (self.resultCompletion) {
            self.resultCompletion(nil);
        }
    }];
}

- (void)screenShowOnViewController:(UIViewController *)controller
{
    self.udeskPresentedViewController = controller;
    if (!self.udeskPresentedViewController ||
        ![self.udeskPresentedViewController isKindOfClass:[UIViewController class]]) {
        return;
    }
    
    if (!self.holdBaseViewController ||
        ![self.holdBaseViewController isKindOfClass:[UIViewController class]]) {
        return;
    }
    
    [self.udeskPresentedViewController presentViewController:self.holdBaseViewController animated:YES completion:^{
        self.holdBaseViewController = nil;
    }];
    
}

- (void)didGetMerchantInfoError:(NSError *)error{
    [UIAlertController udeskShowAlert:getUDAVSLocalizedString(@"uavs_error_GetMerchantInfo")
                     onViewController:self.udeskPresentedViewController
                           completion:^{
        if (self.resultCompletion) {
            self.resultCompletion(error);
        }
    }];
}

- (void)dismissWithLeveling
{
    self.holdBaseViewController = self.baseUavsViewController;
    
    if (self.sdkConfig.willMinViewBlock) {
        BOOL gone = self.sdkConfig.willMinViewBlock(self.baseUavsViewController.childViewControllers.firstObject);
        if (!gone) {
            return;
        }
    }
    
    [self.baseUavsViewController dismissViewControllerAnimated:NO completion:^{
        
    }];
    
}

- (BOOL)isLeveling
{
    return self.baseUavsViewController;
}

- (void)closedViewRoom:(NSString *)roomId
{
    [self showSurveyView:roomId];
}

- (void)showSurveyView:(NSString *)roomId
{
    //显示满意度评价
    if (!roomId || !self.udeskPresentedViewController) {
        return;
    }
    
    UAVSSurveyModel *surveyModel = [[UdeskAVSSDKManager sharedInstance] getSurveyModel];
    if (!surveyModel.status) {//基本不可能为空
        return;
    }
    
    UAVSSurveyView *surveyView = [[UAVSSurveyView alloc] initWithSurvey:surveyModel roomId:roomId];
    [surveyView showWithBaseVC:self.udeskPresentedViewController];
    
}

@end
