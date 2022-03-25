//
//  UIAlertController+UdeskAVS.h
//  UdeskAvsSDKDemo
//
//  Created by 陈历 on 2021/6/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (UdeskAVS)

+ (void)udeskShowAlert:(NSString *)title
      onViewController:(UIViewController *)controller
            completion:(void(^)(void))completion;

+ (instancetype)udeskShowSimpleAlert:(NSString *)title
                    onViewController:(UIViewController *)controller
                          completion:(void(^)(int))completion;

@end

NS_ASSUME_NONNULL_END
