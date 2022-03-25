//
//  UdeskAVSTRTCRoomInfo.h
//  UdeskAVSSDK
//
//  Created by 陈历 on 2021/6/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UdeskAVSTRTCRoomInfo : NSObject

/**agentId*/
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) int sdkAppid;
@property (nonatomic, strong) NSString *userSig;
@property (nonatomic, assign) int roomId;

@end

NS_ASSUME_NONNULL_END
