//
//  UdeskAVSMessageManager.h
//  UdeskAVSExample
//
//  Created by Admin on 2022/4/26.
//

#import <Foundation/Foundation.h>
#import "UdeskAVSBaseMessage.h"

@protocol UdeskAVSBaseMessageDelegate <NSObject>

/**收到消息*/
- (void)uavs_messageArrived:(UdeskAVSBaseMessage *)message;

@optional
/**消息发送状态更新*/
- (void)uavs_messageSendStatusChange:(UdeskAVSBaseMessage *)message;

@end

@interface UdeskAVSMessageManager : NSObject

+ (instancetype)sharedInstance;

+ (void)getCustomMessageList:(NSString *)lastId
                  completion:(void(^)(NSError *error, NSArray<UdeskAVSBaseMessage *> *messages, BOOL hasMore))completion;

- (void)registerDelgate:(id<UdeskAVSBaseMessageDelegate>)delegate;

#pragma mark - 发送消息
- (UdeskAVSBaseMessage *)sendText:(NSString *)text;

- (UdeskAVSBaseMessage *)sendImage:(UIImage *)image;

@end

#pragma - private
@interface UdeskAVSMessageManager(SDK)

- (void)reciveNewMsg:(id)msg;


@end

