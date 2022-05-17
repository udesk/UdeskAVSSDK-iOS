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

// Size
#ifndef UD_SCREEN_WIDTH
#define UD_SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define UD_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#endif



#define kUdeskGlobalMessageHandOff @"kUdeskGlobalMessageHandOff"


// View 圆角和加边框
#define UDAVS_ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define UDAVS_ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]



#define UDAVS_FONT(value) [UIFont systemFontOfSize:value]
#define UDAVS_bFONT(value) [UIFont boldSystemFontOfSize:value]

#define UDAVS_isIPhoneXSeries ({ \
BOOL ipX = NO; \
if (@available(iOS 11.0, *)) { \
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject]; \
    ipX = window.safeAreaInsets.bottom > 0; \
} \
  ipX; \
})

#ifndef UDWeakSelf
#define UDWeakSelf __weak typeof(self) weakSelf = self;
#endif


#endif /* UdeskAVSMacroHeader_h */
