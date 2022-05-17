//
//  VideoCallUIManager.h
//  UdeskApp
//
//  Created by 陈历 on 2020/4/3.
//  Copyright © 2020 xushichen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ChatBaseLayout;
@class UdeskAVSBaseMessage;
@class UdeskAVSAgentInfo;

@interface VideoCallUIManager : NSObject

@property (nonatomic, strong) NSNumber *roomId;

@property (nonatomic, strong) UdeskAVSAgentInfo *agent;


@property (nonatomic, strong) NSMutableArray <ChatBaseLayout *> *showMessageList;
//这个数组用来保存保存历史消息
@property (nonatomic, strong) NSMutableArray <ChatBaseLayout *> *historyMessageList;
//这个数组用来保存正在聊天时的消息
@property (nonatomic, strong) NSMutableArray <ChatBaseLayout *> *currentMessageList;


- (void)addMessage:(UdeskAVSBaseMessage *)message completion:(void(^)(void))completion;

- (NSMutableArray *)filterMessage;

//视频中使用，拉取这个客户的聊天记录,包括上次视频的聊天记录
- (void)getLatestMessage:(void(^)(BOOL hasMore))completion;

- (void)getNextPageMessage:(void(^)(BOOL hasMore))completion;

- (void)updateAgent:(UdeskAVSAgentInfo *)agent;

@end

NS_ASSUME_NONNULL_END
