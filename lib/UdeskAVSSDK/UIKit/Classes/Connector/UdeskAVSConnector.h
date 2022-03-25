//
//  UdeskAVSConnector.h
//  UdeskAVSExample
//
//  Created by 陈历 on 2021/6/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^UdeskAVSCompletion)(NSError * _Nullable error);

@class UdeskAVSParams;

@interface UdeskAVSConnector : NSObject

+ (instancetype)sharedInstance;

- (void)presentUdeskOnViewController:(UIViewController *)controller
                              params:(UdeskAVSParams *)params
                          completion:(UdeskAVSCompletion)completion;

@end

NS_ASSUME_NONNULL_END
