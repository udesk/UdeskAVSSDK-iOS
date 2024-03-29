//
//  UdeskRoomViewController.m
//  UdeskAVSExample
//
//  Created by 陈历 on 2021/6/3.
//

#import "UdeskRoomViewController.h"
#import "UdeskProjectHeader.h"

#import "UdeskAVSChatViewController.h"
#import "VideoCallUIManager.h"
#import "UdeskAVSConnector.h"
#import "UdeskAVSBundleUtils.h"

@interface UdeskRoomViewController () <UAVSRoomToolBarViewDelegate,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UdeskRoomViewModel *context;

@property (nonatomic, strong) UdeskTRTCRoomView *roomView;
@property (nonatomic, strong) UdeskTRTCBottomView *bottomView;
@property (nonatomic, strong) UdeskTRTCToolView *toolView;
@property (nonatomic, strong) UdeskTRTCAgentInfoView *agentInfoView;
@property (nonatomic, strong) UdeskTRTCTimerView *timerView;

@property (nonatomic, strong) UdeskAVSTRTCRoomInfo *roomInfo;
@property (nonatomic, strong) UdeskAVSAgentInfo *agent;

@property (nonatomic, strong) UdeskAVSChatViewController *chatViewController;
@property (nonatomic, strong) VideoCallUIManager *uiManager;

@property (nonatomic, strong)UIButton *minViewButton;

@end

@implementation UdeskRoomViewController

- (instancetype)initWithRoom:(NSDictionary *)info{
    if (self = [super init]) {
        _roomInfo = [info objectForKey:@"roomInfo"];
        _agent = [info objectForKey:@"agent"];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.context = [[UdeskRoomViewModel alloc] init];
    [self setupViews];
    [self updateSettings];
 
    UDWeakSelf
    [self.uiManager getLatestMessage:^(BOOL hasMore) {
        [weakSelf reloadChatRoomTableView];
        [weakSelf reloadMessageTableView];
    }];
}

#pragma mark - 事件处理
/**收到消息*/
- (void)receivedMessage:(UdeskAVSBaseMessage *)message
{
    UDWeakSelf;
    [self.uiManager addMessage:message
                      completion:^{
        [weakSelf reloadMessageTableView];
        [weakSelf reloadChatRoomTableView];
    }];
}

- (void)reloadMessageTableView{
    self.context.messageList = [self.uiManager filterMessage];
}
- (void)reloadChatRoomTableView{
    [self.chatViewController reloadTableView];
}


- (void)setupViews{
    [self.view addSubview:self.roomView];
    [self.view addSubview:self.toolView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.timerView];
    [self.view addSubview:self.agentInfoView];
    
    UdeskAVSConfig *config = [UdeskAVSConnector sharedInstance].sdkConfig;
    if (config.isMiniView) {
        self.minViewButton = [[UIButton alloc] initWithFrame:CGRectMake(16, self.agentInfoView.bottom + 8, 32, 32)];
        self.minViewButton.backgroundColor = [UIColor clearColor];
        [self.minViewButton setBackgroundImage:[UIImage udavs_imageNamed:@"minView"] forState:UIControlStateNormal];
        [self.minViewButton addTarget:self action:@selector(minViewButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.minViewButton];
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[[YYTextKeyboardManager defaultManager] addObserver:self.messageListView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[[YYTextKeyboardManager defaultManager] removeObserver:self.messageListView];
}


- (void)updateSettings{
    
    //当前聊天状态
    //zoomMode
    self.context.zoomMode = @(UDESK_AVS_VIDEO_MODE_VIDEO_FULLSCREEN);
    //cameraSwitch
    self.context.cameraSwitch = @([UdeskAVSSDKManager sharedInstance].customerCameraSet);
    
    if (self.agent.nickname.length > 0) {
        self.context.agentName = [NSString stringWithFormat:@"%@", self.agent.nickname];;
    }
    if (self.agent.avatar.length > 0) {
        self.context.agentAvatar = [NSString stringWithFormat:@"%@", self.agent.avatar];
    }
    
    [self.roomView enterRoom:self.roomInfo];
}

#pragma mark - Public
- (void)updateAgentInfo:(UdeskAVSAgentInfo *)info{
    self.agent = info;
    if (self.agent.nickname.length > 0) {
        self.context.agentName = [NSString stringWithFormat:@"%@", self.agent.nickname];
    }
    if (self.agent.avatar.length > 0) {
        self.context.agentAvatar = [NSString stringWithFormat:@"%@", self.agent.avatar];
    }
    self.uiManager.agent = self.agent;
}

- (void)sendBye{
    [[UdeskAVSSDKManager sharedInstance] sendBye];
}

- (void)dealloc{
    NSLog(@"%@ dealloc", [self class]);
}
#pragma mark - UAVSRoomToolBarViewDelegate

- (void)doToolBarAction:(UDESK_VIDEO_TOOL_ACTION_TYPE)type
{
    if (type == UDESK_VIDEO_TOOL_ACTION_TYPE_INFO) {
        self.context.isChatShowing = @(YES);
        [self.chatViewController showOnViewController:self animated:YES];
    }
    else if(type == UDESK_VIDEO_TOOL_ACTION_TYPE_ZOOM){
        if (self.context.zoomMode.intValue == UDESK_AVS_VIDEO_MODE_VIDEO_SMALL) {
            self.minViewButton.hidden = NO;
            self.context.zoomMode = @(UDESK_AVS_VIDEO_MODE_VIDEO_FULLSCREEN);
            [self.chatViewController dismissFromParentViewController];
        }
        else{
            self.minViewButton.hidden = YES;
            self.context.zoomMode = @(UDESK_AVS_VIDEO_MODE_VIDEO_SMALL);
            if ([self.chatViewController parentViewController]) {
                return;
            }
            [self.chatViewController showOnViewController:self animated:NO];
        }
    }
    else if(type == UDESK_VIDEO_TOOL_ACTION_TYPE_MICRO){
        self.context.mute = self.context.mute.boolValue?@(0):@(1);
    }
    else if(type == UDESK_VIDEO_TOOL_ACTION_TYPE_ENABLE_VIDEO){
        self.context.stopVideo = self.context.stopVideo.boolValue?@(0):@(1);
    }
    else if(type == UDESK_VIDEO_TOOL_ACTION_TYPE_EXCHANGE){
        self.context.cameraSwitch = self.context.cameraSwitch.boolValue?@(0):@(1);
    }
    else if(type == UDESK_VIDEO_TOOL_ACTION_TYPE_HANDOFF){
        [[NSNotificationCenter defaultCenter] postNotificationName:kUdeskGlobalMessageHandOff object:nil userInfo:@{}];
    }
    else if(type == UDESK_VIDEO_TOOL_ACTION_TYPE_SHARE_VIEW){
        self.context.isViewShare = self.context.isViewShare.boolValue?@(0):@(1);
    }
    
}

#pragma mark - 事件

- (void)roomViewMainTouch
{
    if (self.context.zoomMode.integerValue != UDESK_AVS_VIDEO_MODE_VIDEO_FULLSCREEN){
        return;
    }
    if ([self.context.isChatShowing boolValue]) {
        [self.chatViewController dismissFromParentViewController];
    }
}

- (void)minViewButtonClick
{
    [[UdeskAVSConnector sharedInstance] dismissWithLeveling];
}


#pragma mark - Lazy
- (UdeskTRTCRoomView *)roomView{
    if (!_roomView) {
        _roomView = [[UdeskTRTCRoomView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) context:self.context];
        
        UDWeakSelf;
        _roomView.mainTouchBlock = ^{
            [weakSelf roomViewMainTouch];
        };
       
        NSLog(@"context=%@", self.context.isChatShowing);
    }
    return _roomView;
}

- (UdeskTRTCBottomView *)bottomView{
    if (!_bottomView) {
        CGFloat h = 176 + kUdeskScreenTabBarSafeAreaHeight;
        _bottomView = [[UdeskTRTCBottomView alloc] initWithFrame:CGRectMake(0, kScreenHeight - h, kScreenWidth, h) context:self.context];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

- (UdeskTRTCToolView *)toolView{
    if (!_toolView) {
        _toolView = [[UdeskTRTCToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) context:self.context];
        _toolView.delegate = self;
        _toolView.backgroundColor = [UIColor grayColor];
    }
    return _toolView;
}

- (UdeskTRTCTimerView *)timerView{
    if (!_timerView) {
        _timerView = [[UdeskTRTCTimerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kUdeskScreenNavBarHeight) context:self.context];
    }
    return _timerView;
}

- (UdeskTRTCAgentInfoView *)agentInfoView{
    if (!_agentInfoView) {
        _agentInfoView = [[UdeskTRTCAgentInfoView alloc] initWithFrame:CGRectMake(16, kUdeskScreenNavBarHeight, 200, 32) context:self.context];
    }
    return _agentInfoView;
}

- (void)chatViewControllerDidDismiss{
    NSLog(@"_chatViewControllerDidDismiss ...");
    self.context.isChatShowing = @(NO);
    
}
- (UdeskAVSChatViewController *)chatViewController{
    if (!_chatViewController) {
        _chatViewController = [[UdeskAVSChatViewController alloc] initWithUIManager:self.uiManager];
        //_chatViewController.connectInfo = _connectInfo;
        UDWeakSelf
        _chatViewController.dismissBlock = ^{
            [weakSelf chatViewControllerDidDismiss];
        };
    }
    return _chatViewController;;
}
- (VideoCallUIManager *)uiManager{
    if (!_uiManager) {
        _uiManager = [[VideoCallUIManager alloc] init];
        _uiManager.agent = self.agent;
    }
    return _uiManager;
}

- (NSString *)channelId
{
    if (self.roomInfo && self.roomInfo.channelId.length) {
        return self.roomInfo.channelId;
    }
    return nil;
}

@end
