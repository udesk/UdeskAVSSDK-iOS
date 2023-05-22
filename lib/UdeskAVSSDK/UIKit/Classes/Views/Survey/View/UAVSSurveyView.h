//
//  UAVSSurveyView.h
//  UdeskSDK
//
//  Created by xuchen on 2018/4/9.
//  Copyright © 2018年 Udesk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAVSSurveyContentView.h"

@class UAVSSurveyModel;

@interface UAVSSurveyView : UIControl

@property (nonatomic, strong) UAVSSurveyContentView *surveyContentView;
@property (nonatomic, strong) UIView *contentView;

- (instancetype)initWithSurvey:(UAVSSurveyModel *)surveyModel roomId:(NSString *)roomId;

- (void)showWithBaseVC:(UIViewController *)baseVC;
- (void)dismiss;

@end
