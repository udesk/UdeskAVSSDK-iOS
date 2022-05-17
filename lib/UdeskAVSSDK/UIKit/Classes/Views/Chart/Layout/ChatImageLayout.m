//
//  ChatImageLayout.m
//  UdeskApp
//
//  Created by xuchen on 2018/1/8.
//  Copyright © 2018年 xushichen. All rights reserved.
//

#import "ChatImageLayout.h"
#import "ChatImageCell.h"

@implementation ChatImageLayout

- (instancetype)initWithMessage:(UdeskAVSBaseMessage *)message dateDisplay:(BOOL)dateDisplay
{
    self = [super initWithMessage:message dateDisplay:dateDisplay];
    if (self) {
        
        [self layoutImageBubbleSize];
        self.height += kUDChatMessageImageHeight;
    }
    return self;
}

- (void)layoutImageBubbleSize {
    
    self.picSize = CGSizeMake(kUDChatMessageImageWidth, kUDChatMessageImageHeight);
    self.image = self.message.image;
    self.bubbleSize = CGSizeMake(kUDChatMessageImageWidth, kUDChatMessageImageHeight);
}

- (UITableViewCell *)getCellWithReuseIdentifier:(NSString *)cellReuseIdentifer {
    
    return [[ChatImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifer];
}

@end
