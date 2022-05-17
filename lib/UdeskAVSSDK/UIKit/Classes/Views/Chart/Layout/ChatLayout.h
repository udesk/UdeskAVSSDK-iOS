//
//  ChatLayout.h
//  UdeskApp
//
//  Created by xuchen on 2018/1/10.
//  Copyright © 2018年 xushichen. All rights reserved.
//

#ifndef ChatLayout_h
#define ChatLayout_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UdeskAVSSDK.h"

//定义cell中的布局间距等
/** 聊天头像的直径 */
static CGFloat const kUDCellAvatarDiameter = 40.0;
/** 头像距离屏幕水平边沿距离 */
static CGFloat const kUDCellAvatarToHorizontalEdgeSpacing = 8.0;
/** 头像距离屏幕垂直边沿距离 */
static CGFloat const kUDCellAvatarToVerticalEdgeSpacing = 14.0;
/** 头像与聊天气泡之间的距离 */
static CGFloat const kUDCellAvatarToBubbleSpacing = 8.0;
/** 聊天气泡和文字的水平间距 */
static CGFloat const kUDCellBubbleToTextHorizontalSpacing = 10.0;
/** 聊天气泡和文字的垂直间距 */
static CGFloat const kUDCellBubbleToTextVerticalSpacing = 12.5;
/** 聊天内容的文字大小 */
static CGFloat const kUDCellTextFontSize = 15.0;
/** 聊天时间cell高度 */
static CGFloat const kUDChatMessageDateCellHeight = 12.0;
/** 聊天时间fontSize */
static CGFloat const kUDChatMessageDateLabelFontSize = 11.0;
/** 聊天内容间隔的时间距离cell两端的间距 */
static CGFloat const kUDChatMessageDateLabelToEdgeSpacing = 12.0;
/** 语音时长label的font size */
static CGFloat const kUDCellVoiceDurationLabelFontSize = 12.0;
/** 语音图片距离气泡的平行距离 */
static CGFloat const kUDCellBubbleToVoiceImageHorizontalLargerSpacing = 15.0;
/** 语音图片距离气泡的垂直距离 */
static CGFloat const kUDCellBubbleToVoiceVerticalSpacing = 12.0;
/** 语音文本距离气泡的距离 */
static CGFloat const kUDCellBubbleToVoiceTextVerticalSpacing = 6.0;
/** 语音时长文本最大长度 */
static CGFloat const kUDCellVoiceTextContentWidth = 50.0;
/** 语音气泡最大长度 */
static CGFloat const kUDCellBubbleVoiceMaxContentWidth = 180.0;
/** 语音气泡最小长度 */
static CGFloat const kUDCellBubbleVoiceMinContentWidth = 50;
/** 语音气泡高度 */
static CGFloat const kUDCellBubbleVoiceHeight = 37;
/** 消息图片宽度 */
static CGFloat const kUDChatMessageImageWidth = 180.0;
/** 消息图片高度 */
static CGFloat const kUDChatMessageImageHeight = 180.0;
/** 事件消息字体大小 */
static CGFloat const kUDChatEventMessageLabelFontSize = 12.0;
/** 事件消息垂直距离 */
static CGFloat const kUDChatEventMessageToVerticalEdgeSpacing = 12.0;
/** 事件消息高度 */
static CGFloat const kUDChatEventMessageHeight = 21.0;
/** 事件消息间距 */
static CGFloat const kUDChatEventToHorizontalEdgeSpacing = 10.0;
/** 消息状态高度 */
static CGFloat const kUDChatMessageStatusHeight = 15.0;
/** 消息状态距离气泡垂直距离 */
static CGFloat const kUDChatMessageStatusToVerticalEdgeSpacing = 8.0;
/** 消息状态字体大小  */
static CGFloat const kUDChatMessageStatusFontSize = 11.0;
/** 底部留白 */
static CGFloat const kUDCellBottomMargin = 15.0;
/** 底部事件留白 */
static CGFloat const kUDCellBottomEventMargin = 12.0;
/** 底部留白（连续消息，三分钟之内） */
static CGFloat const kUDCellContinuousBottomMargin = 5.0;
/** loading的diameter */
static CGFloat const kUDCellLoadingSize = 20.0;
/** 聊天气泡和loading的间距 */
static CGFloat const kUDCellBubbleToIndicatorSpacing = 6.0;
/** 文本内容最大width */
static CGFloat const kUDCellTextContentWidth = 250.0;
/** 文本内容最大width */
static CGFloat const kUD320CellTextContentWidth = 180.0;
/** 商品消息width */
static CGFloat const kUDChatCellProductImageWidth = 60;
/** 商品消息height */
static CGFloat const kUDChatCellProductImageHeight = 60;
/** 小程序卡片消息width */
static CGFloat const kUDChatCellMiniProgramCardWidth = 230;
/** 小程序卡片消息图片width */
static CGFloat const kUDChatCellMiniProgramCardImageWidth = 210;
/** 小程序卡片消息图片height */
static CGFloat const kUDChatCellMiniProgramCardImageHeight = 176;
/** 小程序卡片消息间距 */
static CGFloat const kUDChatCellMiniProgramToHorizontalEdgeSpacing = 10.0;
/** 消息状态距离气泡垂直距离 */
static CGFloat const kUDChatCellMiniProgramToVerticalEdgeSpacing = 16.0;
/** 视频客服商品图片宽度 */
static CGFloat const kUDChatMessageProductV2ImageWidth = 220.0;
/** 视频客服商品图片高度 */
static CGFloat const kUDChatMessageProductV2ImageHeight = 100.0;
/** 系统左右分别留空 */
static CGFloat const kUDChatMessageSystemLabelMargin = 25.0;

/** 表单图标height */
static CGFloat const kUDChatCellFormIconHeight = 38;
/** 表单图标左右前后margin */
static CGFloat const kUDChatCellFormIconMargin = 8;
/** 链接 */
static NSString const *kUDLinkURLName = @"url";
/** 号码 */
static NSString const *kUDNumberName = @"number";
/** 字体 */
static NSString *kUDTextFontName = @"Heiti SC";

#endif /* ChatLayout_h */
