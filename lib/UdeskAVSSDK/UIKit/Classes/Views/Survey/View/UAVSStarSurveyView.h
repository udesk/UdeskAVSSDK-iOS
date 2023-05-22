//
//  UdeskStarSurveyView.h
//  UdeskSDK
//
//  Created by xuchen on 2018/3/29.
//  Copyright © 2018年 Udesk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAVSSurveyProtocol.h"
@class UAVSSurveySetModel;
@class UAVSSurveyModel;
@interface UAVSStarSurveyView : UIView

@property (nonatomic, strong) UAVSSurveySetModel *starSurvey;
@property (nonatomic, weak  ) id<UAVSSurveyProtocol> delegate;

- (instancetype)initWithStarSurvey:(UAVSSurveySetModel *)starSurvey;

@end
