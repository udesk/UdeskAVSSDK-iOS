//
//  VideoCallImageSelectView.h
//  UdeskApp
//
//  Created by 陈历 on 2020/4/6.
//  Copyright © 2020 xushichen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol VideoCallImageSelectDelegate <NSObject>

- (void)didSelectImage:(UIImage *)image;

@end

@interface VideoCallImageSelectView : UIView

@property (nonatomic, weak) id <VideoCallImageSelectDelegate> delegate;

- (void)show:(BOOL)value;
- (BOOL)isShowing;

@end

NS_ASSUME_NONNULL_END
