//
//  UdeskRoomViewModel.h
//  UdeskAVSExample
//
//  Created by 陈历 on 2021/6/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UdeskRoomViewModel : NSObject

//大屏模式下，消息列表正在显示
@property (nonatomic, strong) NSNumber *isChatShowing;

//当前模式，大屏还是小屏 1: 大屏 2: 小屏 3 语音
@property (nonatomic, strong) NSNumber *zoomMode;

//大屏模式下，主屏幕显示自己，默认：否
@property (nonatomic, strong) NSNumber *isMainFaceSelf;

//消息列表
@property (nonatomic, strong) NSArray *messageList;

//静音
@property (nonatomic, strong) NSNumber *mute;

//暂停本地视频
@property (nonatomic, strong) NSNumber *stopVideo;

//切换摄像头
@property (nonatomic, strong) NSNumber *cameraSwitch;

//客服名称
@property (nonatomic, strong) NSString *agentName;

//客服头像
@property (nonatomic, strong) NSString *agentAvatar;

//开启屏幕分析，1开启 0/nil 关闭
@property (nonatomic, strong) NSNumber *isViewShare;

@end

NS_ASSUME_NONNULL_END
