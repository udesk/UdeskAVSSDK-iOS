//
//  ChatDateLayout.h
//  UdeskApp
//
//  Created by xuchen on 2018/1/11.
//  Copyright © 2018年 xushichen. All rights reserved.
//

#import "UAVSChatBaseLayout.h"

@class YYTextLayout;

@interface UAVSChatDateLayout : UAVSChatBaseLayout

@property (nonatomic, strong) YYTextLayout *dateLayout; //提示文本
@property (nonatomic, assign) CGRect dateRect;

@end
