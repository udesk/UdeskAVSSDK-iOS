//
//  LineUtil.m
//  JiaPartsBase
//
//  Created by Jessica on 2018/4/2.
//  Copyright © 2018年 Wen. All rights reserved.
//

#import "UAVSLineUtil.h"
#import "UIView+UdeskAVS.h"

#define DefaultBorderWidth   (1.0 / kScreenScale)

typedef NS_ENUM(NSInteger, LineUtilViewType) {
    LineUtilViewTypeTop    = 10086,
    LineUtilViewTypeLeft,
    LineUtilViewTypeBottom,
    LineUtilViewTypeRight,
};

@implementation UAVSLineUtil

+ (void)addLineWithView:(UIView *)aView type:(UAVSLineType)aType andColor:(UIColor *)aColor
{
    [self addLineWithView:aView type:aType andColor:aColor andEdgeInset:UIEdgeInsetsZero];
}

+ (void)addLineWithView:(UIView *)aView type:(UAVSLineType)aType andColor:(UIColor *)aColor andEdgeInset:(UIEdgeInsets)aEdgeInset
{
    UIView *copyView = [UIView new];
    copyView.translatesAutoresizingMaskIntoConstraints = NO;
    copyView.backgroundColor = aColor;
    
    NSDictionary *insets = @{@"left": @(aEdgeInset.left), @"right": @(aEdgeInset.right), @"top": @(aEdgeInset.top), @"bottom": @(aEdgeInset.bottom)};
    
    CGFloat defaultBorderWidth = 1 / [UIScreen mainScreen].scale;
    
    if (aType & UAVSLineTypeTop) {
        UIView *borderView = [UIView duplicate:copyView];
        borderView.tag = LineUtilViewTypeTop;
        [aView addSubview:borderView];
        
        [aView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(left)-[borderView]-(right)-|" options:0 metrics:insets views:NSDictionaryOfVariableBindings(borderView)]];
        [aView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(top)-[borderView]" options:0 metrics:insets views:NSDictionaryOfVariableBindings(borderView)]];
        [aView addConstraint:[NSLayoutConstraint constraintWithItem:borderView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:defaultBorderWidth + aEdgeInset.bottom]];
    }
    
    if (aType & UAVSLineTypeLeft) {
        UIView *borderView = [UIView duplicate:copyView];
        borderView.tag = LineUtilViewTypeLeft;
        [aView addSubview:borderView];
        
        [aView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(top)-[borderView]-(bottom)-|" options:0 metrics:insets views:NSDictionaryOfVariableBindings(borderView)]];
        [aView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(left)-[borderView]" options:0 metrics:insets views:NSDictionaryOfVariableBindings(borderView)]];
        [aView addConstraint:[NSLayoutConstraint constraintWithItem:borderView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:defaultBorderWidth + aEdgeInset.right]];
    }
    
    if (aType & UAVSLineTypeBottom) {
        UIView *borderView = [UIView duplicate:copyView];
        borderView.tag = LineUtilViewTypeBottom;
        [aView addSubview:borderView];
        
        [aView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(left)-[borderView]-(right)-|" options:0 metrics:insets views:NSDictionaryOfVariableBindings(borderView)]];
        [aView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[borderView]-(bottom)-|" options:0 metrics:insets views:NSDictionaryOfVariableBindings(borderView)]];
        [aView addConstraint:[NSLayoutConstraint constraintWithItem:borderView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:defaultBorderWidth + aEdgeInset.bottom]];
    }
    
    if (aType & UAVSLineTypeRight) {
        UIView *borderView = [UIView duplicate:copyView];
        borderView.tag = LineUtilViewTypeRight;
        [aView addSubview:borderView];
        
        [aView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(top)-[borderView]-(bottom)-|" options:0 metrics:insets views:NSDictionaryOfVariableBindings(borderView)]];
        [aView addConstraint:[NSLayoutConstraint constraintWithItem:borderView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:aView attribute:NSLayoutAttributeRight multiplier:1.f constant:0.f]];
        [aView addConstraint:[NSLayoutConstraint constraintWithItem:borderView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:defaultBorderWidth + aEdgeInset.right]];
    }
}

+ (void)removeLineWithView:(UIView *)aView type:(UAVSLineType)aType
{
    if (aType & UAVSLineTypeTop) {
        UIView *borderView = [aView viewWithTag:LineUtilViewTypeTop];
        [borderView removeFromSuperview];
    }
    
    if (aType & UAVSLineTypeLeft) {
        UIView *borderView = [aView viewWithTag:LineUtilViewTypeLeft];
        [borderView removeFromSuperview];
    }
    
    if (aType & UAVSLineTypeBottom) {
        UIView *borderView = [aView viewWithTag:LineUtilViewTypeBottom];
        [borderView removeFromSuperview];
    }
    
    if (aType & UAVSLineTypeRight) {
        UIView *borderView = [aView viewWithTag:LineUtilViewTypeRight];
        [borderView removeFromSuperview];
    }
}


@end

