//
//  ChatBaseLayout.h
//  UdeskApp
//
//  Created by xuchen on 2018/1/8.
//  Copyright © 2018年 xushichen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatLayout.h"

@interface ChatBaseLayout : NSObject

- (instancetype)initWithMessage:(UdeskAVSBaseMessage *)message dateDisplay:(BOOL)dateDisplay;

// 以下是数据
@property (nonatomic, strong) UdeskAVSBaseMessage *message;
// 消息ID
@property (nonatomic, copy  ) NSString *messageId;

//是否显示时间
@property (nonatomic, assign) BOOL dateDisplay;
// 头像
@property (nonatomic, assign) CGRect avatarFrame;
// 气泡
@property (nonatomic, assign) CGSize bubbleSize;
// 总高度
@property (nonatomic, assign) CGFloat height;

/**
 *  通过重用的名字初始化cell
 *  @return 初始化了一个cell
 */
- (UITableViewCell *)getCellWithReuseIdentifier:(NSString *)cellReuseIdentifer;

/**
 插入消息时防止消息重复，做一下比较
 */
- (BOOL)isEqualToLayout:(ChatBaseLayout *)layout;

@end
