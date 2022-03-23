//
//  UdeskAVSBaseLayout.h
//  UdeskAvsSDKDemo
//
//  Created by 陈历 on 2021/6/2.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UITableViewCell;
@class UdeskAVSBaseMessage;

@interface UdeskAVSBaseLayout : NSObject

// 以下是数据
@property (nonatomic, strong) UdeskAVSBaseMessage *message;
// 消息ID
@property (nonatomic, copy  ) NSString *messageId;
//是否显示时间
@property (nonatomic, assign) BOOL dateDisplay;
// 头像
@property (nonatomic, assign) CGRect avatarFrame;
// 气泡
@property (nonatomic, assign) CGRect bubleFrame;
// 总高度
@property (nonatomic, assign) CGFloat height;

- (instancetype)initWithMessage:(UdeskAVSBaseMessage *)message dateDisplay:(BOOL)dateDisplay;


- (UITableViewCell *)getCellWithReuseIdentifier:(NSString *)cellReuseIdentifer;

@end

NS_ASSUME_NONNULL_END
