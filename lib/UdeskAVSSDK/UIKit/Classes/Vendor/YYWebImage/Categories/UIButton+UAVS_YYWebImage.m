//
//  UIButton+YYWebImage.m
//  YYWebImage <https://github.com/ibireme/YYWebImage>
//
//  Created by ibireme on 15/2/23.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "UIButton+UAVS_YYWebImage.h"
#import "UAVS_YYWebImageOperation.h"
#import "UAVS_YYWebImageSetter.h"
#import <objc/runtime.h>

// Dummy class for category
@interface Udesk_UIButton_YYWebImage : NSObject @end
@implementation Udesk_UIButton_YYWebImage @end

static inline NSNumber *UdeskUIControlStateSingle(UIControlState state) {
    if (state & UIControlStateHighlighted) return @(UIControlStateHighlighted);
    if (state & UIControlStateDisabled) return @(UIControlStateDisabled);
    if (state & UIControlStateSelected) return @(UIControlStateSelected);
    return @(UIControlStateNormal);
}

static inline NSArray *UdeskUIControlStateMulti(UIControlState state) {
    NSMutableArray *array = [NSMutableArray new];
    if (state & UIControlStateHighlighted) [array addObject:@(UIControlStateHighlighted)];
    if (state & UIControlStateDisabled) [array addObject:@(UIControlStateDisabled)];
    if (state & UIControlStateSelected) [array addObject:@(UIControlStateSelected)];
    if ((state & 0xFF) == 0) [array addObject:@(UIControlStateNormal)];
    return array;
}

static int UAVS_YYWebImageSetterKey;
static int _YYWebImageBackgroundSetterKey;


@interface UAVS_YYWebImageSetterDicForButton : NSObject
- (UAVS_YYWebImageSetter *)setterForState:(NSNumber *)state;
- (UAVS_YYWebImageSetter *)lazySetterForState:(NSNumber *)state;
@end

@implementation UAVS_YYWebImageSetterDicForButton {
    NSMutableDictionary *_dic;
    dispatch_semaphore_t _lock;
}
- (instancetype)init {
    self = [super init];
    _lock = dispatch_semaphore_create(1);
    _dic = [NSMutableDictionary new];
    return self;
}
- (UAVS_YYWebImageSetter *)setterForState:(NSNumber *)state {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    UAVS_YYWebImageSetter *setter = _dic[state];
    dispatch_semaphore_signal(_lock);
    return setter;
    
}
- (UAVS_YYWebImageSetter *)lazySetterForState:(NSNumber *)state {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    UAVS_YYWebImageSetter *setter = _dic[state];
    if (!setter) {
        setter = [UAVS_YYWebImageSetter new];
        _dic[state] = setter;
    }
    dispatch_semaphore_signal(_lock);
    return setter;
}
@end


@implementation UIButton (UAVS_YYWebImage)

#pragma mark - image

- (void)_uavs_yy_setImageWithURL:(NSURL *)imageURL
             forSingleState:(NSNumber *)state
                placeholder:(UIImage *)placeholder
                    options:(UAVS_YYWebImageOptions)options
                    manager:(UAVS_YYWebImageManager *)manager
                   progress:(UAVS_YYWebImageProgressBlock)progress
                  transform:(UAVS_YYWebImageTransformBlock)transform
                 completion:(UAVS_YYWebImageCompletionBlock)completion {
    if ([imageURL isKindOfClass:[NSString class]]) imageURL = [NSURL URLWithString:(id)imageURL];
    manager = manager ? manager : [UAVS_YYWebImageManager sharedManager];
    
    UAVS_YYWebImageSetterDicForButton *dic = objc_getAssociatedObject(self, &UAVS_YYWebImageSetterKey);
    if (!dic) {
        dic = [UAVS_YYWebImageSetterDicForButton new];
        objc_setAssociatedObject(self, &UAVS_YYWebImageSetterKey, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    UAVS_YYWebImageSetter *setter = [dic lazySetterForState:state];
    int32_t sentinel = [setter cancelWithNewURL:imageURL];
    
    _uavs_yy_dispatch_sync_on_main_queue(^{
        if (!imageURL) {
            if (!(options & UAVS_YYWebImageOptionIgnorePlaceHolder)) {
                [self setImage:placeholder forState:state.integerValue];
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
                [self setImage:imageFromMemory forState:state.integerValue];
            }
            if(completion) completion(imageFromMemory, imageURL, UAVS_YYWebImageFromMemoryCacheFast, UAVS_YYWebImageStageFinished, nil);
            return;
        }
        
        
        if (!(options & UAVS_YYWebImageOptionIgnorePlaceHolder)) {
            [self setImage:placeholder forState:state.integerValue];
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    BOOL sentinelChanged = weakSetter && weakSetter.sentinel != newSentinel;
                    if (setImage && self && !sentinelChanged) {
                        [self setImage:image forState:state.integerValue];
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

- (void)_uavs_yy_cancelImageRequestForSingleState:(NSNumber *)state {
    UAVS_YYWebImageSetterDicForButton *dic = objc_getAssociatedObject(self, &UAVS_YYWebImageSetterKey);
    UAVS_YYWebImageSetter *setter = [dic setterForState:state];
    if (setter) [setter cancel];
}

- (NSURL *)uavs_yy_imageURLForState:(UIControlState)state {
    UAVS_YYWebImageSetterDicForButton *dic = objc_getAssociatedObject(self, &UAVS_YYWebImageSetterKey);
    UAVS_YYWebImageSetter *setter = [dic setterForState:UdeskUIControlStateSingle(state)];
    return setter.imageURL;
}

- (void)uavs_yy_setImageWithURL:(NSURL *)imageURL
                  forState:(UIControlState)state
               placeholder:(UIImage *)placeholder {
    [self uavs_yy_setImageWithURL:imageURL
                 forState:state
              placeholder:placeholder
                  options:kNilOptions
                  manager:nil
                 progress:nil
                transform:nil
               completion:nil];
}

- (void)uavs_yy_setImageWithURL:(NSURL *)imageURL
                  forState:(UIControlState)state
                   options:(UAVS_YYWebImageOptions)options {
    [self uavs_yy_setImageWithURL:imageURL
                    forState:state
                 placeholder:nil
                     options:options
                     manager:nil
                    progress:nil
                   transform:nil
                  completion:nil];
}

- (void)uavs_yy_setImageWithURL:(NSURL *)imageURL
                  forState:(UIControlState)state
               placeholder:(UIImage *)placeholder
                   options:(UAVS_YYWebImageOptions)options
                completion:(UAVS_YYWebImageCompletionBlock)completion {
    [self uavs_yy_setImageWithURL:imageURL
                    forState:state
                 placeholder:placeholder
                     options:options
                     manager:nil
                    progress:nil
                   transform:nil
                  completion:completion];
}

- (void)uavs_yy_setImageWithURL:(NSURL *)imageURL
                  forState:(UIControlState)state
               placeholder:(UIImage *)placeholder
                   options:(UAVS_YYWebImageOptions)options
                  progress:(UAVS_YYWebImageProgressBlock)progress
                 transform:(UAVS_YYWebImageTransformBlock)transform
                completion:(UAVS_YYWebImageCompletionBlock)completion {
    [self uavs_yy_setImageWithURL:imageURL
                    forState:state
                 placeholder:placeholder
                     options:options
                     manager:nil
                    progress:progress
                   transform:transform
                  completion:completion];
}

- (void)uavs_yy_setImageWithURL:(NSURL *)imageURL
                  forState:(UIControlState)state
               placeholder:(UIImage *)placeholder
                   options:(UAVS_YYWebImageOptions)options
                   manager:(UAVS_YYWebImageManager *)manager
                  progress:(UAVS_YYWebImageProgressBlock)progress
                 transform:(UAVS_YYWebImageTransformBlock)transform
                completion:(UAVS_YYWebImageCompletionBlock)completion {
    for (NSNumber *num in UdeskUIControlStateMulti(state)) {
        [self _uavs_yy_setImageWithURL:imageURL
                   forSingleState:num
                      placeholder:placeholder
                          options:options
                          manager:manager
                         progress:progress
                        transform:transform
                       completion:completion];
    }
}

- (void)uavs_yy_cancelImageRequestForState:(UIControlState)state {
    for (NSNumber *num in UdeskUIControlStateMulti(state)) {
        [self _uavs_yy_cancelImageRequestForSingleState:num];
    }
}


#pragma mark - background image

- (void)_uavs_yy_setBackgroundImageWithURL:(NSURL *)imageURL
                       forSingleState:(NSNumber *)state
                          placeholder:(UIImage *)placeholder
                              options:(UAVS_YYWebImageOptions)options
                              manager:(UAVS_YYWebImageManager *)manager
                             progress:(UAVS_YYWebImageProgressBlock)progress
                            transform:(UAVS_YYWebImageTransformBlock)transform
                           completion:(UAVS_YYWebImageCompletionBlock)completion {
    if ([imageURL isKindOfClass:[NSString class]]) imageURL = [NSURL URLWithString:(id)imageURL];
    manager = manager ? manager : [UAVS_YYWebImageManager sharedManager];
    
    UAVS_YYWebImageSetterDicForButton *dic = objc_getAssociatedObject(self, &_YYWebImageBackgroundSetterKey);
    if (!dic) {
        dic = [UAVS_YYWebImageSetterDicForButton new];
        objc_setAssociatedObject(self, &_YYWebImageBackgroundSetterKey, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    UAVS_YYWebImageSetter *setter = [dic lazySetterForState:state];
    int32_t sentinel = [setter cancelWithNewURL:imageURL];
    
    _uavs_yy_dispatch_sync_on_main_queue(^{
        if (!imageURL) {
            if (!(options & UAVS_YYWebImageOptionIgnorePlaceHolder)) {
                [self setBackgroundImage:placeholder forState:state.integerValue];
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
                [self setBackgroundImage:imageFromMemory forState:state.integerValue];
            }
            if(completion) completion(imageFromMemory, imageURL, UAVS_YYWebImageFromMemoryCacheFast, UAVS_YYWebImageStageFinished, nil);
            return;
        }
        
        
        if (!(options & UAVS_YYWebImageOptionIgnorePlaceHolder)) {
            [self setBackgroundImage:placeholder forState:state.integerValue];
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    BOOL sentinelChanged = weakSetter && weakSetter.sentinel != newSentinel;
                    if (setImage && self && !sentinelChanged) {
                        [self setBackgroundImage:image forState:state.integerValue];
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

- (void)_uavs_yy_cancelBackgroundImageRequestForSingleState:(NSNumber *)state {
    UAVS_YYWebImageSetterDicForButton *dic = objc_getAssociatedObject(self, &_YYWebImageBackgroundSetterKey);
    UAVS_YYWebImageSetter *setter = [dic setterForState:state];
    if (setter) [setter cancel];
}

- (NSURL *)uavs_yy_backgroundImageURLForState:(UIControlState)state {
    UAVS_YYWebImageSetterDicForButton *dic = objc_getAssociatedObject(self, &_YYWebImageBackgroundSetterKey);
    UAVS_YYWebImageSetter *setter = [dic setterForState:UdeskUIControlStateSingle(state)];
    return setter.imageURL;
}

- (void)uavs_yy_setBackgroundImageWithURL:(NSURL *)imageURL
                            forState:(UIControlState)state
                         placeholder:(UIImage *)placeholder {
    [self uavs_yy_setBackgroundImageWithURL:imageURL
                              forState:state
                           placeholder:placeholder
                               options:kNilOptions
                               manager:nil
                              progress:nil
                             transform:nil
                            completion:nil];
}

- (void)uavs_yy_setBackgroundImageWithURL:(NSURL *)imageURL
                            forState:(UIControlState)state
                             options:(UAVS_YYWebImageOptions)options {
    [self uavs_yy_setBackgroundImageWithURL:imageURL
                              forState:state
                           placeholder:nil
                               options:options
                               manager:nil
                              progress:nil
                             transform:nil
                            completion:nil];
}

- (void)uavs_yy_setBackgroundImageWithURL:(NSURL *)imageURL
                            forState:(UIControlState)state
                         placeholder:(UIImage *)placeholder
                             options:(UAVS_YYWebImageOptions)options
                          completion:(UAVS_YYWebImageCompletionBlock)completion {
    [self uavs_yy_setBackgroundImageWithURL:imageURL
                              forState:state
                           placeholder:placeholder
                               options:options
                               manager:nil
                              progress:nil
                             transform:nil
                            completion:completion];
}

- (void)uavs_yy_setBackgroundImageWithURL:(NSURL *)imageURL
                            forState:(UIControlState)state
                         placeholder:(UIImage *)placeholder
                             options:(UAVS_YYWebImageOptions)options
                            progress:(UAVS_YYWebImageProgressBlock)progress
                           transform:(UAVS_YYWebImageTransformBlock)transform
                          completion:(UAVS_YYWebImageCompletionBlock)completion {
    [self uavs_yy_setBackgroundImageWithURL:imageURL
                              forState:state
                           placeholder:placeholder
                               options:options
                               manager:nil
                              progress:progress
                             transform:transform
                            completion:completion];
}

- (void)uavs_yy_setBackgroundImageWithURL:(NSURL *)imageURL
                            forState:(UIControlState)state
                         placeholder:(UIImage *)placeholder
                             options:(UAVS_YYWebImageOptions)options
                             manager:(UAVS_YYWebImageManager *)manager
                            progress:(UAVS_YYWebImageProgressBlock)progress
                           transform:(UAVS_YYWebImageTransformBlock)transform
                          completion:(UAVS_YYWebImageCompletionBlock)completion {
    for (NSNumber *num in UdeskUIControlStateMulti(state)) {
        [self _uavs_yy_setBackgroundImageWithURL:imageURL
                             forSingleState:num
                                placeholder:placeholder
                                    options:options
                                    manager:manager
                                   progress:progress
                                  transform:transform
                                 completion:completion];
    }
}

- (void)uavs_yy_cancelBackgroundImageRequestForState:(UIControlState)state {
    for (NSNumber *num in UdeskUIControlStateMulti(state)) {
        [self _uavs_yy_cancelBackgroundImageRequestForSingleState:num];
    }
}

@end
