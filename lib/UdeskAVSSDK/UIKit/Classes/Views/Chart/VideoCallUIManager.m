//
//  VideoCallUIManager.m
//  UdeskApp
//
//  Created by 陈历 on 2020/4/3.
//  Copyright © 2020 xushichen. All rights reserved.
//

#import "VideoCallUIManager.h"
#import "UdeskAVSMessageManager.h"
#import "UAVSChatMessageUtil.h"
#import "UAVSChatTextLayout.h"
#import "UAVSChatImageLayout.h"
#import "UdeskProjectHeader.h"


@implementation VideoCallUIManager

- (void)changeMessageToLayout:(NSArray *)msgsArray block:(void(^)(NSArray *layouts))block{
    
    NSArray *layouts =  [UAVSChatMessageUtil chatLayoutWithMessageModel:msgsArray lastMessage:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (block) {
            block(layouts);
        }
    });
}

- (void)doSomethingDefault:(NSArray *)layouts{
    [layouts enumerateObjectsUsingBlock:^(UAVSChatBaseLayout *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.message.agentAvtarUrl = self.agent.avatar;
    }];
}

//视频中，获取用户聊天记录
- (void)getLatestMessage:(void(^)(BOOL hasMore))completion{
    [UdeskAVSMessageManager getCustomMessageList:nil
                                       completion:^(NSError * _Nonnull error, NSArray * _Nonnull messages, BOOL hasMore) {
        if (error) {
            return;
        }
        if (messages) {
            self.historyMessageList = [NSMutableArray arrayWithArray:messages];
            //重新排序
            [self.historyMessageList sortUsingComparator:^NSComparisonResult(UdeskAVSBaseMessage *obj1, UdeskAVSBaseMessage *obj2) {
                return obj1.messageId.intValue > obj2.messageId.intValue;
            }];
            
            //转换成 BaseLayout
            [self changeMessageToLayout:self.historyMessageList
                                  block:^(NSArray *layouts) {
                self.showMessageList = [NSMutableArray arrayWithArray:layouts];
                [self.showMessageList addObjectsFromArray:self.currentMessageList];
                [self doSomethingDefault:layouts];
                
                if (completion) {
                    completion(hasMore);
                }
            }];
        }
    }];
}

- (void)getNextPageMessage:(void(^)(BOOL hasMore))completion{
    NSString *lastId = [self findLastMessageId];
    [UdeskAVSMessageManager getCustomMessageList:lastId
                                       completion:^(NSError * _Nonnull error, NSArray * _Nonnull messages, BOOL hasMore) {
        if (error) {
            return;
        }
        NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:self.historyMessageList];
        if (messages.count > 0) {
            for (UdeskAVSBaseMessage *msg in messages){
                //去重
                if (msg.messageId && ![self checkMessageExist:msg inArray:tmpArray]) {
                    [tmpArray addObject:msg];
                }
            }
        }
        //重新排序
        [tmpArray sortUsingComparator:^NSComparisonResult(UdeskAVSBaseMessage *obj1, UdeskAVSBaseMessage *obj2) {
            return obj1.messageId.intValue > obj2.messageId.intValue;
        }];
        
        self.historyMessageList = [NSMutableArray arrayWithArray:tmpArray];
        
        //转换成 BaseLayout
        [self changeMessageToLayout:tmpArray
                              block:^(NSArray *layouts) {
            self.showMessageList = [NSMutableArray arrayWithArray:layouts];
            [self.showMessageList addObjectsFromArray:self.currentMessageList];
            [self doSomethingDefault:layouts];
            if (completion) {
                completion(hasMore);
            }
        }];
    }];
}
//获取最后一个消息对象Id
- (NSString *)findLastMessageId{
    if (self.historyMessageList.count > 0) {
        UdeskAVSBaseMessage *msg = (UdeskAVSBaseMessage *)self.historyMessageList.firstObject;
        return msg.messageId;
    }
    
    return nil;
}
- (BOOL)checkMessageExist:(UdeskAVSBaseMessage *)msg inArray:(NSArray *)array{
    for (UdeskAVSBaseMessage *m in array) {
        if (m.messageId && msg.messageId && [m.messageId integerValue] == [msg.messageId integerValue]) {
            return YES;
        }
    }
    return NO;
}

//获取最后一个消息对象
- (UdeskAVSBaseMessage *)getLastMessage {
    @try {
        UdeskAVSBaseMessage *lastMessage;
        if (self.showMessageList.count && [self.showMessageList.lastObject isKindOfClass:[UAVSChatBaseLayout class]]) {
            UAVSChatBaseLayout *baseMessage = (UAVSChatBaseLayout *)self.showMessageList.lastObject;
            lastMessage = baseMessage.message;
        }
        return lastMessage;
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
    }
}

- (void)addMessage:(UdeskAVSBaseMessage *)message completion:(void(^)(void))completion{
    
    if (!message || message == (id)kCFNull) return;
    message.agentAvtarUrl = self.agent.avatar;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = [UAVSChatMessageUtil chatLayoutWithMessageModel:@[message] lastMessage:[self getLastMessage]];
        if (array && array.count) {
            NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:self.currentMessageList];
            [tmpArray addObjectsFromArray:array];
            self.currentMessageList = tmpArray;
            [self.showMessageList addObjectsFromArray:array];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion();
                }
            });
        }
    });   
}

- (NSMutableArray *)showMessageList{
    if (!_showMessageList) {
        _showMessageList = [NSMutableArray arrayWithCapacity:0];
    }
    return _showMessageList;
}

- (NSMutableArray *)filterMessage{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (UAVSChatBaseLayout *layout in self.showMessageList) {
        if (
            //[layout isKindOfClass:[ChatFormLayout class]] ||
            [layout isKindOfClass:[UAVSChatImageLayout class]] ||
            //[layout isKindOfClass:[ChatRichLayout class]] ||
            [layout isKindOfClass:[UAVSChatTextLayout class]]
            //[layout isKindOfClass:[ChatProductV2Layout class]] ||
            //[layout isKindOfClass:[ChatStoreLayout class]] ||
            //[layout isKindOfClass:[ChatSystemLayout class]]
            )
            {
            [array addObject:layout];
        }
    }
    return array;
}

- (void)updateAgent:(UdeskAVSAgentInfo *)agent
{
    self.agent = agent;
    [self doSomethingDefault:self.currentMessageList];
}
@end
