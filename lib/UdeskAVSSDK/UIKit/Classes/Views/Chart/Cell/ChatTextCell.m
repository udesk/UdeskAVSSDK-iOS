//
//  ChatTextCell.m
//  UdeskApp
//
//  Created by xuchen on 2018/1/8.
//  Copyright © 2018年 xushichen. All rights reserved.
//

#import "ChatTextCell.h"
#import "ChatTextLayout.h"
#import "UdeskProjectHeader.h"
#import "UIImage+UdeskAVS.h"
#import <YYText/YYText.h>

@implementation ChatTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setBaseLayout:(ChatBaseLayout *)baseLayout {
    [super setBaseLayout:baseLayout];
    
    ChatTextLayout *textLayout = (ChatTextLayout *)baseLayout;
    if (!textLayout || ![textLayout isKindOfClass:[ChatTextLayout class]]) return;
    
    //文本
    if (textLayout.textLayout) {
        self.textContentLabel.textLayout = textLayout.textLayout;
        self.textContentLabel.size = textLayout.textLayout.textBoundingSize;
    }
    
    switch (textLayout.message.fromType) {
        case UdeskAVSMessageFromTypeAgent:
        case UdeskAVSMessageFromTypeSystem:
        {
            
            CGFloat bubbleX = kUDCellAvatarToHorizontalEdgeSpacing+kUDCellAvatarDiameter+kUDCellAvatarToBubbleSpacing;

            self.bubbleImageView.frame = CGRectMake(bubbleX, textLayout.height-textLayout.bubbleSize.height, textLayout.bubbleSize.width, textLayout.bubbleSize.height);
            self.bubbleImageView.image = [UIImage  udBubbleImageWithName:@"uDChatBubble_Receiving_Solid"];
            //文本位置
            self.textContentLabel.origin = CGPointMake(kUDCellBubbleToTextHorizontalSpacing, kUDCellBubbleToTextVerticalSpacing);
            
            break;
        }
        case UdeskAVSMessageFromTypeCustomer:{
            CGFloat bubbleX = UD_SCREEN_WIDTH -kUDCellAvatarToBubbleSpacing-textLayout.bubbleSize.width;
            CGFloat bubbleY = textLayout.height-textLayout.bubbleSize.height;
//            if (textLayout.message.sendStatus == UDMessageSendStatusRollback ||
//               textLayout.message.sendStatus == UDMessageSendStatusOffSending) {
//                bubbleY = bubbleY-kUDChatMessageStatusHeight-kUDChatMessageStatusToVerticalEdgeSpacing;
//            }
            
            //气泡位置
            self.bubbleImageView.frame = CGRectMake(bubbleX, bubbleY, textLayout.bubbleSize.width, textLayout.bubbleSize.height);
            self.bubbleImageView.image = [UIImage udBubbleImageWithName:@"uDChatBubble_Sending_Solid"];
            
            //文本位置
            self.textContentLabel.origin = CGPointMake(kUDCellBubbleToTextHorizontalSpacing, kUDCellBubbleToTextVerticalSpacing);
            
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
    
    if (info[kUDLinkURLName]) {
        
        NSString *url = info[kUDLinkURLName];
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
