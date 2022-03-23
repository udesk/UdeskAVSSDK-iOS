//
//  UIImage+Udesk.h
//  UdeskAVSExample
//
//  Created by 陈历 on 2021/6/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Udesk)

- (UIImage *)udeskImageByScalingToSize:(CGSize)targetSize;

+ (nullable UIImage *)udavs_imageNamed:(NSString *)name;      // load from UdeskAVSBundle

@end

NS_ASSUME_NONNULL_END
