//
//  LineUtil.h
//  XueXunBao
//
//  Created by Jessica on 2018/4/2.
//  Copyright © 2018年 Wen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, UAVSLineType) {
    UAVSLineTypeNone      = 0,
    UAVSLineTypeTop    = 1 << 0,
    UAVSLineTypeLeft   = 1 << 1,
    UAVSLineTypeBottom = 1 << 2,
    UAVSLineTypeRight  = 1 << 3,
    UAVSLineTypeAll    = UAVSLineTypeTop | UAVSLineTypeLeft | UAVSLineTypeBottom | UAVSLineTypeRight
};

@interface UAVSLineUtil : NSObject

/**
 *  为view添加边线
 *
 *  @param aView  view
 *  @param aType  边线类型，可以累计
 *  @param aColor 颜色
 */
+ (void)addLineWithView:(UIView *)aView type:(UAVSLineType)aType andColor:(UIColor *)aColor;

/**
 *  为view添加边线，可以设置缩进
 *
 *  @param aView  view
 *  @param aType  边线类型，可以累计
 *  @param aColor 颜色
 *  @param aEdgeInset 缩进
 */
+ (void)addLineWithView:(UIView *)aView type:(UAVSLineType)aType andColor:(UIColor *)aColor andEdgeInset:(UIEdgeInsets)aEdgeInset;

/**
 *  删除border
 *
 *  @param aView view
 *  @param aType 边线类型，可以累计
 */
+ (void)removeLineWithView:(UIView *)aView type:(UAVSLineType)aType;


@end
