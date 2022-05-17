//
//  UdeskTRTCContextBaseView.m
//  UdeskAvsSDKDemo
//
//  Created by 陈历 on 2021/5/29.
//

#import "UdeskTRTCContextBaseView.h"
#import "UdeskProjectHeader.h"

@implementation UdeskTRTCContextBaseView

- (instancetype)initWithFrame:(CGRect)frame context:(UdeskRoomViewModel *)context{
    if (self = [super initWithFrame:frame]) {
        _context = context;
    }
    return self;
}

- (void)addObservers:(NSArray *)keyPaths{
    if (!keyPaths || ![keyPaths isKindOfClass:[NSArray class]]) {
        return;
    }
    
    for (NSString *kp in keyPaths) {
        [self.context addObserver:self forKeyPath:kp options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(zoomMode))]) {
        NSNumber *newValue = change[@"new"];
        [self zoomModeChanged:newValue];
    }
    else if ([keyPath isEqualToString:NSStringFromSelector(@selector(isChatShowing))]) {
        NSNumber *newValue = change[@"new"];
        [self showChatChanged:newValue];
    }
    else if ([keyPath isEqualToString:NSStringFromSelector(@selector(messageList))]) {
        NSArray *newValue = change[@"new"];
        [self messageListChanged:newValue];
    }
    else if ([keyPath isEqualToString:NSStringFromSelector(@selector(mute))]) {
        NSNumber *newValue = change[@"new"];
        [self muteChanged:newValue];
    }
    else if ([keyPath isEqualToString:NSStringFromSelector(@selector(stopVideo))]) {
        NSNumber *newValue = change[@"new"];
        [self stopVideoChanged:newValue];
    }
    else if ([keyPath isEqualToString:NSStringFromSelector(@selector(cameraSwitch))]) {
        NSNumber *newValue = change[@"new"];
        [self cameraSwitchChanged:newValue];
    }
    else if ([keyPath isEqualToString:NSStringFromSelector(@selector(agentAvatar))]) {
        NSString *newValue = change[@"new"];
        [self agentAvatarChanged:newValue];
    }
    else if ([keyPath isEqualToString:NSStringFromSelector(@selector(agentName))]) {
        NSString *newValue = change[@"new"];
        [self agentNameChanged:newValue];
    }
    else if ([keyPath isEqualToString:NSStringFromSelector(@selector(isMainFaceSelf))]) {
        NSNumber *newValue = change[@"new"];
        [self mainFaceSelfChanged:newValue];
    }
    NSLog(@"监听到 %@ 的 %@ 改变了 %@", [object class], keyPath, change);
    /* 输出结果：
     监听到 p1 的 age 改变了 {
         kind = 1;
         new = 10;
         old = 1;
     }
     */
}

- (void)zoomModeChanged:(NSNumber *)zoomMode{
    
}

- (void)showChatChanged:(NSNumber *)showchat{
    
}

- (void)messageListChanged:(NSArray *)messageList{
    
}

- (void)muteChanged:(NSNumber *)flag{
    
}

- (void)stopVideoChanged:(NSNumber *)flag{
    
}

- (void)cameraSwitchChanged:(NSNumber *)flag{
    
}

- (void)mainFaceSelfChanged:(NSNumber *)faceMode{
    
}

- (void)agentAvatarChanged:(NSString *)avatar{
    
}

- (void)agentNameChanged:(NSString *)name{
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
