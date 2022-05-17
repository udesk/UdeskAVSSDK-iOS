//
//  ChatImageCell.m
//  UdeskApp
//
//  Created by xuchen on 2018/1/8.
//  Copyright © 2018年 xushichen. All rights reserved.
//

#import "ChatImageCell.h"
#import "ChatImageLayout.h"
#import "UAVSPhotoManager.h"
#import "UIView+UdeskAVS.h"
#import "UIImageView+UAVS_YYWebImage.h"
#import "UIImage+UdeskAVS.h"
#import "UdeskAVCSUtil.h"

@implementation ChatImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UAVS_YYAnimatedImageView *)chatImageView {
    if (!_chatImageView) {
        _chatImageView = [UAVS_YYAnimatedImageView new];
        _chatImageView.userInteractionEnabled = YES;
        _chatImageView.layer.cornerRadius = 5;
        _chatImageView.layer.masksToBounds  = YES;
        _chatImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.bubbleImageView addSubview:_chatImageView];
        //添加图片点击手势
        UITapGestureRecognizer *tapContentImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapChatImageViewAction)];
        [_chatImageView addGestureRecognizer:tapContentImage];
    }
    return _chatImageView;
}

- (void)tapChatImageViewAction {
    
    UAVSPhotoManager *photoManeger = [UAVSPhotoManager maneger];
    if (self.chatImageView && self.baseLayout.message.content) {
        NSString *url = self.baseLayout.message.content;
        [photoManeger showLocalPhoto:self.chatImageView withMessageURL:url];
    }
}

- (void)setBaseLayout:(ChatBaseLayout *)baseLayout {
    [super setBaseLayout:baseLayout];
    
    ChatImageLayout *imageLayout = (ChatImageLayout *)baseLayout;
    if (!imageLayout || ![imageLayout isKindOfClass:[ChatImageLayout class]]) return;
    
    //设置消息图片
    self.chatImageView.size = imageLayout.picSize;
    if (imageLayout.image) {
        self.chatImageView.image = imageLayout.image;
    }
    else {
        NSArray *array = [imageLayout.message.content componentsSeparatedByString:@"?"];
        if (array && array.count && array.firstObject) {
            NSString *url = (NSString *)array.firstObject;
            NSString *property = (NSString *)array.lastObject;
            url = [NSString stringWithFormat:@"%@?%@",url,property];
            NSString *imageUrl = [UdeskAVCSUtil urlStringEscapedEncode:url];
            [self.chatImageView uavs_yy_setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:nil];
            
        }
    }
    
    switch (imageLayout.message.fromType) {
        case UdeskAVSMessageFromTypeAgent:
        case UdeskAVSMessageFromTypeSystem:
        {
            CGFloat bubbleX = kUDCellAvatarToHorizontalEdgeSpacing+kUDCellAvatarDiameter+kUDCellAvatarToBubbleSpacing;
            
            //气泡位置
            self.bubbleImageView.frame = CGRectMake(bubbleX, imageLayout.height-imageLayout.bubbleSize.height, imageLayout.bubbleSize.width, imageLayout.bubbleSize.height);
            self.bubbleImageView.image = [UIImage udBubbleImageWithName:@"uDChatBubble_Receiving_Solid"];
            
            //图片位置
            self.chatImageView.origin = CGPointMake(0, 0);
            
            break;
        }
        case UdeskAVSMessageFromTypeCustomer:
        {
            CGFloat bubbleX = kScreenWidth-kUDCellAvatarToBubbleSpacing-imageLayout.bubbleSize.width;
            CGFloat bubbleY = imageLayout.height-imageLayout.bubbleSize.height;
//            if (imageLayout.message.sendStatus == UDMessageSendStatusRollback ||
//                imageLayout.message.sendStatus == UDMessageSendStatusOffSending) {
//                bubbleY = bubbleY-kUDChatMessageStatusHeight-kUDChatMessageStatusToVerticalEdgeSpacing;
//            }
            
            //气泡位置
            self.bubbleImageView.frame = CGRectMake(bubbleX, bubbleY, imageLayout.bubbleSize.width, imageLayout.bubbleSize.height);
            self.bubbleImageView.image = [UIImage udBubbleImageWithName:@"uDChatBubble_Sending_Solid"];
            
            //图片位置
            self.chatImageView.origin = CGPointMake(0, 0);
            
//            //菊花和重发
//            [self updateMsgStatus:imageLayout.message.sendStatus];
            
            break;
        }
            
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
