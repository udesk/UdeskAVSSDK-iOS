//
//  UIButton+Udesk.m
//  UdeskApp
//
//  Created by 陈历 on 2020/5/6.
//  Copyright © 2020 xushichen. All rights reserved.
//

#import "UIButton+UdeskAVS.h"
#import "UAVS_YYWebImage.h"

@implementation UIButton (UdeskAVS)

- (void)setImageWithURL:(NSString *)url state:(UIControlState)state{
    [self uavs_yy_setImageWithURL:[NSURL URLWithString:url] forState:state options:(UAVS_YYWebImageOptionHandleCookies | UAVS_YYWebImageOptionUseNSURLCache)];
}

@end
