//
//  ChatDateLayout.h
//  UdeskApp
//
//  Created by xuchen on 2018/1/11.
//  Copyright © 2018年 xushichen. All rights reserved.
//

#import "ChatBaseLayout.h"

@class YYTextLayout;

@interface ChatDateLayout : ChatBaseLayout

@property (nonatomic, strong) YYTextLayout *dateLayout; //提示文本
@property (nonatomic, assign) CGRect dateRect;

@end
