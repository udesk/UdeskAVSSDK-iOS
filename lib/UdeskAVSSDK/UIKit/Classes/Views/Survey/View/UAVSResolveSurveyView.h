//
//  UdeskExpressionSurveyView.h
//  UdeskSDK
//
//  Created by xuchen on 2018/3/29.
//  Copyright © 2018年 Udesk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAVSSurveyProtocol.h"
@class UAVSSurveyResolveSetModel;

@interface UAVSResolveSurveyView : UIView

@property (nonatomic, strong) UAVSSurveyResolveSetModel *resolveSurvey;
@property (nonatomic, weak  ) id<UAVSSurveyProtocol> delegate;

- (instancetype)initWithResolveSurvey:(UAVSSurveyResolveSetModel *)resolveSurvey;

@end
