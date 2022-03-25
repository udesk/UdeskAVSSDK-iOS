//
//  UdeskTRTCRoomView.h
//  UdeskAvsSDKDemo
//
//  Created by 陈历 on 2021/5/28.
//

#import <UIKit/UIKit.h>
#import "UdeskProjectHeader.h"

NS_ASSUME_NONNULL_BEGIN

@class UdeskAVSTRTCRoomInfo;

@interface UdeskTRTCRoomView : UdeskTRTCContextBaseView

- (void)enterRoom:(UdeskAVSTRTCRoomInfo *)info;

@end

NS_ASSUME_NONNULL_END
