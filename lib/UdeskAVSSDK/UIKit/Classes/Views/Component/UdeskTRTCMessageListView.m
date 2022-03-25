//
//  UdeskTRTCMessageListView.m
//  UdeskAvsSDKDemo
//
//  Created by 陈历 on 2021/5/28.
//

#import "UdeskTRTCMessageListView.h"
#import "UdeskProjectHeader.h"

static CGFloat kUdeskAVSInputToolHeight = 64;

@interface UdeskTRTCMessageListView () <UITableViewDelegate, UITableViewDataSource, UdeskTRTCInputViewDelegate, YYTextKeyboardObserver>

@property (nonatomic, strong) UITableView *messageTableView;
@property (nonatomic, strong) UdeskTRTCInputView *toolView;
@property (nonatomic, strong) NSArray *messageList;

@end

@implementation UdeskTRTCMessageListView

- (instancetype)initWithFrame:(CGRect)frame context:(UdeskRoomViewModel *)context{
    if (self = [super initWithFrame:frame context:context]) {
        [self setupViews];
        [self addObservers:@[NSStringFromSelector(@selector(isChatShowing)),
                             NSStringFromSelector(@selector(zoomMode)),
                             NSStringFromSelector(@selector(messageList))
        ]];
    }
    return self;
}

- (void)setupViews{
    UIColor *bgColor = [UIColor colorWithRed:0.965 green:0.965 blue:0.965 alpha:1];
    CGFloat h = self.height - 60;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, h)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = [[UIView alloc] init];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = bgColor;
    [self addSubview:tableView];
    self.messageTableView = tableView;
    
    
    UdeskTRTCInputView *inputView = [[UdeskTRTCInputView alloc] initWithFrame:CGRectMake(0, self.height - kUdeskAVSInputToolHeight, kScreenWidth, kUdeskAVSInputToolHeight)];
    inputView.delegate = self;
    [self addSubview:inputView];
    self.toolView = inputView;
}

- (void)showChatChanged:(NSNumber *)showchat{
    if (self.toolView.growingTextView.isFirstResponder) {
        [self.toolView.growingTextView resignFirstResponder];
    }
    [UIView animateWithDuration:0.3 animations:^{
        if (showchat.boolValue) {
            self.bottom = kScreenHeight;
        }
        else{
            self.top = kScreenHeight;
        }
    }];
}

- (void)zoomModeChanged:(NSNumber *)zoomMode{
    [self endEditing:NO];
    if (zoomMode.intValue == UDESK_AVS_VIDEO_MODE_VIDEO_FULLSCREEN) {
        self.height = kScreenHeight * 3/4.0;
        self.top = kScreenHeight;
    }
    else{
        self.height = kScreenHeight - kUdeskScreenNavBarHeight - kScreenWidth/2.0;
        self.bottom = kScreenHeight;
    }
    self.messageTableView.height = self.height - 60;
    self.toolView.bottom = self.height;
}

- (void)messageListChanged:(NSArray *)messageList{
    self.messageList = [NSArray arrayWithArray:messageList];;
    [self.messageTableView reloadData];
    if (messageList.count > 0) {
        [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messageList.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark UITableViewMessage
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UdeskAVSBaseLayout *layout = [self.messageList objectAtIndex:indexPath.row];
    return layout.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UdeskAVSBaseLayout *layout = [self.messageList objectAtIndex:indexPath.row];
    NSString *identifier = NSStringFromClass([layout class]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [layout getCellWithReuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    ((UdeskAVSBaseTableViewCell *)cell).baseLayout = layout;
    return cell;
}

#pragma mark - UdeskTRTCInputViewDelegate
- (void)didChangeHeight:(CGFloat)height{
    self.inputView.bottom = self.bottom;
    NSLog(@"......");
}

- (void)didInputText:(nonnull NSString *)text {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didInputText:)]) {
        [self.delegate didInputText:text];
    }
}


#pragma mark -
- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition{
    [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption | UIViewAnimationOptionBeginFromCurrentState animations:^{
        CGRect toFrame = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self];
        NSLog(@"frame=%@", NSStringFromCGRect(toFrame));
        CGFloat keyBoardTop = CGRectGetMinY(toFrame);
        self.toolView.bottom = keyBoardTop;
        self.messageTableView.height = keyBoardTop - 60;
        
    } completion:NULL];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
