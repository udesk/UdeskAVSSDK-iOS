//
//  UAVSSurveyViewController.h
//  UdeskSDK
//
//  Created by xuchen on 2018/4/9.
//  Copyright © 2018年 Udesk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UAVSSurveyView;

@interface UAVSSurveyViewController : UIViewController

@property(nonatomic, strong, readonly) UAVSSurveyView *surveyView;

- (void)showSurveyView:(UAVSSurveyView *)surveyView completion:(void (^)(void))completion;
- (void)dismissWithCompletion:(void (^)(void))completion;

@end
