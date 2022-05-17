//
//  UdeskTRTCToolView.h
//  UdeskAvsSDKDemo
//
//  Created by 陈历 on 2021/5/29.
//

#import "UdeskTRTCContextBaseView.h"
#import "UAVSProtocolHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface UdeskTRTCToolView : UdeskTRTCContextBaseView

@property (nonatomic, weak)id<UAVSRoomToolBarViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
