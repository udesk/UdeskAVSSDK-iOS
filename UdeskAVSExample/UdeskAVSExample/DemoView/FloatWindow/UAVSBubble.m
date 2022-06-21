//
//  DGBubble.m
//  Debugo
//
//  GitHub https://github.com/ripperhe/Debugo
//  Created by ripper on 2018/9/1.
//  Copyright © 2018年 ripper. All rights reserved.
//


#import "UAVSBubble.h"


#define kIsIPhoneX ([[UIScreen mainScreen] nativeBounds].size.height >= 2436.0)
#define kTopMargin (kIsIPhoneX ? 88.0 : 64.0)
#define kBottomMargin (kIsIPhoneX ? 83.0 : 49.0)
#define kHiddenProportion 0.14545455


#define kDGHighlightColor [UIColor colorWithRed:0.00 green:0.478431 blue:1.00 alpha:1.00]
#define kDGImpactFeedback \
if (@available(iOS 10.0, *)) { \
UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium]; \
[feedBackGenertor impactOccurred]; \
}


@interface UAVSBubble()

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIButton *button;
@property (nonatomic, assign) BOOL isDragging;
@property (nonatomic, copy) NSString *memoryAddressKey;

@end

@implementation UAVSBubble

- (void)dealloc {
//    DGLogFunction;
}

- (instancetype)initWithFrame:(CGRect)frame{
    // check w、h
    CGRect bounds = [UIScreen mainScreen].bounds;
    if (frame.size.width >= bounds.size.width || frame.size.height >= bounds.size.height) {
        NSAssert(0, @"DGBubble: 传入的 frame 值不对!");
        return nil;
    }else if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = CGRectMake(0, 100, 40, 100);
    }
    
    // update center
    CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    CGPoint newCenter = [UAVSBubble checkNewCenterWithPoint:center size:frame.size];
    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;
    frame = CGRectMake(newCenter.x - w * 0.5, newCenter.y - h * 0.5, w, h);
    
    if(self = [super initWithFrame:frame]) {
        self.windowLevel = UIWindowLevelAlert - 200;
        // rootViewController
        self.rootViewController = [[UIViewController alloc] init];
        // button
        [self setupBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.isDragging == NO) {
        // deal rotate
        CGPoint newCenter = [UAVSBubble checkNewCenterWithPoint:self.center size:self.frame.size];
        if (CGPointEqualToPoint(newCenter, self.center) == NO) {
            self.center = newCenter;
        }
    }
}

- (void)setupBtn {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.userInteractionEnabled = YES;
    button.clipsToBounds = YES;
    button.backgroundColor = kDGHighlightColor;
    
    // click
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    // pan
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    pan.delaysTouchesBegan = YES;
    [button addGestureRecognizer:pan];
    
    [self.contentView addSubview:button];
    self.button = button;
    
    [self setFrame:self.frame];
}

#pragma mark - setter
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    if (_button) {
        // setCenter 不会调用该方法，放在 layoutSubviews 拖动的时候会一直调用
        CGRect btnFrame = self.bounds;
        _button.frame = btnFrame;
        _button.layer.cornerRadius = btnFrame.size.width <= btnFrame.size.height ? btnFrame.size.width / 2.0 : btnFrame.size.height / 2.0;
    }
}

#pragma mark - getter
- (UIView *)contentView {
    return self.rootViewController.view;
}

- (NSString *)memoryAddressKey {
    if (!_memoryAddressKey) {
        _memoryAddressKey = [NSString stringWithFormat:@"%@_%p", NSStringFromClass([self class]), self];
    }
    return _memoryAddressKey;
}

#pragma mark - event response
- (void)handlePanGesture:(UIPanGestureRecognizer*)p {
    UIWindow *appWindow = [UAVSWindow mainWindow];
    CGPoint panPoint = [p locationInView:appWindow];
    
    if(p.state == UIGestureRecognizerStateBegan) {
        self.isDragging = YES;
        self.contentView.alpha = 1;
        if (self.panStartBlock) {
            self.panStartBlock(self);
        }
    }else if(p.state == UIGestureRecognizerStateChanged) {
        self.center = CGPointMake(panPoint.x, panPoint.y);
    }else if(p.state == UIGestureRecognizerStateEnded
             || p.state == UIGestureRecognizerStateCancelled) {
        CGPoint newCenter = [UAVSBubble checkNewCenterWithPoint:panPoint size:self.frame.size];
        [UIView animateWithDuration:.25 animations:^{
            self.center = newCenter;
        } completion:^(BOOL finished) {
            self.isDragging = NO;
        }];
        if (self.panEndBlock) {
            self.panEndBlock(self);
        }
    }else{
        NSLog(@"%@ pan state : %zd", self, p.state);
    }
}


- (void)click {
    kDGImpactFeedback
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.9],
                              [NSNumber numberWithFloat:1.1],
                              [NSNumber numberWithFloat:0.9],
                              [NSNumber numberWithFloat:1.0], nil];
    bounceAnimation.duration = .25;
    bounceAnimation.removedOnCompletion = YES;
    [self.layer addAnimation:bounceAnimation forKey:nil];
    
    if (self.clickBlock) {
        self.clickBlock(self);
    }
}

#pragma mark - private methods
+ (CGPoint)checkNewCenterWithPoint:(CGPoint)point size:(CGSize)size {
    CGFloat ballWidth = size.width;
    CGFloat ballHeight = size.height;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    CGFloat left = fabs(point.x);
    CGFloat right = fabs(screenWidth - left);
    
    CGPoint newCenter = CGPointZero;
    CGFloat targetY = 0;
    
    //Correcting Y
    if (point.y < kTopMargin + ballHeight / 2.0) {
        targetY = kTopMargin + ballHeight / 2.0;
    }else if (point.y > (screenHeight - ballHeight / 2.0 - kBottomMargin)) {
        targetY = screenHeight - ballHeight / 2.0 - kBottomMargin;
    }else{
        targetY = point.y;
    }
    
    CGFloat centerXSpace = (0.5 - kHiddenProportion) * ballWidth;
    
    if (left <= right) {
        newCenter = CGPointMake(centerXSpace, targetY);
    }else {
        newCenter = CGPointMake(screenWidth - centerXSpace, targetY);
    }
    
    return newCenter;
}

#pragma mark - public methods
static NSMutableDictionary<NSString *, UAVSBubble *> *_bubbleManager = nil;
- (void)show {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _bubbleManager = [NSMutableDictionary dictionary];
    });
    if ([_bubbleManager objectForKey:self.memoryAddressKey]) return;

    [self setHidden:NO];
    [_bubbleManager setObject:self forKey:self.memoryAddressKey];
}

- (void)removeFromScreen {
    [self destroy];
    [_bubbleManager removeObjectForKey:self.memoryAddressKey];
}


@end
