//
//  UIAlertController+UdeskAVS.m
//  UdeskAvsSDKDemo
//
//  Created by 陈历 on 2021/6/3.
//

#import "UIAlertController+UdeskAVS.h"

@implementation UIAlertController (UdeskAVS)

+ (void)udeskShowAlert:(NSString *)title
      onViewController:(UIViewController *)controller
            completion:(void(^)(void))completion{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *conform = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (completion) {
            completion();
        }
        }];
    
    [alert addAction:conform];
    [controller presentViewController:alert animated:YES completion:^{
        
    }];
}

+ (instancetype)udeskShowSimpleAlert:(NSString *)title
                    onViewController:(UIViewController *)controller
                          completion:(void(^)(int))completion{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *conform = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (completion) {
            completion(0);
        }
        }];
    [alert addAction:conform];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (completion) {
            completion(1);
        }
        }];
    [alert addAction:cancel];
    [controller presentViewController:alert animated:YES completion:^{
        
    }];
    return  alert;
}

@end
