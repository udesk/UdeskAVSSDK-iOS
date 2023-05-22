//
//  UdeskAVSUtilities.h
//  UdeskAvsSDKDemo
//
//  Created by 陈历 on 2021/5/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

CGFloat UDAVSUDAVSYYScreenScale(void);

/// Get main screen's size. Height is always larger than width.
CGSize UDAVSYYScreenSize(void);

// main screen's scale
#ifndef kScreenScale
#define kScreenScale UDAVSYYScreenScale()
#endif

// main screen's size (portrait)
#ifndef kScreenSize
#define kScreenSize UDAVSYYScreenSize()
#endif

// main screen's width (portrait)
#ifndef kScreenWidth
#define kScreenWidth UDAVSYYScreenSize().width
#endif

// main screen's height (portrait)
#ifndef kScreenHeight
#define kScreenHeight UDAVSYYScreenSize().height
#endif



@interface UdeskAVSUtil : NSObject

//判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)string;
//网络状态
+ (NSString *)networkStatus;
//判断是否有系统表情
+ (BOOL)stringContainsEmoji:(NSString *)string;
//字符串转字典
+ (id)dictionaryWithJSON:(NSString *)json;
//字典转字符串
+ (NSString *)JSONWithDictionary:(NSDictionary *)dictionary;
//当前控制器
+ (UIViewController *)currentViewController;
//存组ID
+ (void)storeGroupId:(NSString *)groupId;
//获取组ID
+ (NSString *)getGroupId;
//存菜单ID
+ (void)storeMenuId:(NSString *)menuId;
//获取菜单ID
+ (NSString *)getMenuId;
//号码正则
+ (NSArray *)numberRegexs;
//URL正则
+ (NSArray *)linkRegexs;
//URL正则匹配
+ (NSRange)linkRegexsMatch:(NSString *)content;
//URL编码
+ (NSString *)stringByURLEncode:(NSString *)string;
//编码
+ (NSString *)percentEscapedStringFromString:(NSString *)string;
//url编码
+ (NSString *)urlEncode:(NSString *)url;

//string转URL string 如果必要会进行编码
+ (NSString *)urlStringEscapedEncode:(NSString *)string;

//摄像头权限
+ (void)checkPermissionsOfAlbum:(void(^)(BOOL isOK))completion;

@end

