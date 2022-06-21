//
//  UdeskAVSParams.h
//  UdeskAVSSDK
//
//  Created by 陈历 on 2021/6/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    UdeskAVSCustomLevelTypeNormal   = 0,//默认 普通
    UdeskAVSCustomLevelTypeVIP      = 1,//VIP
} UdeskAVSCustomLevelType;


@interface UdeskAVSParams : NSObject

/**
 udeskDomin: 必要字段 Udesk后台服务器域名
 */
@property (nonatomic, strong) NSString *udeskDomin;
/**
 sdkAppId：必要字段 Udesk分配的id
 */
@property (nonatomic, strong) NSString *sdkAppId;


#pragma mark  =============== 客服信息 ==================
/**
 agentId:指定客服
 */
@property (nonatomic, strong) NSString *agentId;
/**
 agentGroupId:客服组id
 */
@property (nonatomic, strong) NSString *agentGroupId;
/**
 customChannel:自定义渠道（根据此配置路由）
 */
@property (nonatomic, strong) NSString *customChannel;



#pragma mark  =============== 客户信息 ==================

/**
 code:  用户的身份证，作废字段，使用customCode代替。
 */
@property (nonatomic, strong) NSString *code DEPRECATED_MSG_ATTRIBUTE("过期字段，请使用customCode代替.下版本将删除");
/**
 customCode:必要字段 用户的身份证，在统一商户内，如果code相同，Udesk会认为是同一个人。
 */
@property (nonatomic, strong) NSString *customCode;
/**
 nickname: 客户名称
 */
@property (nonatomic, strong) NSString *nickName;
/**
 avatar: 客户头像url
 */
@property (nonatomic, strong) NSString *avatar;
/**
 email: 客户邮箱
 */
@property (nonatomic, strong) NSString *email;
/**
 level: 客户等级
 */
@property (nonatomic, assign) UdeskAVSCustomLevelType customLevel;
/**
 telephones: 客户电话，[ { id , content }]
 不传id，代表新增，content是电话号码
 */
@property (nonatomic, strong) NSArray *telephones;
/**
 tags: 客户标签:  多个标签以,分割： 学生,少年
 */
@property (nonatomic, strong) NSString *tags;
/**
 use_description: 客户描述
 */
@property (nonatomic, strong) NSString *use_description;
/**
 customFields:  自定义字段，{}
 */
@property (nonatomic, strong) NSDictionary *customFields;


#pragma mark  =============== 业务记录 ==================
/**
 noteInfo_title: 业务记录主题
 */
@property (nonatomic, strong) NSString *noteInfo_title;
/**
 noteInfo_customFields: 业务记录自定义字段，{}
 */
@property (nonatomic, strong) NSDictionary *noteInfo_customFields;

@end

NS_ASSUME_NONNULL_END
