//
//  UDPhotoView.m
//  UdeskSDK
//
//  Created by Udesk on 16/1/18.
//  Copyright © 2016年 Udesk. All rights reserved.
//

#import "UAVSPhotoView.h"
#import "UdeskAVSUtil.h"
#import "UAVS_YYWebImage.h"
#import "UdeskAVSButton.h"
#import "UIImage+UdeskAVS.h"
#import "UdeskAVSBundleUtils.h"

#define Gap 10   //俩照片间黑色间距

@implementation UAVSPhotoView {

    NSString *imageUrl;
}

#pragma mark - 自己的属性设置一下
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        //设置主滚动创的大小位置
        self.frame = CGRectMake(-Gap, 0, [UIScreen mainScreen].bounds.size.width + Gap + Gap,[UIScreen mainScreen].bounds.size.height);
        
    }
    return self;
}

#pragma mark - 拿到数据时展示

-(void)setPhotoData:(UIImageView *)photoImageView withMessageURL:(NSString *)url {
    
    imageUrl = url;
    //传值给单个滚动器
    UAVSOneScrollView *oneScroll = [[UAVSOneScrollView alloc]init];
    oneScroll.mydelegate = self;
    //自己是数组中第几个图
    //设置位置并添加
    oneScroll.frame = CGRectMake(Gap , 0 ,[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    [self addSubview:oneScroll];
    
    [oneScroll setLocalImage:photoImageView withMessageURL:url];
 
    UdeskAVSButton *button = [UdeskAVSButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width-28-15, [[UIScreen mainScreen] bounds].size.height-26-15, 28, 28);
    [button setImage:[UIImage udavs_imageNamed:@"udImageSave"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(saveImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)saveImageAction:(UIButton *)button {
    
    if ([[UAVS_YYWebImageManager sharedManager].cache containsImageForKey:imageUrl]) {
        UIImage *image = [[UAVS_YYWebImageManager sharedManager].cache getImageForKey:imageUrl];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            });
        }
    }
    else {
        
        [[UAVS_YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:[imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] options:UAVS_YYWebImageOptionShowNetworkActivity progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, UAVS_YYWebImageFromType from, UAVS_YYWebImageStage stage, NSError * _Nullable error) {
           
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                });
            }
        }];
    }
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = getUDAVSLocalizedString(@"uavs_saveImg_failed");
    }else{
        msg = getUDAVSLocalizedString(@"uavs_saveImg_success");
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *conform = [UIAlertAction actionWithTitle:getUDAVSLocalizedString(@"uavs_common_makeSure") style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:conform];
    [[UdeskAVSUtil currentViewController] presentViewController:alert animated:YES completion:nil];
}

#pragma mark - OneScroll的代理方法

//退出图片浏览器
-(void)goBack
{
    //让原始底层UIView死掉
    [self.superview removeFromSuperview];
}


@end
