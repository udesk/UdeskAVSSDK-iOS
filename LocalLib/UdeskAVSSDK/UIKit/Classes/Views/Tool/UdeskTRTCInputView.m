//
//  UdeskTRTCInputView.m
//  UdeskAvsSDKDemo
//
//  Created by 陈历 on 2021/6/3.
//

#import "UdeskTRTCInputView.h"
#import "UdeskProjectHeader.h"

@interface UdeskTRTCInputView () <HPGrowingTextViewDelegate>


@end

@implementation UdeskTRTCInputView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    
    CGRect frame = CGRectMake(16, 7, kScreenWidth - 32, 32);
    UdeskAVSHPGrowingTextView *growingTextView = [[UdeskAVSHPGrowingTextView alloc] initWithFrame:frame];
    
    growingTextView.placeholder = @"点击输入";
    growingTextView.delegate = (id)self;
    growingTextView.returnKeyType = UIReturnKeySend;
    growingTextView.internalTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 110);
    growingTextView.font = [UIFont systemFontOfSize:15];
    growingTextView.backgroundColor = [UIColor colorWithRed:0.965 green:0.965 blue:0.965 alpha:1];
    [self addSubview:growingTextView];
    self.growingTextView = growingTextView;
    
}

#pragma mark - Text view delegate
- (void)growingTextViewDidChange:(UdeskAVSHPGrowingTextView *)growingTextView {
    
}

- (BOOL)growingTextViewShouldBeginEditing:(UdeskAVSHPGrowingTextView *)growingTextView {
    return YES;
}

- (void)growingTextViewDidBeginEditing:(UdeskAVSHPGrowingTextView *)growingTextView {
    [growingTextView becomeFirstResponder];
}

- (void)growingTextViewDidEndEditing:(UdeskAVSHPGrowingTextView *)growingTextView {
    [growingTextView resignFirstResponder];
}

- (BOOL)growingTextView:(UdeskAVSHPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if (growingTextView.text.length > 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didInputText:)]) {
                [self.delegate didInputText:growingTextView.text];
                growingTextView.text = @"";
            }
        }
        return NO;
    }
    return YES;
}

- (void)growingTextView:(UdeskAVSHPGrowingTextView *)growingTextView willChangeHeight:(float)height {
    self.height = height + 10;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeHeight:)]) {
        [self.delegate didChangeHeight:height];
    }
    NSLog(@"height=%@", @(height).stringValue);
}

- (BOOL)growingTextViewShouldReturn:(UdeskAVSHPGrowingTextView *)growingTextView{
    NSLog(@"growingTextViewShouldReturn");
    return YES;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
