//
//  VideoCallInputBottomView.h
//  UdeskApp
//
//  Created by 陈历 on 2020/5/22.
//  Copyright © 2020 xushichen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VideoCallInputBottomButtonType) {
    VideoCallInputBottomButtonTypeImage = 1,
    //VideoCallInputBottomButtonTypeForm,
    //VideoCallInputBottomButtonTypeStores,
    //VideoCallInputBottomButtonTypeProducts
};

typedef void(^UDButtonSelectBlock)(id _Nullable obj);

NS_ASSUME_NONNULL_BEGIN

@interface VideoCallInputBottomView : UIView

@property (nonatomic, copy) UDButtonSelectBlock block;

@end

NS_ASSUME_NONNULL_END
