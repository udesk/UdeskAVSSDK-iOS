//
//  UdeskGeneral.m
//  UdeskSDK
//
//  Created by Udesk on 15/12/21.
//  Copyright © 2015年 Udesk. All rights reserved.
//

#import "UAVSStringSizeUtil.h"
#import "UdeskAVSMacroHeader.h"
#import "UdeskAVSUtil.h"

@implementation UAVSStringSizeUtil

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font size:(CGSize)size {

    CGSize newSize = CGSizeMake(50, 50);
    
    if (![UdeskAVSUtil isBlankString:text]) {
        
        if (font) {
            CGRect stringRect = [text boundingRectWithSize:CGSizeMake(size.width, CGFLOAT_MAX)
                                                   options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                attributes:@{ NSFontAttributeName : font }
                                                   context:nil];
            
            CGSize stringSize = CGRectIntegral(stringRect).size;
            
            newSize = stringSize;
        }
    }
    
    return newSize;
}

+ (CGSize)sizeWithAttributedText:(NSAttributedString *)attributedText size:(CGSize)size {
    
    if ([UdeskAVSUtil isBlankString:attributedText.string]) {
        return CGSizeMake(100, 50);
    }
    
    CGSize constraint = CGSizeMake(size.width , size.height);
    
    CGRect stringRect = [attributedText boundingRectWithSize:constraint
                                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                     context:nil];
    
    stringRect.size.height = stringRect.size.height < 30 ? stringRect.size.height = 20 : stringRect.size.height;
    stringRect.size.width = stringRect.size.width < 25 ? 25 : stringRect.size.width;
    
    return CGSizeMake(stringRect.size.width, stringRect.size.height+2);
}

+ (CGFloat)getHeightForAttributedText:(NSAttributedString *)attributedText textWidth:(CGFloat)textWidth {
    
    CGSize constraint = CGSizeMake(textWidth , CGFLOAT_MAX);
    CGSize title_size;
    CGFloat totalHeight;
    title_size = [attributedText boundingRectWithSize:constraint
                                              options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                              context:nil].size;
    
    totalHeight = ceil(title_size.height);
    
    return totalHeight;
}

@end
