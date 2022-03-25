//
//  UdeskAVSMacroHeader.h
//  UdeskAVSExample
//
//  Created by 陈历 on 2021/6/3.
//

#ifndef UdeskAVSMacroHeader_h
#define UdeskAVSMacroHeader_h

#define udeskIPhoneXSeries ({ \
BOOL ipX = NO; \
if (@available(iOS 11.0, *)) { \
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject]; \
    ipX = window.safeAreaInsets.bottom > 0; \
} \
  ipX; \
})


#define kUdeskScreenStatusHeight ((udeskIPhoneXSeries==YES)?44.0f:20.0f)
#define kUdeskScreenNavBarHeight ((udeskIPhoneXSeries==YES)?88.0f:64.0f)
#define kUdeskScreenTabBarHeight ((udeskIPhoneXSeries==YES)?83.0f:49.0f)
#define kUdeskScreenTabBarSafeAreaHeight ((udeskIPhoneXSeries==YES)?34.0f:0.0f)

#define kUdeskGlobalMessageHandOff @"kUdeskGlobalMessageHandOff"

typedef NS_ENUM(NSUInteger, UDESK_VIDEO_TOOL_BUTTON_TYPE) {
    UDESK_VIDEO_TOOL_BUTTON_TYPE_ZOOM = 1,
    UDESK_VIDEO_TOOL_BUTTON_TYPE_INFO,
    UDESK_VIDEO_TOOL_BUTTON_TYPE_MICRO,
    UDESK_VIDEO_TOOL_BUTTON_TYPE_EXCHANGE,
    UDESK_VIDEO_TOOL_BUTTON_TYPE_TRANSFER,
    UDESK_VIDEO_TOOL_BUTTON_TYPE_HANDOFF,
    UDESK_VIDEO_TOOL_BUTTON_TYPE_ENABLE_VIDEO
};

typedef NS_ENUM(NSUInteger, UDESK_AVS_VIDEO_MODE) {
    UDESK_AVS_VIDEO_MODE_VIDEO_FULLSCREEN = 1,
    UDESK_AVS_VIDEO_MODE_VIDEO_SMALL,
    UDESK_AVS_VIDEO_MODE_VOICE
};

typedef NS_ENUM(NSUInteger, UDESK_AVS_FACE_MODE) {
    UDESK_AVS_FACE_MODE_MAIN = 1,
    UDESK_AVS_FACE_MODE_d,
};


#endif /* UdeskAVSMacroHeader_h */
