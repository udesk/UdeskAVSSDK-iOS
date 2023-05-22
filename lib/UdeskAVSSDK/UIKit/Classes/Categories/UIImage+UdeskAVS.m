//
//  UIImage+Udesk.m
//  UdeskAVSExample
//
//  Created by 陈历 on 2021/6/4.
//

#import "UIImage+UdeskAVS.h"
#import "UdeskAVSBundleUtils.h"

@implementation UIImage (UdeskAVS)

- (UIImage *)udeskImageByScalingToSize:(CGSize)targetSize{
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    // this is actually the interesting part:
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    return newImage ;
    
}

+ (nullable UIImage *)udavs_imageNamed:(NSString *)name;
{
    return [UdeskAVSBundleUtils bundleImageNamed:name];
}

+ (UIImage *)udBubbleSend01Image {
    
    return [UIImage udavs_imageNamed:@"udChatBubbleSendingSolid01"];
}

+ (UIImage *)udBubbleReceive01Image {
    
    return [UIImage udavs_imageNamed:@"udChatBubbleReceivingSolid01"];
}

+ (UIImage *)udBubbleSend02Image {
    
    return [UIImage udavs_imageNamed:@"udChatBubbleSendingSolid02"];
}

+ (UIImage *)udBubbleReceive02Image {
    
    return [UIImage udavs_imageNamed:@"udChatBubbleReceivingSolid02"];
}

+ (UIImage *)udBubbleSend03Image {
    
    return [UIImage udavs_imageNamed:@"udChatBubbleSendingSolid03"];
}

+ (UIImage *)udBubbleReceive03Image {
    
    return [UIImage udavs_imageNamed:@"udChatBubbleReceivingSolid03"];
}

+ (UIImage *)udBubbleSend04Image {
    
    return [UIImage udavs_imageNamed:@"udChatBubbleSendingSolid04"];
}

+ (UIImage *)udBubbleReceive04Image {
    
    return [UIImage udavs_imageNamed:@"udChatBubbleReceivingSolid04"];
}

+ (UIImage *)udAVSDefaultAgentAvatarImage {
    
    return [UIImage udavs_imageNamed:@"udAgentAvatar"];
}

+ (UIImage *)udAVSDefaultCustomerAvatarImage {
    return [UIImage udavs_imageNamed:@"customer"];
    //return [UIImage udavs_imageNamed:@"udCustomerAvatar"];
}

/** 默认图片 */
+ (UIImage *)udDefaultLoadingImage {
    return [UIImage udavs_imageNamed:@"udImageLoading"];
}

//拉伸气泡
+ (UIImage *)udBubbleImageWithName:(NSString *)name {
    
    UIImage *bublleImage = [UIImage udavs_imageNamed:name];
    UIEdgeInsets bubbleImageEdgeInsets = UIEdgeInsetsMake(30, 28, 80, 28);
    UIImage *edgeBubbleImage = [bublleImage resizableImageWithCapInsets:bubbleImageEdgeInsets resizingMode:UIImageResizingModeStretch];
    return edgeBubbleImage;
}



/** 满意度评价关闭按钮 */
+ (UIImage *)udDefaultSurveyCloseImage {
    return [UIImage udavs_imageNamed:(@"udSurveyClose.png")];
}

/** 满意度评价表情 满意 */
+ (UIImage *)udDefaultSurveyExpressionSatisfiedImage {
    return [UIImage udavs_imageNamed:(@"udesk_avs_statify_checked.png")];
}

/** 满意度评价表情 不满意 */
+ (UIImage *)udDefaultSurveyExpressionUnsatisfactoryImage {
    return [UIImage udavs_imageNamed:(@"udesk_avs_unstatify_checked.png")];
}

/** 满意度评价表情 空星 */
+ (UIImage *)udDefaultSurveyStarEmptyImage {
    return [UIImage udavs_imageNamed:(@"udSurveyStarEmpty.png")];
}

/** 满意度评价表情 实星 */
+ (UIImage *)udDefaultSurveyStarFilledImage {
    return [UIImage udavs_imageNamed:(@"udSurveyStarFilled.png")];
}


@end
