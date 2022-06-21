//
//  DGWindow.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "UAVSWindow.h"

#define BoolString(boolValue) (boolValue?@"YES":@"NO")

@implementation UAVSWindow

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        if (@available(iOS 13.0, *)) {
            // iOS13不设置无法显示
            self.windowScene = [UAVSWindow mainWindowScene];
            
            // 关闭深色模式
            self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        }

        // 防止旋转时四周有黑边
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)destroy {
    self.hidden = YES;
    if (self.rootViewController.presentedViewController) {
        [self.rootViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
    self.rootViewController = nil;
}

- (NSString *)description {
    NSString *description = [super description];
    NSString *newDescription = [NSString stringWithFormat:@"%@; name = %@; level = %.0f; hidden = %@; isKey = %@>",
                                [description substringToIndex:description.length - 1],
                                self.name,
                                self.windowLevel,
                                BoolString(self.isHidden),
                                BoolString(self.isKeyWindow)];
    return newDescription;
}

#pragma mark - private api
#if DebugoCanBeEnabled
// Prevent influence status bar
- (bool)_canAffectStatusBarAppearance {
    return self.dg_canAffectStatusBarAppearance;
}

// Prevent becoming keywindow
- (bool)_canBecomeKeyWindow {
    return self.dg_canBecomeKeyWindow;
}

- (bool)isInternalWindow {
    return self.dg_isInternalWindow;
}
#endif

// 获取主 window
+ (UIWindow * _Nullable)mainWindow{
    __block UIWindow *window = nil;
    
    if ([[[UIApplication sharedApplication] delegate] respondsToSelector:@selector(window)]) {
        window = [[[UIApplication sharedApplication] delegate] window];
    }
    
    if (!window) {
        if (@available(iOS 13.0, *)) {
            UIWindowScene *windowScene = [UAVSWindow mainWindowScene];
            if ([windowScene.delegate respondsToSelector:@selector(window)]) {
                window = [windowScene.delegate performSelector:@selector(window)];
            }
        }
    }
    
    return window ?: [UIApplication sharedApplication].keyWindow;
}

+ (id _Nullable)mainWindowScene{
    __block id scene = nil;
    if (@available(iOS 13.0, *)) {
        [[[UIApplication sharedApplication] connectedScenes] enumerateObjectsUsingBlock:^(UIScene * _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:UIWindowScene.class]) {
                UIWindowScene *windowScene = (UIWindowScene *)obj;
                if (windowScene.screen == UIScreen.mainScreen) {
                    scene = obj;
                    *stop = YES;
                }
            }
        }];
    }
    return scene;
}


@end
