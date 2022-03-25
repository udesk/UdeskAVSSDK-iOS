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
    UdeskAVSMessageFromTypeCustomer                = 0,//来自 顾客
    UdeskAVSMessageFromTypeAgent                   = 1,//来自 客服
    UdeskAVSMessageFromTypeSystem                  = 2,//来自 系统
} UdeskAVSMessageFromType;

typedef enum : NSUInteger {
    UdeskAVSMessageContentTypeText                 = 0,//文字
    UdeskAVSMessageContentTypeImage                = 1,//图片
} UdeskAVSMessageContentType;


@interface UdeskAVSBaseMessage : NSObject

/** 来自顾客还是客服 */
@property (nonatomic, assign) UdeskAVSMessageFromType  fromType;
/** 消息类型 */
@property (nonatomic, assign) UdeskAVSMessageContentType  messageType;
/** 具体消息 */
@property (nonatomic, strong) id  content;
/** 客服默认图片 */
@property (nonatomic, strong) UIImage *agentAvtarImage;
/** 客服默认图片 */
@property (nonatomic, strong) NSString *agentAvtarUrl;
/** 用户默认图片 */
@property (nonatomic, strong) UIImage *customerAvtarImage;
/** 用户默认图片 */
@property (nonatomic, strong) NSString *customerAvtarUrl;
/** 创建时间 */
@property (nonatomic, strong) NSString *createAt;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
