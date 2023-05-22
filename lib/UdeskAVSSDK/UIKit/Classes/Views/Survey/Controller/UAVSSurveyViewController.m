//
//  UAVSSurveyViewController.m
//  UdeskSDK
//
//  Created by xuchen on 2018/4/9.
//  Copyright © 2018年 Udesk. All rights reserved.
//

#import "UAVSSurveyViewController.h"
#import "UAVSSurveyView.h"
#import "UIView+UdeskAVS.h"

@interface UAVSSurveyViewController ()<UIApplicationDelegate, UIGestureRecognizerDelegate>

@end

@implementation UAVSSurveyViewController

#pragma mark - 监听键盘通知做出相应的操作
- (void)subscribeToKeyboard {
    
//    [self udSubscribeKeyboardWithBeforeAnimations:nil animations:^(CGRect keyboardRect, NSTimeInterval duration, BOOL isShowing) {
//        
//        CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:self.view].origin.y;
//        if (self.surveyView) {
//            self.surveyView.surveyContentView.keyboardHeight = self.view.height-keyboardY;
//            self.surveyView.bottom = keyboardY;
//        }
//        
//    } completion:nil];
}

- (void)loadView {
    
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.surveyView];    
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (CGRectContainsPoint([self.surveyView.contentView bounds], [touch locationInView:self.surveyView.contentView])){
        return NO;
    }
    
    return YES;
}

- (void)showSurveyView:(UAVSSurveyView *)surveyView completion:(void (^)(void))completion {
    _surveyView = surveyView;
 
    //监听键盘
    [self subscribeToKeyboard];

    
}

- (void)dismissWithCompletion:(void (^)(void))completion {
    
    // remove键盘通知或者手势
//    [self udUnsubscribeKeyboard];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.surveyView) {
            [self.surveyView removeFromSuperview];
        }
        if (completion) completion();
    }];
}

@end
