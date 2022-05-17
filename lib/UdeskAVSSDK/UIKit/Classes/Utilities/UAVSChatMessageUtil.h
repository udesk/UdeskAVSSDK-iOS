//
//  ChatMessageUtil.h
//  UdeskApp
//
//  Created by xuchen on 2018/1/11.
//  Copyright © 2018年 xushichen. All rights reserved.
//

#import <Foundation/Foundation.h>
 
@class UdeskAVSBaseMessage;

@interface UAVSChatMessageUtil : NSObject

//消息model转layout
+ (NSArray *)chatLayoutWithMessageModel:(NSArray *)array lastMessage:(UdeskAVSBaseMessage *)lastMessage;

@end
