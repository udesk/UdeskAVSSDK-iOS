//
//  UAVSChatLayout.h
//  UdeskApp
//
//  Created by xuchen on 2018/1/10.
//  Copyright © 2018年 xushichen. All rights reserved.
//

#ifndef UAVSChatLayout_h
#define UAVSChatLayout_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UdeskAVSSDK.h"

//定义cell中的布局间距等
/** 聊天头像的直径 */
static CGFloat const kUAVSCellAvatarDiameter = 40.0;
/** 头像距离屏幕水平边沿距离 */
static CGFloat const kUAVSCellAvatarToHorizontalEdgeSpacing = 8.0;
/** 头像距离屏幕垂直边沿距离 */
static CGFloat const kUAVSCellAvatarToVerticalEdgeSpacing = 14.0;
/** 头像与聊天气泡之间的距离 */
static CGFloat const kUAVSCellAvatarToBubbleSpacing = 8.0;
/** 聊天气泡和文字的水平间距 */
static CGFloat const kUAVSCellBubbleToTextHorizontalSpacing = 10.0;
/** 聊天气泡和文字的垂直间距 */
static CGFloat const kUAVSCellBubbleToTextVerticalSpacing = 12.5;
/** 聊天内容的文字大小 */
static CGFloat const kUAVSCellTextFontSize = 15.0;
/** 聊天时间cell高度 */
static CGFloat const kUAVSChatMessageDateCellHeight = 12.0;
/** 聊天时间fontSize */
static CGFloat const kUAVSChatMessageDateLabelFontSize = 11.0;
/** 聊天内容间隔的时间距离cell两端的间距 */
static CGFloat const kUAVSChatMessageDateLabelToEdgeSpacing = 12.0;
/** 语音时长label的font size */
static CGFloat const kUAVSCellVoiceDurationLabelFontSize = 12.0;
/** 语音图片距离气泡的平行距离 */
static CGFloat const kUAVSCellBubbleToVoiceImageHorizontalLargerSpacing = 15.0;
/** 语音图片距离气泡的垂直距离 */
static CGFloat const kUAVSCellBubbleToVoiceVerticalSpacing = 12.0;
/** 语音文本距离气泡的距离 */
static CGFloat const kUAVSCellBubbleToVoiceTextVerticalSpacing = 6.0;
/** 语音时长文本最大长度 */
static CGFloat const kUAVSCellVoiceTextContentWidth = 50.0;
/** 语音气泡最大长度 */
static CGFloat const kUAVSCellBubbleVoiceMaxContentWidth = 180.0;
/** 语音气泡最小长度 */
static CGFloat const kUAVSCellBubbleVoiceMinContentWidth = 50;
/** 语音气泡高度 */
static CGFloat const kUAVSCellBubbleVoiceHeight = 37;
/** 消息图片宽度 */
static CGFloat const kUAVSChatMessageImageWidth = 180.0;
/** 消息图片高度 */
static CGFloat const kUAVSChatMessageImageHeight = 180.0;
/** 事件消息字体大小 */
static CGFloat const kUAVSChatEventMessageLabelFontSize = 12.0;
/** 事件消息垂直距离 */
static CGFloat const kUAVSChatEventMessageToVerticalEdgeSpacing = 12.0;
/** 事件消息高度 */
static CGFloat const kUAVSChatEventMessageHeight = 21.0;
/** 事件消息间距 */
static CGFloat const kUAVSChatEventToHorizontalEdgeSpacing = 10.0;
/** 消息状态高度 */
static CGFloat const kUAVSChatMessageStatusHeight = 15.0;
/** 消息状态距离气泡垂直距离 */
static CGFloat const kUAVSChatMessageStatusToVerticalEdgeSpacing = 8.0;
/** 消息状态字体大小  */
static CGFloat const kUAVSChatMessageStatusFontSize = 11.0;
/** 底部留白 */
static CGFloat const kUAVSCellBottomMargin = 15.0;
/** 底部事件留白 */
static CGFloat const kUAVSCellBottomEventMargin = 12.0;
/** 底部留白（连续消息，三分钟之内） */
static CGFloat const kUAVSCellContinuousBottomMargin = 5.0;
/** loading的diameter */
static CGFloat const kUAVSCellLoadingSize = 20.0;
/** 聊天气泡和loading的间距 */
static CGFloat const kUAVSCellBubbleToIndicatorSpacing = 6.0;
/** 文本内容最大width */
static CGFloat const kUAVSCellTextContentWidth = 250.0;
/** 文本内容最大width */
static CGFloat const kUAVS320CellTextContentWidth = 180.0;
/** 商品消息width */
static CGFloat const kUAVSChatCellProductImageWidth = 60;
/** 商品消息height */
static CGFloat const kUAVSChatCellProductImageHeight = 60;
/** 小程序卡片消息width */
static CGFloat const kUAVSChatCellMiniProgramCardWidth = 230;
/** 小程序卡片消息图片width */
static CGFloat const kUAVSChatCellMiniProgramCardImageWidth = 210;
/** 小程序卡片消息图片height */
static CGFloat const kUAVSChatCellMiniProgramCardImageHeight = 176;
/** 小程序卡片消息间距 */
static CGFloat const kUAVSChatCellMiniProgramToHorizontalEdgeSpacing = 10.0;
/** 消息状态距离气泡垂直距离 */
static CGFloat const kUAVSChatCellMiniProgramToVerticalEdgeSpacing = 16.0;
/** 视频客服商品图片宽度 */
static CGFloat const kUAVSChatMessageProductV2ImageWidth = 220.0;
/** 视频客服商品图片高度 */
static CGFloat const kUAVSChatMessageProductV2ImageHeight = 100.0;
/** 系统左右分别留空 */
static CGFloat const kUAVSChatMessageSystemLabelMargin = 25.0;

/** 表单图标height */
static CGFloat const kUAVSChatCellFormIconHeight = 38;
/** 表单图标左右前后margin */
static CGFloat const kUAVSChatCellFormIconMargin = 8;
/** 链接 */
static NSString const *kUAVSLinkURLName = @"url";
/** 号码 */
static NSString const *kUAVSNumberName = @"number";
/** 字体 */
static NSString *kUAVSTextFontName = @"Heiti SC";

#endif /* UAVSChatLayout_h */
