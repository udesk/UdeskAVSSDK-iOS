//
//  VideoCallChatToolView.m
//  UdeskApp
//
//  Created by 陈历 on 2020/4/1.
//  Copyright © 2020 xushichen. All rights reserved.
//

#import "VideoCallChatToolView.h"
#import "UdeskProjectHeader.h"
#import "UdeskAVSBundleUtils.h"

@implementation VideoCallChatToolView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupViews];
        //[self appendTopBorder];
    }
    return self;
}

- (void)setupViews{
    //初始化输入框
    CGRect frame = CGRectMake(16, 7, UD_SCREEN_WIDTH -16-28-16 - 16, 34);
    UdeskAVSHPGrowingTextView *growingTextView = [[UdeskAVSHPGrowingTextView alloc] initWithFrame:frame];
    
    growingTextView.placeholder = getUDAVSLocalizedString(@"uavs_placeHolder_inputMsg");
    growingTextView.delegate = (id)self;
    growingTextView.returnKeyType = UIReturnKeySend;
    growingTextView.font = [UIFont systemFontOfSize:14];
    growingTextView.backgroundColor = UIColorHex(#F6F6F6FF);
    growingTextView.layer.cornerRadius = 16;
    growingTextView.clipsToBounds = YES;
    //growingTextView.minHeight = 34;
    UIEdgeInsets egd = growingTextView.internalTextView.textContainerInset;
    egd.left = egd.right = 10;
    growingTextView.internalTextView.textContainerInset = egd;
    
    _chatTextView = growingTextView;
    [self addSubview:_chatTextView];
    
    UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(_chatTextView.right + 16, 9, 28 , 28)];
    [imageButton setBackgroundImage:[UIImage udavs_imageNamed:@"udInputMore"] forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(imageSelectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:imageButton];
}

- (void)imageSelectButtonPressed:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPressMoreButton)]) {
        [self.delegate didPressMoreButton];
    }
}

#pragma mark - Text view delegate
- (BOOL)growingTextView:(UdeskAVSHPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didEndInputText:)]) {
            [self.delegate didEndInputText:growingTextView.text];
        }
        [self.chatTextView setText:@""];
        return NO;
    }
    return YES;
}

- (void)growingTextView:(UdeskAVSHPGrowingTextView *)growingTextView willChangeHeight:(float)height {
    CGFloat bottomSpace = UDAVS_isIPhoneXSeries? 32 : 0;
    CGFloat maxTextHeight = 100;
    CGFloat minTextHeight = 38;
    CGFloat marginHeight = 14 + bottomSpace;
    
    if (height > maxTextHeight) {
        height = maxTextHeight;
    }
    else if(height < minTextHeight){
        height = minTextHeight;
    }
    CGFloat totalHeight = height + marginHeight;
    CGRect frame = self.frame;
    if (round(totalHeight) == round(frame.size.height)) {
        return;
    }
    frame.origin.y += (frame.size.height - totalHeight);
    frame.size.height = totalHeight;
    self.frame = frame;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeHeight:)]) {
        [self.delegate didChangeHeight:self.height];
    }
    NSLog(@"height=%@", @(height).stringValue);
}


- (void)dealloc{
    NSLog(@"%@ dealloc =%p", [self class], self);
}

@end
