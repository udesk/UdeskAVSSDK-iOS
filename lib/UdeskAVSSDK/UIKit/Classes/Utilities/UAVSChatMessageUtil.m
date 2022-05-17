//
//  ChatMessageUtil.m
//  UdeskApp
//
//  Created by xuchen on 2018/1/11.
//  Copyright © 2018年 xushichen. All rights reserved.
//

#import "UAVSChatMessageUtil.h"
#import "ChatTextLayout.h"
#import "ChatImageLayout.h"
#import "ChatDateLayout.h"


@implementation UAVSChatMessageUtil


//消息model转layout
+ (NSArray *)chatLayoutWithMessageModel:(NSArray *)array lastMessage:(UdeskAVSBaseMessage *)lastMessage {
    
    NSMutableArray *msgLayout = [NSMutableArray array];
    
    if (!array || array == (id)kCFNull) return msgLayout;
    if (![array isKindOfClass:[NSArray class]]) return msgLayout;
    
    if (array.count < 1) return msgLayout;
    if (![array.firstObject isKindOfClass:[UdeskAVSBaseMessage class]]) return msgLayout;
    if (!array.firstObject || array.firstObject == (id)kCFNull) return msgLayout;
    
    [array enumerateObjectsUsingBlock:^(UdeskAVSBaseMessage *message, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //检查是否需要显示时间（第一条信息和超过3分钟间隔的显示时间）
        UdeskAVSBaseMessage *previousMessage;
        if (idx>0) {
            previousMessage = [array objectAtIndex:idx-1];
        }
        
        if (!previousMessage && lastMessage) {
            previousMessage = lastMessage;
        }
        
        //时间显示
        BOOL display = [self checkMsgDateDisplayWithModel:previousMessage laterMessage:message atIndex:idx];
        if (display) {
            UdeskAVSBaseMessage *dateMsg = [[UdeskAVSBaseMessage alloc] init];
            dateMsg.timestamp = message.timestamp;
            dateMsg.fromType = UdeskAVSMessageFromTypeSystem;
            ChatDateLayout *dateLayout = [[ChatDateLayout alloc] initWithMessage:dateMsg dateDisplay:display];
            [msgLayout addObject:dateLayout];
        }
        
        switch (message.messageType) {
            case UdeskAVSMessageContentTypeText:{
                ChatTextLayout *textLayout = [[ChatTextLayout alloc] initWithMessage:message dateDisplay:display];
                [msgLayout addObject:textLayout];
                break;
            }
            case UdeskAVSMessageContentTypeImage:{
                ChatImageLayout *imageLayout = [[ChatImageLayout alloc] initWithMessage:message dateDisplay:display];
                [msgLayout addObject:imageLayout];
                break;
            }
            default:
                break;
        }
    }];
    
    return msgLayout;
}

//检查是否需要显示时间
+ (BOOL)checkMsgDateDisplayWithModel:(UdeskAVSBaseMessage *)previousMessage laterMessage:(UdeskAVSBaseMessage *)laterMessage atIndex:(NSUInteger)index {
    @try {
        
        if (index == 0) return YES;
        
        if (!previousMessage || previousMessage == (id)kCFNull) return YES;
        if (!laterMessage || laterMessage == (id)kCFNull) return YES;
        
        /*
         展示时间
         1.消息发送人不同
         2.超过3分钟
         3.事件消息
         */
        
        if (laterMessage.messageType == UdeskAVSMessageContentTypeSurvey) {
            return YES;
        }
        
        NSInteger interval= laterMessage.timestamp - previousMessage.timestamp;
        if(interval>60*3) {
            return YES;
        }
        
        if (laterMessage.fromType != previousMessage.fromType) {
            return YES;
        }
        
//        if (laterMessage.status != previousMessage.status) {
//            return YES;
//        }
        
        return NO;
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
    }
}


@end
