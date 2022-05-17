//
//  ChatTextLayout.m
//  UdeskApp
//
//  Created by xuchen on 2018/1/8.
//  Copyright © 2018年 xushichen. All rights reserved.
//

#import "ChatTextLayout.h"
#import "ChatTextCell.h"
#import "UdeskAVCSUtil.h"
#import "UIColor+UdeskAVS.h"
#import <YYText/YYText.h>

@interface ChatTextLinePositionModifier()<YYTextLinePositionModifier>

@end


@implementation ChatTextLinePositionModifier

- (instancetype)init {
    self = [super init];
    
    _lineHeightMultiple = 1.34;   // for PingFang SC
    
    return self;
}

- (void)modifyLines:(NSArray *)lines fromText:(NSAttributedString *)text inContainer:(YYTextContainer *)container {
    //CGFloat ascent = _font.ascender;
    CGFloat ascent = _font.pointSize * 0.86;
    
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    for (YYTextLine *line in lines) {
        CGPoint position = line.position;
        position.y = _paddingTop + ascent + line.row  * lineHeight;
        line.position = position;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    ChatTextLinePositionModifier *one = [self.class new];
    one->_font = _font;
    one->_paddingTop = _paddingTop;
    one->_paddingBottom = _paddingBottom;
    one->_lineHeightMultiple = _lineHeightMultiple;
    return one;
}

- (CGFloat)heightForLineCount:(NSUInteger)lineCount {
    if (lineCount == 0) return 0;
    //    CGFloat ascent = _font.ascender;
    //    CGFloat descent = -_font.descender;
    CGFloat ascent = _font.pointSize * 0.86;
    CGFloat descent = _font.pointSize * 0.14;
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    return _paddingTop + _paddingBottom + ascent + descent + (lineCount - 1) * lineHeight;
}

@end

@implementation ChatTextLayout

- (instancetype)initWithMessage:(UdeskAVSBaseMessage *)message dateDisplay:(BOOL)dateDisplay {
    
    self = [super initWithMessage:message dateDisplay:dateDisplay];
    if (self) {
        
        [self _layoutText];
        [self _layoutBubbleSize];
        
        self.height += _textHeight;
        self.height += kUDCellBubbleToTextVerticalSpacing*2;
        
    }
    
    return self;
}

- (void)_layoutText {
    
    _textHeight = 0;
    _textLayout = nil;
    
    NSMutableAttributedString *text = [self _textWithMessage:self.message
                                                   isRetweet:NO
                                                    fontSize:kUDCellTextFontSize
                                                   textColor:[UIColor colorWithRed:0.165f  green:0.165f  blue:0.165f alpha:1]];
    if (text.length == 0 || !text) return;
    
    ChatTextLinePositionModifier *modifier = [ChatTextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:kUDTextFontName size:kUDCellTextFontSize];
    
    CGFloat contentWidth = kScreenWidth > 320 ? kUDCellTextContentWidth : kUD320CellTextContentWidth;
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(contentWidth, HUGE);
    container.linePositionModifier = modifier;
    container.maximumNumberOfRows = 0;
    
    _textLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (!_textLayout) return;
    
    _textHeight = [modifier heightForLineCount:_textLayout.rowCount];
}

- (NSMutableAttributedString *)_textWithMessage:(UdeskAVSBaseMessage *)message
                                      isRetweet:(BOOL)isRetweet
                                       fontSize:(CGFloat)fontSize
                                      textColor:(UIColor *)textColor {
    if (!message) return nil;
    if (!message.content || message.content == (id)kCFNull) return nil;
    if (![message.content isKindOfClass:[NSString class]]) return nil;
    
    NSMutableString *string = message.content.mutableCopy;
    if (string.length == 0) return nil;
    
    // 字体
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    // 高亮状态的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = UIColorHex(bfdffe);
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    text.yy_font = font;
    text.yy_color = textColor;
    
    NSMutableArray *numberRegexs = [[NSMutableArray alloc] initWithArray:@[@"^(\\d{3,4}-?)\\d{7,8}$", @"^1[3|4|5|7|8]\\d{9}", @"[0-9]\\d{4,10}"]];
    NSMutableArray *linkRegexs   = [[NSMutableArray alloc] initWithArray:@[@"[a-zA-z]+://[^\\s]*"]];
    
    // 数字正则匹配
    for (NSString *numberRegex in numberRegexs) {
        NSRange range = [message.content rangeOfString:numberRegex options:NSRegularExpressionSearch];
        if (range.location != NSNotFound) {
            
            if ([text yy_attribute:YYTextHighlightAttributeName atIndex:range.location] == nil) {
                [text yy_setColor:UIColorHex(2782D7) range:range];
                
                // 高亮状态
                YYTextHighlight *highlight = [YYTextHighlight new];
                [highlight setBackgroundBorder:highlightBorder];
                // 数据信息，用于稍后用户点击
                highlight.userInfo = @{kUDNumberName : [message.content substringWithRange:range]};
                [text yy_setTextHighlight:highlight range:range];
            }
        }
    }
    
    // 链接正则匹配
    for (NSString *linkRegex in linkRegexs) {
        NSRange range = [message.content rangeOfString:linkRegex options:NSRegularExpressionSearch];
        if (range.location != NSNotFound) {
            
            if ([text yy_attribute:YYTextHighlightAttributeName atIndex:range.location] == nil) {
                [text yy_setColor:UIColorHex(2782D7) range:range];
                
                // 高亮状态
                YYTextHighlight *highlight = [YYTextHighlight new];
                [highlight setBackgroundBorder:highlightBorder];
                // 数据信息，用于稍后用户点击
                highlight.userInfo = @{kUDLinkURLName : [message.content substringWithRange:range]};
                [text yy_setTextHighlight:highlight range:range];
            }
        }
    }
    
    return text;
}

- (void)_layoutBubbleSize {
    
    CGFloat textBubbleWidth = self.textLayout.textBoundingSize.width+(kUDCellBubbleToTextHorizontalSpacing*2);
    CGFloat textBubbleHeight = self.textLayout.textBoundingSize.height+(kUDCellBubbleToTextVerticalSpacing*2);
    
    self.bubbleSize = CGSizeMake(textBubbleWidth, textBubbleHeight);
}

- (UITableViewCell *)getCellWithReuseIdentifier:(NSString *)cellReuseIdentifer {
    
    return [[ChatTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifer];
}

@end
