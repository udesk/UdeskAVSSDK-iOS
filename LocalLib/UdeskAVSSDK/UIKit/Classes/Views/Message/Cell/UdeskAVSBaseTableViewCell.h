//
//  UdeskAVSBaseTableViewCell.h
//  UdeskAvsSDKDemo
//
//  Created by 陈历 on 2021/6/2.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class UdeskAVSBaseLayout;

@interface UdeskAVSBaseTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatorImageView;

@property (nonatomic, strong) UIImageView *bubbleImageView;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UdeskAVSBaseLayout *baseLayout;

@end

NS_ASSUME_NONNULL_END
