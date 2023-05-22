//
//  ChatImageLayout.m
//  UdeskApp
//
//  Created by xuchen on 2018/1/8.
//  Copyright © 2018年 xushichen. All rights reserved.
//

#import "UAVSChatImageLayout.h"
#import "UAVSChatImageCell.h"

@implementation UAVSChatImageLayout

- (instancetype)initWithMessage:(UdeskAVSBaseMessage *)message dateDisplay:(BOOL)dateDisplay
{
    self = [super initWithMessage:message dateDisplay:dateDisplay];
    if (self) {
        
        [self layoutImageBubbleSize];
        self.height += kUAVSChatMessageImageHeight;
    }
    return self;
}

- (void)layoutImageBubbleSize {
    
    self.picSize = CGSizeMake(kUAVSChatMessageImageWidth, kUAVSChatMessageImageHeight);
    self.image = self.message.image;
    self.bubbleSize = CGSizeMake(kUAVSChatMessageImageWidth, kUAVSChatMessageImageHeight);
}

- (UITableViewCell *)getCellWithReuseIdentifier:(NSString *)cellReuseIdentifer {
    
    return [[UAVSChatImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifer];
}

@end
