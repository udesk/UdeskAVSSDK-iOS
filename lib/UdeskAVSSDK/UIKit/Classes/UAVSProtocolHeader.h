//
//  UAVSProtocolHeader.h
//  UdeskAVSExample
//
//  Created by Admin on 2022/4/29.
//

#import "UdeskAVSEnumHeader.h"

#ifndef UAVSProtocolHeader_h
#define UAVSProtocolHeader_h


@protocol UAVSRoomToolBarViewDelegate <NSObject>

- (void)doToolBarAction:(UDESK_VIDEO_TOOL_ACTION_TYPE)type;

@end


#endif /* UAVSProtocolHeader_h */

