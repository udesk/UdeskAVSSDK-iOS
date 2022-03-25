//
//  UdeskTRTCMessageListView.h
//  UdeskAvsSDKDemo
//
//  Created by 陈历 on 2021/5/28.
//

#import <UIKit/UIKit.h>
#import "UdeskProjectHeader.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YYTextKeyboardObserver;

@protocol UdeskTRTCMessageListViewDelegate <NSObject>

- (void)didInputText:(NSString *)text;

@end

@interface UdeskTRTCMessageListView : UdeskTRTCContextBaseView <YYTextKeyboardObserver>

@property (nonatomic, weak) id <UdeskTRTCMessageListViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
