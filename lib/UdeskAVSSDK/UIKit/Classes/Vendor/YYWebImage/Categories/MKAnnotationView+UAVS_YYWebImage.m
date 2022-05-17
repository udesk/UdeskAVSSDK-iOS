//
//  MKAnnotationView+YYWebImage.m
//  YYWebImage <https://github.com/ibireme/YYWebImage>
//
//  Created by ibireme on 15/2/23.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "MKAnnotationView+UAVS_YYWebImage.h"
#import "UAVS_YYWebImageOperation.h"
#import "UAVS_YYWebImageSetter.h"
#import <objc/runtime.h>

// Dummy class for category
@interface Udesk_MKAnnotationView_YYWebImage : NSObject @end
@implementation Udesk_MKAnnotationView_YYWebImage @end


static int UAVS_YYWebImageSetterKey;

@implementation MKAnnotationView (UAVS_YYWebImage)

- (NSURL *)uavs_yy_imageURL {
    UAVS_YYWebImageSetter *setter = objc_getAssociatedObject(self, &UAVS_YYWebImageSetterKey);
    return setter.imageURL;
}

- (void)setUAVS_yy_imageURL:(NSURL *)imageURL {
    [self uavs_yy_setImageWithURL:imageURL
              placeholder:nil
                  options:kNilOptions
                  manager:nil
                 progress:nil
                transform:nil
               completion:nil];
}

- (void)uavs_yy_setImageWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder {
    [self uavs_yy_setImageWithURL:imageURL
                 placeholder:placeholder
                     options:kNilOptions
                     manager:nil
                    progress:nil
                   transform:nil
                  completion:nil];
}

- (void)uavs_yy_setImageWithURL:(NSURL *)imageURL options:(UAVS_YYWebImageOptions)options {
    [self uavs_yy_setImageWithURL:imageURL
                 placeholder:nil
                     options:options
                     manager:nil
                    progress:nil
                   transform:nil
                  completion:nil];
}

- (void)uavs_yy_setImageWithURL:(NSURL *)imageURL
               placeholder:(UIImage *)placeholder
                   options:(UAVS_YYWebImageOptions)options
                completion:(UAVS_YYWebImageCompletionBlock)completion {
    [self uavs_yy_setImageWithURL:imageURL
                 placeholder:placeholder
                     options:options
                     manager:nil
                    progress:nil
                   transform:nil
                  completion:completion];
}

- (void)uavs_yy_setImageWithURL:(NSURL *)imageURL
               placeholder:(UIImage *)placeholder
                   options:(UAVS_YYWebImageOptions)options
                  progress:(UAVS_YYWebImageProgressBlock)progress
                 transform:(UAVS_YYWebImageTransformBlock)transform
                completion:(UAVS_YYWebImageCompletionBlock)completion {
    [self uavs_yy_setImageWithURL:imageURL
                 placeholder:placeholder
                     options:options
                     manager:nil
                    progress:progress
                   transform:transform
                  completion:completion];
}

- (void)uavs_yy_setImageWithURL:(NSURL *)imageURL
               placeholder:(UIImage *)placeholder
                   options:(UAVS_YYWebImageOptions)options
                   manager:(UAVS_YYWebImageManager *)manager
                  progress:(UAVS_YYWebImageProgressBlock)progress
                 transform:(UAVS_YYWebImageTransformBlock)transform
                completion:(UAVS_YYWebImageCompletionBlock)completion {
    if ([imageURL isKindOfClass:[NSString class]]) imageURL = [NSURL URLWithString:(id)imageURL];
    manager = manager ? manager : [UAVS_YYWebImageManager sharedManager];
    
    UAVS_YYWebImageSetter *setter = objc_getAssociatedObject(self, &UAVS_YYWebImageSetterKey);
    if (!setter) {
        setter = [UAVS_YYWebImageSetter new];
        objc_setAssociatedObject(self, &UAVS_YYWebImageSetterKey, setter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    int32_t sentinel = [setter cancelWithNewURL:imageURL];
    
    _uavs_yy_dispatch_sync_on_main_queue(^{
        if ((options & UAVS_YYWebImageOptionSetImageWithFadeAnimation) &&
            !(options & UAVS_YYWebImageOptionAvoidSetImage)) {
            if (!self.highlighted) {
                [self.layer removeAnimationForKey:UAVS_YYWebImageFadeAnimationKey];
            }
        }
        if (!imageURL) {
            if (!(options & UAVS_YYWebImageOptionIgnorePlaceHolder)) {
                self.image = placeholder;
            }
            return;
        }
        
        // get the image from memory as quickly as possible
        UIImage *imageFromMemory = nil;
        if (manager.cache &&
            !(options & UAVS_YYWebImageOptionUseNSURLCache) &&
            !(options & UAVS_YYWebImageOptionRefreshImageCache)) {
            imageFromMemory = [manager.cache getImageForKey:[manager cacheKeyForURL:imageURL] withType:UAVS_YYImageCacheTypeMemory];
        }
        if (imageFromMemory) {
            if (!(options & UAVS_YYWebImageOptionAvoidSetImage)) {
                self.image = imageFromMemory;
            }
            if(completion) completion(imageFromMemory, imageURL, UAVS_YYWebImageFromMemoryCacheFast, UAVS_YYWebImageStageFinished, nil);
            return;
        }
        
        if (!(options & UAVS_YYWebImageOptionIgnorePlaceHolder)) {
            self.image = placeholder;
        }
        
        __weak typeof(self) _self = self;
        dispatch_async([UAVS_YYWebImageSetter setterQueue], ^{
            UAVS_YYWebImageProgressBlock _progress = nil;
            if (progress) _progress = ^(NSInteger receivedSize, NSInteger expectedSize) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    progress(receivedSize, expectedSize);
                });
            };
            
            __block int32_t newSentinel = 0;
            __block __weak typeof(setter) weakSetter = nil;
            UAVS_YYWebImageCompletionBlock _completion = ^(UIImage *image, NSURL *url, UAVS_YYWebImageFromType from, UAVS_YYWebImageStage stage, NSError *error) {
                __strong typeof(_self) self = _self;
                BOOL setImage = (stage == UAVS_YYWebImageStageFinished || stage == UAVS_YYWebImageStageProgress) && image && !(options & UAVS_YYWebImageOptionAvoidSetImage);
                BOOL showFade = ((options & UAVS_YYWebImageOptionSetImageWithFadeAnimation) && !self.highlighted);
                dispatch_async(dispatch_get_main_queue(), ^{
                    BOOL sentinelChanged = weakSetter && weakSetter.sentinel != newSentinel;
                    if (setImage && self && !sentinelChanged) {
                        if (showFade) {
                            CATransition *transition = [CATransition animation];
                            transition.duration = stage == UAVS_YYWebImageStageFinished ? UAVS_YYWebImageFadeTime : UAVS_YYWebImageProgressiveFadeTime;
                            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                            transition.type = kCATransitionFade;
                            [self.layer addAnimation:transition forKey:UAVS_YYWebImageFadeAnimationKey];
                        }
                        self.image = image;
                    }
                    if (completion) {
                        if (sentinelChanged) {
                            completion(nil, url, UAVS_YYWebImageFromNone, UAVS_YYWebImageStageCancelled, nil);
                        } else {
                            completion(image, url, from, stage, error);
                        }
                    }
                });
            };
            
            newSentinel = [setter setOperationWithSentinel:sentinel url:imageURL options:options manager:manager progress:_progress transform:transform completion:_completion];
            weakSetter = setter;
        });
    });
}

- (void)yy_cancelCurrentImageRequest {
    UAVS_YYWebImageSetter *setter = objc_getAssociatedObject(self, &UAVS_YYWebImageSetterKey);
    if (setter) [setter cancel];
}

@end
