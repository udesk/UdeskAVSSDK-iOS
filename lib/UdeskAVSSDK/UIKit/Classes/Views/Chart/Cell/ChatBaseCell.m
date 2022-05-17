//
//  ChatBaseCell.m
//  UdeskApp
//
//  Created by xuchen on 2018/1/8.
//  Copyright © 2018年 xushichen. All rights reserved.
//

#import "ChatBaseCell.h"
#import "UIView+UdeskAVS.h"
#import "UdeskAVCSUtil.h"
#import "UIButton+UdeskAVS.h"
#import <YYText/YYText.h>

//app底色
#define DefaultBlueColor [UIColor colorWithRed:0.094f  green:0.322f  blue:0.643f alpha:1]
#define DefaultGrayColor [UIColor colorWithRed:0.965f  green:0.965f  blue:0.965f alpha:1]

@implementation ChatBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = DefaultGrayColor;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (UIButton *)avatarButton {
    
    if (!_avatarButton) {
        //初始化头像
        _avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_avatarButton addTarget:self action:@selector(avatarButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_avatarButton];
    }
    return _avatarButton;
}

- (void)avatarButtonAction {
    
    if (self.chatDelegate && [self.chatDelegate respondsToSelector:@selector(didSelectCustomerAvatar)]) {
        [self.chatDelegate didSelectCustomerAvatar];
    }
}

- (UIImageView *)bubbleImageView {
    
    if (!_bubbleImageView) {
        
        //初始化气泡
        _bubbleImageView = [[UIImageView alloc] init];
        _bubbleImageView.userInteractionEnabled = true;
        _bubbleImageView.clipsToBounds = YES;
        [self.contentView addSubview:_bubbleImageView];
        
        //长按手势
        UILongPressGestureRecognizer *longPressBubbleGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureAction)];
        longPressBubbleGesture.cancelsTouchesInView = NO;
        [_bubbleImageView addGestureRecognizer:longPressBubbleGesture];
    }
    
    return _bubbleImageView;
}

- (UIButton *)resetButton {
    
    if (!_resetButton) {
        _resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resetButton setImage:[UIImage imageNamed:@"messageWarning"] forState:UIControlStateNormal];
        [_resetButton addTarget:self action:@selector(resendMessageAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_resetButton];
    }
    return _resetButton;
}

- (void)resendMessageAction:(UIButton *)button {
    
    self.resetButton.hidden = YES;
    self.loadingView.hidden = NO;
    [self.loadingView startAnimating];
    
    if (self.chatDelegate && [self.chatDelegate respondsToSelector:@selector(tableViewCell:resendMessage:)]) {
        [self.chatDelegate tableViewCell:self resendMessage:self.baseLayout.message];
    }
}

- (UIActivityIndicatorView *)loadingView {
    
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.contentView addSubview:_loadingView];
    }
    return _loadingView;
}

- (YYLabel *)msgStatusLabel {
    if (!_msgStatusLabel) {
        _msgStatusLabel = [[YYLabel alloc] init];
        _msgStatusLabel.font = [UIFont systemFontOfSize:kUDChatMessageStatusFontSize];
        _msgStatusLabel.textColor = [UIColor colorWithRed:0.471f  green:0.471f  blue:0.471f alpha:1];
        _msgStatusLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_msgStatusLabel];
    }
    return _msgStatusLabel;
}

- (void)setBaseLayout:(ChatBaseLayout *)baseLayout {
    _baseLayout = baseLayout;
    
    //头像位置
    self.avatarButton.frame = baseLayout.avatarFrame;
    self.avatarButton.top = baseLayout.height-baseLayout.bubbleSize.height;
    
//    if ([baseLayout.message.status isEqualToString:@"system"]) {
//        [self.avatarButton setImage:[UIImage imageNamed:@"systemMsgAvatar"] forState:UIControlStateNormal];
//    }
//    else
    if (baseLayout.message.agentAvtarImage) {
        [self.avatarButton setImage:baseLayout.message.agentAvtarImage forState:UIControlStateNormal];
    }
    else if(baseLayout.message.agentAvtarUrl.length > 0){
        NSString *imageUrl = [UdeskAVCSUtil urlStringEscapedEncode:baseLayout.message.agentAvtarUrl];
        [self.avatarButton setImageWithURL:imageUrl state:UIControlStateNormal];
    }
    
    
    if (baseLayout.message.fromType != UdeskAVSMessageFromTypeCustomer) {
        
        self.resetButton.hidden = YES;
        self.loadingView.hidden = YES;
        self.msgStatusLabel.hidden = YES;
    }
}

//- (void)updateMsgStatus:(UDMessageSendStatus)msgStatus {
//
//    //菊花和重发
//    self.loadingView.centerY = self.bubbleImageView.centerY;
//    self.loadingView.right = self.bubbleImageView.left-kUDCellBubbleToIndicatorSpacing;
//    self.loadingView.size = CGSizeMake(kUDCellLoadingSize, kUDCellLoadingSize);
//    self.resetButton.frame = self.loadingView.frame;
//
//    switch (msgStatus) {
//        case UDMessageSendStatusFailed:
//
//            self.loadingView.hidden = YES;
//            [self.loadingView stopAnimating];
//            self.resetButton.hidden = NO;
//            self.msgStatusLabel.hidden = YES;
//            break;
//        case UDMessageSendStatusSending:
//
//            self.loadingView.hidden = NO;
//            [self.loadingView startAnimating];
//            self.resetButton.hidden = YES;
//            self.msgStatusLabel.hidden = YES;
//            break;
//        case UDMessageSendStatusSuccess:
//
//            [self.loadingView stopAnimating];
//            self.loadingView.hidden = YES;
//            self.resetButton.hidden = YES;
//            self.msgStatusLabel.hidden = YES;
//            break;
//        case UDMessageSendStatusRollback:
//
//            [self setupMsgStatusLabelWithContent:@"已撤回"];
//            break;
//        case UDMessageSendStatusOffSending:
//
//            [self setupMsgStatusLabelWithContent:@"离线发送"];
//            break;
//
//        default:
//            break;
//    }
//
//    if (self.baseLayout.message.fromType == UDMessageFromTypeCustomer||
//        self.baseLayout.message.fromType == UDMessageFromTypeSystem ||
//        self.baseLayout.message.fromType == UDMessageFromTypeRobot) {
//        self.resetButton.hidden = YES;
//        self.loadingView.hidden = YES;
//        self.msgStatusLabel.hidden = YES;
//    }
//}

//- (void)setupMsgStatusLabelWithContent:(NSString *)status {
//
//    [self.loadingView stopAnimating];
//    self.loadingView.hidden = YES;
//    self.resetButton.hidden = YES;
//    self.msgStatusLabel.hidden = NO;
//    self.msgStatusLabel.text = status;
//
//    CGFloat width = [status widthForFont:self.msgStatusLabel.font];
//    //消息状态
//    self.msgStatusLabel.top = self.bubbleImageView.bottom+kUDChatMessageStatusToVerticalEdgeSpacing;
//    self.msgStatusLabel.size = CGSizeMake(width, kUDChatMessageStatusHeight);
//    self.msgStatusLabel.right = self.bubbleImageView.right;
//}

- (void)longPressGestureAction {
    [self showMenuControllerInView:self.bubbleImageView targetRect:self.bubbleImageView.bounds];
}

#pragma 显示menu的方法
- (void)showMenuControllerInView:(UIView *)inView
                      targetRect:(CGRect)targetRect {
    
    [self becomeFirstResponder];
    //判断menuItem都有哪些
    NSMutableArray *menuItems = [[NSMutableArray alloc] init];
    
    if (self.baseLayout.message.messageType == UdeskAVSMessageContentTypeText) {
        UIMenuItem *copyTextItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyTextSender:)];
        [menuItems addObject:copyTextItem];
    }
    
    //时间判断
    NSTimeInterval timeInterval = self.baseLayout.message.timestamp;
    if (timeInterval < 120 &&
        !self.isHistory &&
//        self.baseLayout.message.sendStatus != UDMessageSendStatusRollback &&
        self.baseLayout.message.fromType != UdeskAVSMessageFromTypeCustomer) {
        UIMenuItem *rollbackItem = [[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(rollbackSender:)];
        [menuItems addObject:rollbackItem];
    }
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:menuItems];
    [menu setTargetRect:targetRect inView:inView];
    [menu setMenuVisible:YES animated:YES];
}

#pragma mark 剪切板代理方法
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copyTextSender:) || action == @selector(rollbackSender:)) {
        return true;
    }
    else {
        return false;
    }
}

- (void)copyTextSender:(id)sender {
    UIPasteboard *pasteboard=[UIPasteboard generalPasteboard];
    pasteboard.string = self.baseLayout.message.content;
}

//撤回
- (void)rollbackSender:(id)sender {
    
    NSTimeInterval timeInterval = self.baseLayout.message.timestamp;
    if (timeInterval > 120) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"消息发出已经超出2分钟，无法撤回" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self.viewController presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if (self.chatDelegate && [self.chatDelegate respondsToSelector:@selector(tableViewCell:rollbackMessage:)]) {
        [self.chatDelegate tableViewCell:self rollbackMessage:self.baseLayout.message];
    }
}
@end
