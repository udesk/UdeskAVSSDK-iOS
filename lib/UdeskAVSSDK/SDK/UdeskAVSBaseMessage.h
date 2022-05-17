//
//  UdeskAVSBaseMessage.h
//  UdeskAvsSDKDemo
//
//  Created by 陈历 on 2021/6/2.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    UdeskAVSMessageFromTypeCustomer                = 0,//来自 顾客 默认发送为顾客
    UdeskAVSMessageFromTypeAgent                   = 1,//来自 客服
    UdeskAVSMessageFromTypeSystem                  = 2,//来自 系统
} UdeskAVSMessageFromType;

typedef enum : NSUInteger {
    UdeskAVSMessageContentTypeText                  = 0,//文字
    UdeskAVSMessageContentTypeImage                 = 1,//图片
    UdeskAVSMessageContentTypeRich                  = 2,//富文本
    UdeskAVSMessageContentTypeSurvey                = 3,//满意度调查
} UdeskAVSMessageContentType;


typedef enum : NSUInteger {
    UAVSMessageSendStatusSuccess               = 0,//发送成功
    UAVSMessageSendStatusFailed                = 1,//发送失败
    UAVSMessageSendStatusSending               = 2,//发送中
    UAVSMessageSendStatusRollback              = 3,//撤回
    UAVSMessageSendStatusOffSending            = 4,//离线发送
} UAVSMessageSendStatus;


@interface UdeskAVSBaseMessage : NSObject

/** 消息ID */
@property (nonatomic, strong) NSString *messageId;
/** 具体消息 */
@property (nonatomic, strong) NSString *content;
/** 资源数据（image/voice/video） */
@property (nonatomic, strong) NSData   *sourceData;
/** 来自顾客还是客服 */
@property (nonatomic, assign) UdeskAVSMessageFromType  fromType;
/** 消息类型 */
@property (nonatomic, assign) UdeskAVSMessageContentType  messageType;

/** 客服默认图片 */
@property (nonatomic, strong) UIImage *agentAvtarImage;
/** 客服默认图片 */
@property (nonatomic, strong) NSString *agentAvtarUrl;
/** 用户默认图片 */
@property (nonatomic, strong) UIImage *customerAvtarImage;
/** 用户默认图片 */
@property (nonatomic, strong) NSString *customerAvtarUrl;
/** 消息时间 */
//@property (nonatomic, copy  ) NSDate   *timestamp;
/** 消息时间 */
@property (nonatomic, assign) NSTimeInterval  timestamp;


/** 图片消息 - 图片 */
@property (nonatomic, strong) UIImage  *image;
/** 图片宽度 */
@property (nonatomic, assign) CGFloat  width;
/** 图片高度 */
@property (nonatomic, assign) CGFloat  height;

/** 消息状态 */
@property (nonatomic, assign) UAVSMessageSendStatus  sendStatus;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
