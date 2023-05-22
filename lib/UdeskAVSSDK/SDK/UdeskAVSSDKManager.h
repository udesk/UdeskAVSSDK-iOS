//
//  UdeskAVSSDKManager.h
//  UdeskAVSSDK
//
//  Created by 陈历 on 2021/6/3.
//

#import <Foundation/Foundation.h>
#import "UAVSSurveyModel.h"

NS_ASSUME_NONNULL_BEGIN

@class UdeskAVSParams;
@class UdeskAVSCustomModel;
@class UdeskAVSTRTCRoomInfo;
@class UdeskAVSAgentInfo;
@class UdeskAVSInitModel;

@protocol UdeskFetchMerchantDelegate <NSObject>

- (void)didGetMerchantInfo:(NSDictionary *)trtcInfo;
- (void)didGetMerchantInfoError:(NSError *)error;

@end

@protocol UdeskAVSSDKDelegate <NSObject>

/**对方已进入房间*/
- (void)didGetRoomInfo:(UdeskAVSTRTCRoomInfo *)roomInfo;
/**当前客服忙，请稍后再试，退出当前并清理数据*/
- (void)didGetAgentBusy:(NSDictionary *)trtcInfo;
/**等待客服接听*/
- (void)didWaitAnswer:(NSDictionary *)info;
/**更新客服信息*/
- (void)didUpdateAgentInfo:(UdeskAVSAgentInfo *)agent;
/**更新排队信息*/
- (void)didUpdateQueueNumber:(NSInteger)queueNumber;
/**客服挂机*/
- (void)didAgentHangup:(NSDictionary *)info;
/**异常情况*/
- (void)didGetError:(NSError *)error;

@end

@interface UdeskAVSSDKManager : NSObject

/**sdk 所有配置和系统参数*/
@property (nonatomic, strong, readonly) UdeskAVSInitModel *avsContext;

+ (instancetype)sharedInstance;

+ (void)destoryInstance;

- (void)fetchMerchantInfo:(UdeskAVSParams *)params
                 delegate:(id<UdeskFetchMerchantDelegate>)delegate;

- (void)registerDelgate:(id<UdeskAVSSDKDelegate>)delegate;

- (void)call;

- (void)sendText:(NSString *)text;

- (void)sendMessage:(NSDictionary *)msg
            success:(void(^)(id responseObj))success
            failure:(void(^)(NSError * error))failure;

- (void)sendBye;

/**等待客服接听提示语*/
- (NSString *)waitScreenText;
/**排队页面提示语*/
- (NSString *)queueTipsText;
/**logo背景图*/
- (NSString *)talkingBackgroundUrl;
/**客服通话占位图*/
- (NSString *)agentBackgroundUrl;
/**客户通话占位图*/
- (NSString *)customerBackgroundUrl;

/**呼叫等待页背景图配置*/
- (NSString *)callProcessUrl;
/**客户侧接通后默认摄像头配置，默认后置，前置-0/后置-1*/
- (NSInteger)customerCameraSet;


/**获取SDK版本*/
- (NSString *)getSDKVersion;

/**是否展示满意度调查*/
- (BOOL)isShowSurvey;

/**获取满意度调查信息*/
- (UAVSSurveyModel *)getSurveyModel;

/**提交满意度调查*/
- (void)submitSurvey:(NSDictionary *)surveyInfo completion:(void(^)(NSError *error))completion;


@end

NS_ASSUME_NONNULL_END
