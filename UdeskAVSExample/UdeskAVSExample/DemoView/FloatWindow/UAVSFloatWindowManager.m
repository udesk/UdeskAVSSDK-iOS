//
//  DGEntrance.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "UAVSFloatWindowManager.h"

#import "UAVSBubble.h"

#define kDGScreenW ([UIScreen mainScreen].bounds.size.width)
#define kDGScreenH ([UIScreen mainScreen].bounds.size.height)

#define kDGScreenMin MIN(kDGScreenW, kDGScreenH)
#define kDGScreenMax MAX(kDGScreenW, kDGScreenH)
#define kDGBottomSafeMargin ([UAVSFloatWindowManager isNotchUI] ? 34.0 : 0.0)



@interface UAVSFloatWindowManager ()

@property (nonatomic, weak) UAVSBubble *bubble;

@end

@implementation UAVSFloatWindowManager

static UAVSFloatWindowManager *_instance;
+ (instancetype)shared {
    if (!_instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[self alloc] init];
        });
    }
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (BOOL)isNotchUI
{
    // iPhone X/XS:     375pt * 812pt (@3x)
    // iPhone XS Max:   414pt * 896pt (@3x)
    // iPhone XR:       414pt * 896pt (@2x)
    CGFloat h = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    if (h == 812.0f || h == 896.0f) {
        return YES;
    }
    return NO;
}

#pragma mark - bubble
- (void)showBubble {
    if (self.bubble) {
        [self.bubble setHidden:NO];
        return;
    }
    
    UAVSBubble *bubble = [[UAVSBubble alloc] initWithFrame:CGRectMake(400, (100 + 55 + kDGBottomSafeMargin), 40, 100)];
    
    bubble.name = @"Bubble";
    //[bubble.button setImage:[UIImage imageNamed:@"icon_bubble"] forState:UIControlStateNormal];
    [bubble.button setTitle:@"视\n频\n客\n服" forState:UIControlStateNormal];
    bubble.button.titleLabel.font = [UIFont systemFontOfSize:14];
    bubble.button.titleLabel.numberOfLines = 0;
    [bubble.button setTintColor:[UIColor whiteColor]];
    __weak typeof(self) weakSelf = self;
    [bubble setClickBlock:^(UAVSBubble *bubble) {
        if (weakSelf.tapBlock) {
            weakSelf.tapBlock();
        }
    }];
  
    
    [bubble show];
    self.bubble = bubble;
}


+ (UIViewController *)currentViewController
{
    UIWindow *keyWindow  = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    while (vc.presentedViewController)
    {
        vc = vc.presentedViewController;
        
        if ([vc isKindOfClass:[UINavigationController class]])
        {
            vc = [(UINavigationController *)vc visibleViewController];
        }
        else if ([vc isKindOfClass:[UITabBarController class]])
        {
            vc = [(UITabBarController *)vc selectedViewController];
        }
    }
    
    return vc;
}

// 隐藏悬浮球
- (void)hidBubble
{
    self.bubble.hidden = YES;
}

//释放悬浮球
- (void)releaseBubble
{
    UAVSWindow *containerWindow = self.bubble;
    if (containerWindow.isKeyWindow) {
        [containerWindow.lastKeyWindow makeKeyWindow];
        containerWindow.lastKeyWindow = nil;
    }
    [self.bubble destroy];
    self.bubble = nil;
}
@end
