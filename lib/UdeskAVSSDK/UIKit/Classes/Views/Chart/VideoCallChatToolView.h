//
//  VideoCallChatToolView.h
//  UdeskApp
//
//  Created by 陈历 on 2020/4/1.
//  Copyright © 2020 xushichen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UdeskAVSHPGrowingTextView;

NS_ASSUME_NONNULL_BEGIN

@protocol VideoCallChatToolDelegate <NSObject>

- (void)didEndInputText:(NSString *)text;
- (void)didPressMoreButton;
- (void)didChangeHeight:(CGFloat)height;

@end

@interface VideoCallChatToolView : UIView

@property (nonatomic, strong) UdeskAVSHPGrowingTextView *chatTextView;
@property (nonatomic, weak) id <VideoCallChatToolDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
