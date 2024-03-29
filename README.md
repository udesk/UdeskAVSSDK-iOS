# UdeskAVSSDK-iOS

**接入sdk编译报错误请升级Xcode到最新版本**

**推荐使用 cocoaPods 接入方式**

**如发现问题建议先升级到最新版本SDK，或者下载demo做一下验证**

### SDK下载地址

<https://github.com/udesk/UdeskAVSSDK-iOS>

----------

[一、集成SDK](#一集成SDK)

[二、快速使用](#二快速使用)

[三、视频通话配置](#三视频通话配置)

[四、常见问题](#四常见问题)

[五、更新记录](#五更新记录)


#一、集成SDK

### 文件介绍

SDK文件见：lib/UdeskAVSSDK

| 文件      | 说明                          |
| --------- | -----------------------       |
| SDK       | Udesk视频客服SDK              |
| UIKit     | 视频会话UI界面（开源）        |

### 兼容性

代码使用Xcode13、iPhone12 iOS15 编译。

| 类别      | 兼容范围                      |
| --------- | ----------------------------- |
| 系统      | 支持iOS 9.0及以上系统         |
| 架构      | armv7、arm64、i386、x86_64    |
| 开发环境  | 建议使用最新版本Xcode进行开发 |
| Cocoapods | 1.10.1版本                     |

### 导入UdeskAVSSDK到工程

**推荐下载demo代码作为导入参考**

在 Podfile 中加入：

```objective-c
pod 'UdeskAVSSDK'
//或者
pod 'UdeskAVSSDK', :git => 'https://github.com/udesk/UdeskAVSSDK-iOS'
```
执行命令：

```ruby
$ pod install
```

在 控制器 中引入：

```objective-c
//Objective-C
#import <UdeskAVSSDK/UdeskAVSHeader.h>
//swift
import UdeskAVSHeader
```

### 权限问题

SDK使用了iOS的相册、相机、麦克风、保存图片功能，请在info.plist里加入相对应的权限。

**如果不加，会 crash！！！**

# 二、快速使用

UdeskAVSSDK提供了一套开源的聊天界面，帮助开发者快速创建对话窗口和帮助中心，并提供自定义接口，以实现定制需求。

### 初始化SDK并发起呼叫

```objective-c
//SDK参数（domain、sdkAppId、userCode都是必传字段）
UdeskAVSParams *params = [[UdeskAVSParams alloc] init];
params.udeskDomin = @"domain";
params.sdkAppId = @"sdkAppId";
params.code = @"userCode";
params.agentId = "agentId";

UdeskAVSConfig *config = [UdeskAVSConfig defaultConfig];
config.sdkParam = params;
//初始化SDK 并发起呼叫
[[UdeskAVSConnector sharedInstance] presentUdeskOnViewController:self sdkConfig:config completion:^(NSError * _Nullable error) {
    if (error) {
        NSLog(@"error = %@", error);
    }
    else{
        NSLog(@"start call....");
    }
    
}];

```


| 参数名称              | 说明                                  |
| :------------------   | :----------------------------         |
| domain                | 贵公司注册UdeskAVSSDK，分配的域名     |
| sdkAppId              | Udesk分配的视频客服SDK AppId          |
| code                  | 用户的唯一标识，用来识别身份,是**你们生成传入给我们**的。**传入的字符请使用 字母 / 数字 等常见字符集** 。就如同身份证一样，**不允许出现一个身份证号对应多个人，或者一个人有多个身份证号**；其次如果给顾客设置了邮箱和手机号码，也要保证不同顾客对应的手机号和邮箱不一样，如出现相同的，则不会创建新顾客                |
| agentId               | 客服ID，传入后呼叫指定ID的客服        |


- 以上字段domain、sdkAppId、code，其他参数根据自身需求选择
- domain格式为 https://xxx.xxx.xxx/xx  完整url 
- sdkAppId可以在 管理后台  ->  管理中心  ->  渠道管理 ->  视频移动SDK，新增App即可获得
- agentId 对应 管理后台  ->  管理中心  ->  员工管理 ->  ID 列
- **客户信息、客服信息、业务记录**相关参数和描述详见，demo代码和**UdeskAVSParams.h**属性列表

### 通话保持（最小化）

- 配置 UdeskAVSConfig 中 isMiniView 为YES 即可在通话界面显示【最小化】按钮，点击后视频界面退出。通话依然保持。
```
    UdeskAVSConfig *config = [UdeskAVSConfig defaultConfig];
    config.isMiniView = YES;
```

⚠️ 1、配置显示最小化按钮后，建议实现 config.willMinViewBlock 处理通话界面进入后台后如何显示通话进行中的标志。Demo提供了一个浮窗效果，仅供参考。

### 屏幕分享

- 配置 UdeskAVSConfig 中 isScreenShare 为YES 即可使在通话界面显示【视频分享】按钮
```
    UdeskAVSConfig *config = [UdeskAVSConfig defaultConfig];
    config.isScreenShare = YES;
```
⚠️ 1、注意每次app启动后使用分享功能，均需要分享授权。
⚠️ 2、屏幕分享功能需用真机测试
⚠️ 3、建议【屏幕分享】功能与【通话保持（最小化）】同时使用，以实现正常的分享业务。

# 三、视频通话配置

Udesk视频通话参数配置在登录管理后台更改，详见；
**管理后台  ->  管理中心  ->  渠道管理 ->  视频移动SDK -> SDK -> 其他设置**

# 四、常见问题

- 如遇bitcode问题，请在target Build Setting 中搜搜索enable bitcode改为no即可。
- 三方库依赖版本信息，如果项目有已引用对应库，需保证高于下列版本：
    'TXLiteAVSDK_TRTC', '~> 8.7.10102'
    'YYText', '~> 1.0.7'
    'SDWebImage', '~> 5.11.1'
    'MJRefresh', '~> 3.7.5'


# 五、更新记录

#### 更新记录：

**2023/05/22 -- v1.3.0**
**版本更新功能：**
1.支持多语言
2.支持用户反馈评价
3.兼容UdeskSDK

**2022/6/21 -- v1.2.0**
**版本更新功能：**
1.支持屏幕分享
2.支持最小化
3.用户和业务规则参数配置

**2022/5/17 -- v1.1.0**
**版本更新功能：**
1.支持图片和历史消息

**2022/3/29 -- v1.0.5**
**版本更新功能：**
1.上传至cocoaPods官方库

**2022/3/28 -- v1.0.0**
**版本更新功能：**
1.UdeskAVSSDK 基本版本
 
-----



