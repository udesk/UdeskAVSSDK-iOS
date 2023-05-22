//
//  ChatTextLayout.h
//  UdeskApp
//
//  Created by xuchen on 2018/1/8.
//  Copyright © 2018年 xushichen. All rights reserved.
//

#import "UAVSChatBaseLayout.h"

@class YYTextLayout;
/**
 文本 Line 位置修改
 将每行文本的高度和位置固定下来，不受中英文/Emoji字体的 ascent/descent 影响
 */

@interface UAVSChatTextLinePositionModifier : NSObject

@property (nonatomic, strong) UIFont  *font; // 基准字体 (例如 Heiti SC/PingFang SC)
@property (nonatomic, assign) CGFloat paddingTop; //文本顶部留白
@property (nonatomic, assign) CGFloat paddingBottom; //文本底部留白
@property (nonatomic, assign) CGFloat lineHeightMultiple; //行距倍数

- (CGFloat)heightForLineCount:(NSUInteger)lineCount;

@end

@interface UAVSChatTextLayout : UAVSChatBaseLayout

// 文本
@property (nonatomic, assign) CGFloat textHeight; //文本高度(包括下方留白)
@property (nonatomic, strong) YYTextLayout *textLayout; //文本

@end

