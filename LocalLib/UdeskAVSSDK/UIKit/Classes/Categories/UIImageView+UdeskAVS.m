//
//  UIImageView+UdeskAVS.m
//  UdeskAVSExample
//
//  Created by 陈历 on 2021/6/7.
//

#import "UIImageView+UdeskAVS.h"

#if __has_include(<SDWebImage/SDWebImage.h>)
    #define Udesk_SUPPORT_SD 1
#import <SDWebImage/SDWebImage.h>
#else
    #define Udesk_SUPPORT_SD 0
#endif


@implementation UIImageView (UdeskAVS)

- (void)ud_setImageWithURL:(nullable NSURL *)url{
#if Udesk_SUPPORT_SD
    [self sd_setImageWithURL:url];
#endif
}

@end
