//
//  ChatBaseLayout.m
//  UdeskApp
//
//  Created by xuchen on 2018/1/8.
//  Copyright © 2018年 xushichen. All rights reserved.
//

#import "ChatBaseLayout.h"
#import "ChatBaseCell.h"

@implementation ChatBaseLayout

- (instancetype)initWithMessage:(UdeskAVSBaseMessage *)message dateDisplay:(BOOL)dateDisplay
{
    self = [super init];
    if (self) {
        _message = message;
        _messageId = message.messageId;
        _dateDisplay = dateDisplay;
        [self defaultLayout];
    }
    return self;
}

- (void)defaultLayout {

    [self _layoutAvatar];
    
    if (self.message.fromType != UdeskAVSMessageFromTypeSystem) {
        _height += kUDCellBottomMargin;
    }
    
    if (!_dateDisplay) {
        _height -= kUDCellBottomMargin;
        _height += kUDCellContinuousBottomMargin;
    }
    
    if (self.message.fromType == UdeskAVSMessageFromTypeAgent) {
//        if (self.message.sendStatus == UDMessageSendStatusRollback ||
//            self.message.sendStatus == UDMessageSendStatusOffSending) {
//            self.height += kUDChatMessageStatusHeight;
//            self.height += kUDChatMessageStatusToVerticalEdgeSpacing;
//        }
    }
}

//头像
- (void)_layoutAvatar {
    //只有客服才有头像
    if (self.message.fromType == UdeskAVSMessageFromTypeAgent && _dateDisplay) {
        //头像的frame
        _avatarFrame = CGRectMake(kUDCellAvatarToHorizontalEdgeSpacing, kUDCellAvatarToVerticalEdgeSpacing, kUDCellAvatarDiameter, kUDCellAvatarDiameter);
    }
}

- (UITableViewCell *)getCellWithReuseIdentifier:(NSString *)cellReuseIdentifer {
    return [[ChatBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifer];
}

- (BOOL)isEqualToLayout:(ChatBaseLayout *)layout{
    if (self.message.messageId && layout.message.messageId && [self.message.messageId isEqualToString:layout.message.messageId]) {
        return YES;
    }
    
    if (self.message.messageId && layout.message.messageId && self.message.messageId.integerValue == layout.message.messageId.integerValue) {
        return YES;
    }
    return NO;
}


@end
