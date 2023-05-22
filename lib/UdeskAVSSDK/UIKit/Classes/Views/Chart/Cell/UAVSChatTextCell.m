//
//  ChatTextCell.m
//  UdeskApp
//
//  Created by xuchen on 2018/1/8.
//  Copyright © 2018年 xushichen. All rights reserved.
//

#import "UAVSChatTextCell.h"
#import "UAVSChatTextLayout.h"
#import "UdeskProjectHeader.h"
#import "UIImage+UdeskAVS.h"
#import <YYText/YYText.h>

@implementation UAVSChatTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setBaseLayout:(UAVSChatBaseLayout *)baseLayout {
    [super setBaseLayout:baseLayout];
    
    UAVSChatTextLayout *textLayout = (UAVSChatTextLayout *)baseLayout;
    if (!textLayout || ![textLayout isKindOfClass:[UAVSChatTextLayout class]]) return;
    
    //文本
    if (textLayout.textLayout) {
        self.textContentLabel.textLayout = textLayout.textLayout;
        self.textContentLabel.size = textLayout.textLayout.textBoundingSize;
    }
    
    switch (textLayout.message.fromType) {
        case UdeskAVSMessageFromTypeAgent:
        case UdeskAVSMessageFromTypeSystem:
        {
            
            CGFloat bubbleX = kUAVSCellAvatarToHorizontalEdgeSpacing+kUAVSCellAvatarDiameter+kUAVSCellAvatarToBubbleSpacing;

            self.bubbleImageView.frame = CGRectMake(bubbleX, textLayout.height-textLayout.bubbleSize.height, textLayout.bubbleSize.width, textLayout.bubbleSize.height);
            self.bubbleImageView.image = [UIImage  udBubbleImageWithName:@"uDChatBubble_Receiving_Solid"];
            //文本位置
            self.textContentLabel.origin = CGPointMake(kUAVSCellBubbleToTextHorizontalSpacing, kUAVSCellBubbleToTextVerticalSpacing);
            
            break;
        }
        case UdeskAVSMessageFromTypeCustomer:{
            CGFloat bubbleX = UD_SCREEN_WIDTH -kUAVSCellAvatarToBubbleSpacing-textLayout.bubbleSize.width;
            CGFloat bubbleY = textLayout.height-textLayout.bubbleSize.height;
//            if (textLayout.message.sendStatus == UDMessageSendStatusRollback ||
//               textLayout.message.sendStatus == UDMessageSendStatusOffSending) {
//                bubbleY = bubbleY-kUAVSChatMessageStatusHeight-kUAVSChatMessageStatusToVerticalEdgeSpacing;
//            }
            
            //气泡位置
            self.bubbleImageView.frame = CGRectMake(bubbleX, bubbleY, textLayout.bubbleSize.width, textLayout.bubbleSize.height);
            self.bubbleImageView.image = [UIImage udBubbleImageWithName:@"uDChatBubble_Sending_Solid"];
            
            //文本位置
            self.textContentLabel.origin = CGPointMake(kUAVSCellBubbleToTextHorizontalSpacing, kUAVSCellBubbleToTextVerticalSpacing);
            
//            //菊花和重发
//            [self updateMsgStatus:textLayout.message.sendStatus];
            
            break;
        }
            
        default:
            break;
    }
}

- (YYLabel *)textContentLabel {
    if (!_textContentLabel) {
        UDWeakSelf;
        _textContentLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
        _textContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _textContentLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        _textContentLabel.displaysAsynchronously = YES;
        _textContentLabel.ignoreCommonProperties = YES;
        _textContentLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            [weakSelf openTextLink:(YYLabel *)containerView textRange:range];
        };
        [self.bubbleImageView addSubview:_textContentLabel];
    }
    return _textContentLabel;
}
//
//打开label的链接
- (void)openTextLink:(YYLabel *)label textRange:(NSRange)textRange {
    
    NSAttributedString *text = label.textLayout.text;
    if (textRange.location >= text.length) return;
    YYTextHighlight *highlight = [text yy_attribute:YYTextHighlightAttributeName atIndex:textRange.location];
    NSDictionary *info = highlight.userInfo;
    if (info.count == 0) return;
    
    if (info[kUAVSLinkURLName]) {
        
        NSString *url = info[kUAVSLinkURLName];
        if ([text.string rangeOfString:@"://"].location == NSNotFound) {
            url = [NSString stringWithFormat:@"http://%@",text.string];
        }
        
        if (url.length && ![NSURL URLWithString:url]) {
            url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        return;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
