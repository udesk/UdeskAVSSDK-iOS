//
//  UdeskTRTCContextBaseView.h
//  UdeskAvsSDKDemo
//
//  Created by 陈历 on 2021/5/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UdeskRoomViewModel;

@interface UdeskTRTCContextBaseView : UIView

@property (nonatomic, strong)  UdeskRoomViewModel *context;

- (instancetype)initWithFrame:(CGRect)frame context:(UdeskRoomViewModel *)context;

- (void)addObservers:(NSArray <NSString *>*)keyPaths;

- (void)zoomModeChanged:(NSNumber *)zoomMode;
- (void)showChatChanged:(NSNumber *)showchat;
- (void)messageListChanged:(NSArray *)messageList;
- (void)muteChanged:(NSNumber *)flag;
- (void)stopVideoChanged:(NSNumber *)flag;
- (void)cameraSwitchChanged:(NSNumber *)flag;
- (void)mainFaceSelfChanged:(NSNumber *)isMainFaceSelf;
//客服信息
- (void)agentAvatarChanged:(NSString *)avatar;
- (void)agentNameChanged:(NSString *)name;
//屏幕分享
- (void)isViewShareChanged:(NSNumber *)isViewShare;

@end

NS_ASSUME_NONNULL_END
