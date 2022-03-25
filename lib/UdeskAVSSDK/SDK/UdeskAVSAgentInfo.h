//
//  UdeskAVSAgentInfo.h
//  UdeskAVSSDK
//
//  Created by 陈历 on 2021/6/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UdeskAVSAgentInfo : NSObject

@property (nonatomic, strong) NSNumber *abroad;
@property (nonatomic, strong) NSNumber *agentId;
@property (nonatomic, strong) NSString *agentStatus;
@property (nonatomic, strong) NSNumber *area;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *createdAt;
//@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *pushFlag;

@end

NS_ASSUME_NONNULL_END
