//
//  UDPhotoManeger.m
//  UdeskSDK
//
//  Created by Udesk on 16/1/18.
//  Copyright © 2016年 Udesk. All rights reserved.
//

#import "UAVSPhotoManager.h"
#import "UAVSPhotoView.h"

@implementation UAVSPhotoManager

/**
 *  创建
 */
+(instancetype)maneger
{
    UAVSPhotoManager *mg = [[UAVSPhotoManager alloc] init];
    return mg;
}

/**
 *  本地图片放大浏览
 */
-(void)showPhotoWithRect:(CGRect)rect withMessageURL:(NSString *)url
{
    
    UIImageView *selecView = [[UIImageView alloc] initWithFrame:rect];
    [self showLocalPhoto:selecView withMessageURL:url];
}

/**
 *  本地图片放大浏览
 */
-(void)showLocalPhoto:(UIImageView *)selecView withMessageURL:(NSString *)url
{
    
    UAVSPhotoView *photoView = [[UAVSPhotoView alloc] init];
    [photoView setPhotoData:selecView withMessageURL:url];
    
    [self show:photoView];
}

//展示
-(void)show:(UIView *)mainScrollView
{
    //创建原始的底层View一个
    UIView *view =  [[UIView alloc]init];
    view.frame = [UIApplication sharedApplication].keyWindow.rootViewController.view.bounds;
    [view addSubview:mainScrollView];
    //解决放大的图片不在当前视图
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}

@end
