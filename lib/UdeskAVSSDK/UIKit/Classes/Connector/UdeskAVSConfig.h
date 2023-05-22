//
//  UdeskAVSConfig.h
//  UdeskAVSExample
//
//  Created by Admin on 2022/5/13.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UdeskAVSBundleUtils.h"

@class UdeskAVSParams;

typedef BOOL (^UAWillMinBlock)(UIViewController *controller);

@interface UdeskAVSConfig : NSObject

@property (nonatomic, strong)UdeskAVSParams *sdkParam;

@property (nonatomic, copy)  UAWillMinBlock  willMinViewBlock;//最小化时的回调block

@property (nonatomic, assign)BOOL isScreenShare;//是否支持屏幕分享，默认NO, 屏幕分享当前仅支持应用内，需用真机测试。
@property (nonatomic, assign)BOOL isMiniView;   //是否支持最小化，默认NO，需配合最小化回调，实现悬浮按钮，参见demo


+ (instancetype)defaultConfig;
/**
 SDK 配置的config
 */
+ (UdeskAVSConfig *)currentConfig;
/*
 语言类型,推荐此方法.
 
 注意:
 1. 使用时请提前创建对应语言的语言包, 分为App端和和服务端.
 2. App端创建对应名称的lproj包, 用于一些本地语言的切换, 当前已经包含中文(zh-Hans.proj)和英文(en.lproj). 默认使用简体中文. 如果未创建, 则使用对应的key值
 3. 服务端创建对应的语言包, Api返回数据时根据配置来选择对应语言. 帮助文档:http://udesk.udesk.cn/hc/articles/46387. 如果未创建, 默认使用中文.
 4. 可配置服务端默认语言包, 如果未设置, 则使用此默认
 
 ar:阿拉伯语;
 en-us:英语; // 注意:App端对应en.lproj !!!!!!!!!
 es:西班牙语;
 fr:法语;
 ja:日语;
 ko:朝鲜语/韩语;
 th:泰语;
 id:印度尼西亚语;
 zh-TW:繁体中文;
 pt:葡萄牙语;
 ru:俄语;
 zh-cn:中文简体; // 注意:App端对应zh-Hans.proj !!!!!!!!!
 */
@property (nonatomic, copy) NSString *language;


#pragma mark 默认文案和图片
/**
 等待客服接听提示语，优先显示服务器配置的内容，如未进行配置，则显示此默认文案
 */
@property (nonatomic, strong) NSString *defaultWaitAnswerText;
/**
 排队页面提示语，优先显示服务器配置的内容，如未进行配置，则显示此默认文案
 */
@property (nonatomic, strong) NSString *defaultQueueTipsText;


- (void)setConfigToDefault;

@end

