//
//  UdeskAVSChatViewController.m
//  UdeskApp
//
//  Created by 陈历 on 2020/5/22.
//  Copyright © 2020 xushichen. All rights reserved.
//

#import "UdeskAVSChatViewController.h"
#import "VideoCallChatToolView.h"
#import "VideoCallInputBottomView.h"
#import "VideoCallImageSelectView.h"
#import "VideoCallUIManager.h"
#import "VideoCallChatDataSource.h"
#import "UAVSChatBaseLayout.h"
#import "UdeskProjectHeader.h"
#import "NSDate+UdeskAVS.h"
#import <YYText/YYText.h>
#import "UdeskRoomViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface UdeskAVSChatViewController () <UIGestureRecognizerDelegate, VideoCallChatToolDelegate, YYTextKeyboardObserver, UITableViewDelegate, VideoCallImageSelectDelegate>

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) VideoCallChatToolView *inputView;

@property (nonatomic, strong) UITableView *chatTableView;

@property (nonatomic, strong) VideoCallInputBottomView *moreView;
@property (nonatomic, assign) CGFloat moreViewHeight;
@property (nonatomic, assign) BOOL showMoreView;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) VideoCallImageSelectView *imageSelectView;

@property (nonatomic, strong) VideoCallUIManager *uiManager;

@property (nonatomic, strong) VideoCallChatDataSource *dataSource;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign)BOOL noMoreMessage;

@end

@implementation UdeskAVSChatViewController

- (instancetype)initWithUIManager:(VideoCallUIManager *)manager{
    if (self = [super init]) {
        _uiManager = manager;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.moreViewHeight = UDAVS_isIPhoneXSeries?(80+34):80;
    
    // Do any additional setup after loading the view.
    [self setupViews];
    [self reloadTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self scrollToPoperPosition];
    [[YYTextKeyboardManager defaultManager] addObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

- (void)setupViews{
    _topView = [self createTopView];
    [self.contentView addSubview:_topView];
    
    [self.contentView addSubview:self.chatTableView];
    __weak typeof(self) weakSelf = self;
    self.chatTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf fetchHistoryMessageList];
    }];
   
    CGFloat inputHeight = (UDAVS_isIPhoneXSeries?(52+32):52);
    self.inputView = [[VideoCallChatToolView alloc] initWithFrame:CGRectMake(0, self.contentView.height - self.chatTableView.bottom, kScreenWidth, inputHeight)];
    self.inputView.delegate = self;
    [self.contentView addSubview:self.inputView];
    
    self.moreView = [[VideoCallInputBottomView alloc] initWithFrame:CGRectMake(0, self.contentView.height, kScreenWidth, 0)];
    self.moreView.block = ^(NSNumber*  _Nullable obj) {
        [weakSelf bottomButtonPressed:obj];
    };
    [self.contentView addSubview:self.moreView];
    
    _imageSelectView = [[VideoCallImageSelectView alloc] initWithFrame:_contentView.frame];
    _imageSelectView.top = kScreenHeight;
    _imageSelectView.delegate = self;
    [self.view addSubview:_imageSelectView];
}

- (UIView *)createTopView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 53)];
    topView.backgroundColor = [UIColor whiteColor];
    topView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 32, 4)];
    line.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25];
    line.centerX = self.contentView.width/2.0;
    line.layer.cornerRadius = 2.0;
    [topView addSubview:line];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, self.contentView.width, 40)];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _titleLabel.textColor = UIColorHex(#000000D9);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = UDAVS_FONT(16);
    _titleLabel.text = getUDAVSLocalizedString(@"uavs_title_chat");
    _titleLabel.userInteractionEnabled = YES;
    [_titleLabel appendBottomBorder];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
       tapGestureRecognizer.delegate = self;
    [_titleLabel addGestureRecognizer:tapGestureRecognizer];
    
    [topView addSubview:_titleLabel];
   
    return topView;
}

- (void)dealloc{
    NSLog(@"%@ dealloc p=%p", [self class], self);
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"chat controller");
        if ([self.inputView.chatTextView isFirstResponder]) {
            //收回键盘
            [self.inputView.chatTextView resignFirstResponder];
        }
        else if(self.imageSelectView.isShowing){
            [self.imageSelectView show:NO];
        }
        else if(self.showMoreView){
            //收回更多
            [UIView animateWithDuration:0.3
                             animations:^{
                self.moreView.frame = CGRectMake(0, self.contentView.height, kScreenWidth, 0);
                self.inputView.bottom = self.contentView.height;
                self.chatTableView.height = self.contentView.height - self.inputView.height - self.topView.height;
            } completion:^(BOOL finished) {
                [self scrollToBottom];
            }];
        }
        else{
            //TODO 同时兼容小屏幕模式
            //[self dismissFromParentViewController];
        }
        
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (CGRectContainsPoint([self.titleLabel bounds], [touch locationInView:self.titleLabel])){
        return YES;
    }
    if (CGRectContainsPoint([self.contentView bounds], [touch locationInView:self.contentView])){
        return NO;
    }
    return YES;
}

- (void)dismissWithCompletion:(void (^)(void))completion {
    [self.view endEditing:NO];
    if (self.imageSelectView.isShowing) {
        [self.imageSelectView show:NO];
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|7<<16 animations:^{
        //self.view.backgroundColor = [UIColor clearColor];
        self.contentView.top = kScreenHeight;
    } completion:^(BOOL finished) {
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        if (completion) completion();
    }];
    
}

-  (void)dismissFromParentViewController
{
    [self dismissWithCompletion:^{
        if (self.dismissBlock) {
            self.dismissBlock();
        }
    }];
}
-  (void)showOnViewController:(UIViewController *)parentController animated:(BOOL)animated{
    CGFloat vHeight = UD_SCREEN_HEIGHT - kUdeskScreenNavBarHeight - UD_SCREEN_WIDTH/2.0;
    self.view.frame = CGRectMake(0, parentController.view.bounds.size.height - vHeight, parentController.view.bounds.size.width, vHeight);
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [parentController addChildViewController: self];
    [parentController.view addSubview: self.view];
    
    
    self.contentView.frame = self.view.bounds;
    
    self.moreView.top = self.contentView.height - (self.showMoreView ? self.moreViewHeight : 0);
    CGFloat inputHeight = (UDAVS_isIPhoneXSeries?(52+32):52);
    self.inputView.frame = CGRectMake(0, self.moreView.top - inputHeight, kScreenWidth, inputHeight);
    self.chatTableView.height = self.inputView.top - self.topView.height;
    
    if (animated) {
        self.contentView.top = self.view.height;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|7<<16 animations:^{
            self.contentView.top = 0;
        } completion:^(BOOL finished) {
            [self scrollToBottom];
        }];
    }
}

#pragma mark @protocol YYKeyboardObserver
- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption | UIViewAnimationOptionBeginFromCurrentState animations:^{
        CGRect toFrame = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.contentView];
        //NSLog(@"frame=%@", NSStringFromCGRect(toFrame));
        CGFloat keyBoardTop = CGRectGetMinY(toFrame);
        if(transition.toVisible){//弹出
            CGFloat inputHeight = 52;
            self.inputView.frame = CGRectMake(0, keyBoardTop - inputHeight, kScreenWidth, inputHeight);
            self.showMoreView = NO;
            //只要键盘有变动，就把moreView隐藏
            self.moreView.frame = CGRectMake(0, self.contentView.height, kScreenWidth, 0);
        }else{
            CGFloat inputHeight = (!self.showMoreView && UDAVS_isIPhoneXSeries)?(52+32):52;
            self.inputView.frame = CGRectMake(0, self.moreView.top - inputHeight, kScreenWidth, inputHeight);
        }
        self.chatTableView.height = self.inputView.top - self.topView.bottom;
        [self scrollToPoperPosition];
        
        [self.contentView bringSubviewToFront:self.inputView];
    } completion:NULL];
}

- (void)fetchHistoryMessageList{
    __weak typeof(self) weakSelf = self;
    NSInteger count = self.dataSource.messageArray.count;
    [self.uiManager getNextPageMessage:^(BOOL hasMore) {
        weakSelf.noMoreMessage = !hasMore;
        weakSelf.dataSource.messageArray = weakSelf.uiManager.showMessageList;
        NSInteger newCount = weakSelf.dataSource.messageArray.count - count;
        if (newCount) {
            [weakSelf.chatTableView reloadData];
            [weakSelf.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:newCount inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [weakSelf.chatTableView.mj_header endRefreshing];
        }
        if (!hasMore) {
            [weakSelf.chatTableView.mj_header endRefreshingWithCompletionBlock:^{
                weakSelf.chatTableView.mj_header = nil;
            }];
        }
    }];
}


- (void)reloadQuickMessageTableView{
    NSLog(@"reloadQuickMessageTableView enter");
    if (![self.parentViewController isKindOfClass:[UdeskRoomViewController class]]) {
        return;
    }
    NSLog(@"reloadQuickMessageTableView action");
    UdeskRoomViewController *parent = (UdeskRoomViewController *)self.parentViewController;
    [parent reloadMessageTableView];
}

- (void)reloadTableView{
    if (self.view) {//调用一下view 触发didload
        self.dataSource.messageArray = self.uiManager.showMessageList;
        [self.chatTableView reloadData];
        [self scrollToPoperPosition];
    }
}

//更多消息类型 点击
- (void)bottomButtonPressed:(NSNumber *)obj{
    if (obj.intValue == VideoCallInputBottomButtonTypeImage) {
        [UdeskAVSUtil checkPermissionsOfAlbum:^(BOOL isOK) {
            if (isOK) {
                [self.imageSelectView show:YES];
            }
        }];
    }
}

- (void)didSelectImage:(UIImage *)image{
    if (!image || ![image isKindOfClass:[UIImage class]]) {
        return;
    }
   
    UdeskAVSBaseMessage *message = [[UdeskAVSMessageManager sharedInstance] sendImage:image];
    
    UDWeakSelf;
    //添加到列表
    [self.uiManager addMessage:message completion:^{
        [weakSelf reloadQuickMessageTableView];
        [weakSelf reloadTableView];
    }];
    
}


#pragma mark - VideoCallChatToolDelegate

- (void)didChangeHeight:(CGFloat)height
{
    self.chatTableView.height = self.inputView.top - self.topView.bottom;
}

- (void)didEndInputText:(nonnull NSString *)text {
    [self closeKeyBoard];
    if (text.length == 0) {
        return;
    }
    
    UdeskAVSBaseMessage *message = [[UdeskAVSMessageManager sharedInstance] sendText:text];
    
    UDWeakSelf;
    //添加到列表
    [self.uiManager addMessage:message completion:^{
        [weakSelf reloadQuickMessageTableView];
        [weakSelf reloadTableView];
    }];

}

- (void)didPressMoreButton{
    [self.inputView.chatTextView resignFirstResponder];
    self.showMoreView = !self.showMoreView;
    if (self.showMoreView) {
        [UIView animateWithDuration:0.3
                         animations:^{
            self.moreView.frame = CGRectMake(0, self.contentView.height-self.moreViewHeight, kScreenWidth, self.moreViewHeight);
            CGFloat inputHeight = 52;
            self.inputView.frame = CGRectMake(0, self.moreView.top - inputHeight, kScreenWidth, inputHeight);
            self.chatTableView.height = self.inputView.top - self.topView.height;
        } completion:^(BOOL finished) {
            [self scrollToBottom];
        }];
    }
    else{
        [UIView animateWithDuration:0.3
                         animations:^{
            self.moreView.frame = CGRectMake(0, self.contentView.height, kScreenWidth, 0);
            CGFloat inputHeight = (UDAVS_isIPhoneXSeries?(52+32):52);
            self.inputView.frame = CGRectMake(0, self.moreView.top - inputHeight, kScreenWidth, inputHeight);
            self.chatTableView.height = self.inputView.top - self.topView.height;
        } completion:^(BOOL finished) {
            [self scrollToBottom];
        }];
    }
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [self.dataSource tableView:tableView heightForRowAtIndexPath:indexPath];
    if (indexPath.row == [tableView numberOfRowsInSection:0] -1) {
        height += 20;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (void)scrollToPoperPosition{
    CGFloat h = 0;
    for (UAVSChatBaseLayout *layout in self.dataSource.messageArray) {
        h += layout.height;
    }
    if (h > self.chatTableView.height && [self.chatTableView numberOfRowsInSection:0]) {
        //NSLog(@"scroll到底=================");
        [self scrollToBottom];
    }
    else{
        //NSLog(@"不用scroll到底=================");
    }
}

- (void)closeKeyBoard{
    if ([self.inputView.chatTextView isFirstResponder]) {
        [self.inputView.chatTextView resignFirstResponder];
    }
}

- (VideoCallChatDataSource *)dataSource{
    if (!_dataSource) {
        _dataSource = [[VideoCallChatDataSource alloc] init];
    }
    return _dataSource;
}

- (UITableView *)chatTableView
{
    if (!_chatTableView) {
        CGFloat h = self.contentView.height - (UDAVS_isIPhoneXSeries?(52+32):52) - self.topView.bottom;
        _chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topView.bottom, kScreenWidth, h) style:UITableViewStylePlain];
        _chatTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _chatTableView.delegate = self;
        _chatTableView.dataSource = self.dataSource;
        _chatTableView.rowHeight = 40;
        _chatTableView.backgroundColor = UIColorHex(#F6F6F6);
        _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _chatTableView.showsVerticalScrollIndicator = NO;
        
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 5)];
        footer.backgroundColor = UIColorHex(#F6F6F6);
        _chatTableView.tableFooterView = footer;
    }
    return _chatTableView;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, self.view.height)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [_contentView clipsCornerRadius:6 corner:UIRectCornerTopLeft|UIRectCornerTopRight];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_contentView];
    }
    return _contentView;
}

- (void)scrollToBottom
{
    if ([self.chatTableView numberOfRowsInSection:0]) {
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.chatTableView numberOfRowsInSection:0] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

@end
