//
//  DGEntrance.h
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UAVSFloatWindowManager : NSObject

@property (nonatomic, copy)dispatch_block_t tapBlock;

+ (instancetype)shared;

// 显示悬浮球
- (void)showBubble;

// 隐藏悬浮球
- (void)hidBubble;

//释放悬浮球
- (void)releaseBubble;


@end

