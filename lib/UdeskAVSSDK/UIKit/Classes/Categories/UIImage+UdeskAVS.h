//
//  UIImage+Udesk.h
//  UdeskAVSExample
//
//  Created by 陈历 on 2021/6/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (UdeskAVS)

- (UIImage *)udeskImageByScalingToSize:(CGSize)targetSize;

+ (nullable UIImage *)udavs_imageNamed:(NSString *)name;      // load from UdeskAVSBundle


/** 发送消息气泡图片 */
+ (UIImage *)udBubbleSend01Image;
+ (UIImage *)udBubbleSend02Image;
+ (UIImage *)udBubbleSend03Image;
+ (UIImage *)udBubbleSend04Image;
/** 接收消息气泡图片 */
+ (UIImage *)udBubbleReceive01Image;
+ (UIImage *)udBubbleReceive02Image;
+ (UIImage *)udBubbleReceive03Image;
+ (UIImage *)udBubbleReceive04Image;

/** 客服头像图片 */
+ (UIImage *)udAVSDefaultAgentAvatarImage;
/** 客户头像图片 */
+ (UIImage *)udAVSDefaultCustomerAvatarImage;
/** 默认图片 */
+ (UIImage *)udDefaultLoadingImage;

//拉伸气泡
+ (UIImage *)udBubbleImageWithName:(NSString *)name;

/** 满意度评价关闭按钮 */
+ (UIImage *)udDefaultSurveyCloseImage;

/** 满意度评价表情 满意 */
+ (UIImage *)udDefaultSurveyExpressionSatisfiedImage;

/** 满意度评价表情 不满意 */
+ (UIImage *)udDefaultSurveyExpressionUnsatisfactoryImage;

/** 满意度评价表情 空星 */
+ (UIImage *)udDefaultSurveyStarEmptyImage;

/** 满意度评价表情 实星 */
+ (UIImage *)udDefaultSurveyStarFilledImage;

@end

NS_ASSUME_NONNULL_END
