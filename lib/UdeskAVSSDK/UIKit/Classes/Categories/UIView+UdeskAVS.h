//
//  UIView+UdeskAVS.h
//  UdeskAvsSDKDemo
//
//  Created by 陈历 on 2021/5/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (UdeskAVS)

@property (nonatomic) CGFloat left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  size;        ///< Shortcut for frame.size.

/**
 *  完全复制一个view
 *
 *  @param view 需要复制的view
 *
 *  @return 复制的view
 */
+ (UIView *)duplicate:(UIView *)view;


- (void)appendBottomBorder;

- (void)appendTopBorder;

- (void)clipsCornerRadius:(CGFloat)radius corner:(UIRectCorner)corner;

- (UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
