//
//  UdeskAVSParams.h
//  UdeskAVSSDK
//
//  Created by 陈历 on 2021/6/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UdeskAVSParams : NSObject

/**
 udeskDomin:Udesk后台服务器域名
 */
@property (nonatomic, strong) NSString *udeskDomin;
/**
 code:用户的身份证，在统一商户内，如果code相同，Udesk会认为是同一个人。
 */
@property (nonatomic, strong) NSString *code;
/**
 agentId:制定客服
 */
@property (nonatomic, strong) NSString *agentId;
/**
 sdkAppId：Udesk分配的id
 */
@property (nonatomic, strong) NSString *sdkAppId;

@end

NS_ASSUME_NONNULL_END
