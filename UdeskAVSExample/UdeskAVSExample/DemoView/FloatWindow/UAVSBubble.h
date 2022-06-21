//
//  DGBubble.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "UAVSWindow.h"

@interface UAVSBubble : UAVSWindow

/// 内容视图
@property (nonatomic, weak, readonly) UIView *contentView;
/// 默认 button
@property (nonatomic, weak, readonly) UIButton *button;

@property (nonatomic, copy) void(^clickBlock)(UAVSBubble *bubble);
@property (nonatomic, copy) void(^longPressEndBlock)(UAVSBubble *bubble);
@property (nonatomic, copy) void(^panStartBlock)(UAVSBubble *bubble);
@property (nonatomic, copy) void(^panEndBlock)(UAVSBubble *bubble);

/// 显示
- (void)show;

/// 销毁
- (void)removeFromScreen;

@end


