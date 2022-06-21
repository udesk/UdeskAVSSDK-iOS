//
//  UdeskAVSConfig.h
//  UdeskAVSExample
//
//  Created by Admin on 2022/5/13.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class UdeskAVSParams;

typedef BOOL (^UAWillMinBlock)(UIViewController *controller);

@interface UdeskAVSConfig : NSObject

@property (nonatomic, strong)UdeskAVSParams *sdkParam;

@property (nonatomic, copy)  UAWillMinBlock  willMinViewBlock;//最小化时的回调block

@property (nonatomic, assign)BOOL isScreenShare;//是否支持屏幕分享，默认NO, 屏幕分享当前仅支持应用内，需用真机测试。
@property (nonatomic, assign)BOOL isMiniView;   //是否支持最小化，默认NO，需配合最小化回调，实现悬浮按钮，参见demo


+ (instancetype)defaultConfig;


@end

