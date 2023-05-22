//
//  ChatBaseCell.h
//  UdeskApp
//
//  Created by xuchen on 2018/1/8.
//  Copyright © 2018年 xushichen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAVSChatBaseLayout.h"

@class UdeskAVSBaseMessage;
@class YYLabel;

@protocol UAVSChatBaseCellDelegate <NSObject>

/** 点击了头像 */
- (void)didSelectCustomerAvatar;
/** 点击重发 */
- (void)tableViewCell:(UITableViewCell *)cell resendMessage:(UdeskAVSBaseMessage *)resendMessage;
/** 撤回消息 */
- (void)tableViewCell:(UITableViewCell *)cell rollbackMessage:(UdeskAVSBaseMessage *)message;

@end

@interface UAVSChatBaseCell : UITableViewCell

@property (nonatomic, weak) id<UAVSChatBaseCellDelegate> chatDelegate;

/** 客户头像 */
@property (nonatomic, strong) UIButton *avatarButton;
/** 气泡 */
@property (nonatomic, strong) UIImageView *bubbleImageView;
/** loading */
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
/** 重发 */
@property (nonatomic, strong) UIButton *resetButton;
/** 消息状态 */
@property (nonatomic, strong) YYLabel *msgStatusLabel;
/** 布局 */
@property (nonatomic, strong) UAVSChatBaseLayout  *baseLayout;
/** 是否是历史会话（用于是否添加撤回功能） */
@property (nonatomic, assign) BOOL isHistory;

////更新消息状态
//- (void)updateMsgStatus:(UDMessageSendStatus)msgStatus;

@end
