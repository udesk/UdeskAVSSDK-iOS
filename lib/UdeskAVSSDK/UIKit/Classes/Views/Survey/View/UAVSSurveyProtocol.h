//
//  UAVSSurveyProtocol.h
//  UdeskSDK
//
//  Created by xuchen on 2018/3/30.
//  Copyright © 2018年 Udesk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UAVSSurveySetOptionModel;

@protocol UAVSSurveyProtocol <NSObject>

- (void)didSelectResolveSurveyWithOption:(UAVSSurveySetOptionModel *)option;

- (void)didSelectExpressionSurveyWithOption:(UAVSSurveySetOptionModel *)option;

@end
