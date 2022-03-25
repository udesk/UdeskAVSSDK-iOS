//
//  UdeskRoomViewController.h
//  UdeskAVSExample
//
//  Created by 陈历 on 2021/6/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UdeskAVSTRTCRoomInfo;
@class UdeskAVSAgentInfo;

@interface UdeskRoomViewController : UIViewController

- (instancetype)initWithRoom:(NSDictionary *)info;

- (void)updateAgentInfo:(UdeskAVSAgentInfo *)agent;

- (void)updateMessageList:(NSArray *)messageList;

- (void)hangup:(NSDictionary *)info;

- (void)sendBye;

- (void)exitRoom;

@end

NS_ASSUME_NONNULL_END
