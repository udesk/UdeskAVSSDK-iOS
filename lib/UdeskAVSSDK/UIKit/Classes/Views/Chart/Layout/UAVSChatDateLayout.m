//
//  ChatDateLayout.m
//  UdeskApp
//
//  Created by xuchen on 2018/1/11.
//  Copyright © 2018年 xushichen. All rights reserved.
//

#import "UAVSChatDateLayout.h"
#import "UAVSChatDateCell.h"
#import "UdeskAVSUtil.h"
#import "UdeskAVSDateUtil.h"
#import <YYText/YYText.h>

@implementation UAVSChatDateLayout

- (instancetype)initWithMessage:(UdeskAVSBaseMessage *)message dateDisplay:(BOOL)dateDisplay
{
    self = [super initWithMessage:message dateDisplay:dateDisplay];
    if (self) {
        
        [self setupLayout];
        self.height += kUAVSChatMessageDateCellHeight;
        self.height += kUAVSChatMessageDateLabelToEdgeSpacing*2;
    }
    return self;
}

- (void)setupLayout {
    
    _dateLayout = nil;
    NSString *dateStr = [UdeskAVSDateUtil udStringDateWithTimeInterval:self.message.timestamp];
    if (dateStr.length == 0) return;
    
    NSMutableAttributedString *date = [[NSMutableAttributedString alloc] initWithString:dateStr];
    date.yy_color = [UIColor colorWithRed:0.678f  green:0.678f  blue:0.678f alpha:1];
    date.yy_font = [UIFont systemFontOfSize:kUAVSChatMessageDateLabelFontSize];
    date.yy_backgroundColor = [UIColor clearColor];
    date.yy_alignment = NSTextAlignmentCenter;
    
    CGSize size = CGSizeMake(kScreenWidth, CGFLOAT_MAX);
    _dateLayout = [YYTextLayout layoutWithContainerSize:size text:date];
    
    _dateRect = CGRectMake(0, kUAVSChatMessageDateLabelToEdgeSpacing, kScreenWidth, kUAVSChatMessageDateCellHeight+kUAVSChatMessageDateLabelToEdgeSpacing);
}

- (UITableViewCell *)getCellWithReuseIdentifier:(NSString *)cellReuseIdentifer {
    
    return [[UAVSChatDateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifer];
}

@end
