//
//  UdeskTRTCInputView.h
//  UdeskAvsSDKDemo
//
//  Created by 陈历 on 2021/6/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UdeskAVSHPGrowingTextView;

@protocol UdeskTRTCInputViewDelegate  <NSObject>

- (void)didChangeHeight:(CGFloat)height;
- (void)didInputText:(NSString *)text;

@end

@interface UdeskTRTCInputView : UIView

@property (nonatomic, weak) id <UdeskTRTCInputViewDelegate>delegate;

@property (nonatomic, strong) UdeskAVSHPGrowingTextView *growingTextView;

@end

NS_ASSUME_NONNULL_END
