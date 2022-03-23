//
//  UdeskRoomViewController.m
//  UdeskAVSExample
//
//  Created by 陈历 on 2021/6/3.
//

#import "UdeskRoomViewController.h"
#import "UdeskProjectHeader.h"
#import <UdeskAVSSDK/UdeskAVSSDK.h>

@interface UdeskRoomViewController () <UdeskTRTCMessageListViewDelegate>

@property (nonatomic, strong) UdeskRoomViewModel *context;

@property (nonatomic, strong) UdeskTRTCRoomView *roomView;
@property (nonatomic, strong) UdeskTRTCBottomView *bottomView;
@property (nonatomic, strong) UdeskTRTCMessageListView <YYTextKeyboardObserver>* messageListView;
@property (nonatomic, strong) UdeskTRTCToolView *toolView;
@property (nonatomic, strong) UdeskTRTCAgentInfoView *agentInfoView;
@property (nonatomic, strong) UdeskTRTCTimerView *timerView;

@property (nonatomic, strong) UdeskAVSTRTCRoomInfo *roomInfo;
@property (nonatomic, strong) UdeskAVSAgentInfo *agent;

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
    // Do any additional setup after loading the view.
}

- (void)injected
{
    self.context.agentName = @"sdd";
}

- (void)setupViews{
    [self.view addSubview:self.roomView];
    [self.view addSubview:self.toolView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.messageListView];
    [self.view addSubview:self.timerView];
    [self.view addSubview:self.agentInfoView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[YYTextKeyboardManager defaultManager] addObserver:self.messageListView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[YYTextKeyboardManager defaultManager] removeObserver:self.messageListView];
}


- (void)updateSettings{
    //当前聊天状态
    self.context.isChatShowing = @(1);
    
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
    //
    //[self initViews];
}

- (void)initViews{
    {
       
        
        {
            NSMutableArray *messageList = [[NSMutableArray alloc] init];
            {
                UdeskAVSBaseMessage *msg = [[UdeskAVSBaseMessage alloc] init];
                msg.fromType = UdeskAVSMessageFromTypeCustomer;
                msg.messageType = UdeskAVSMessageContentTypeText;
                msg.createAt = @"18:30";
                msg.content = @"111222222你好，我啊房间卡上飞机啊斯洛伐克将阿多少；lfkja艾弗森；ldkjaflkdsajflkasfjsadlkf";
                msg.agentAvtarImage = [UIImage udavs_imageNamed:@"kefu"];
                msg.agentAvtarUrl = @"https://pic1.zhimg.com/80/v2-d03aa05346fd377da12dc324d79acda3_1440w.jpg?source=1940ef5c";
                [messageList addObject:msg];
            }
            {
                UdeskAVSBaseMessage *msg = [[UdeskAVSBaseMessage alloc] init];
                msg.fromType = UdeskAVSMessageFromTypeAgent;
                msg.messageType = UdeskAVSMessageContentTypeText;
                msg.createAt = @"21:30";
                msg.content = @"222罚打扫房间打扫；fkjjkaj;lfajs";
                msg.customerAvtarImage = [UIImage udavs_imageNamed:@"kefu"];
                msg.customerAvtarUrl = @"https://pic1.zhimg.com/80/v2-d03aa05346fd377da12dc324d79acda3_1440w.jpg?source=1940ef5c";
                [messageList addObject:msg];
            }
            {
                UdeskAVSBaseMessage *msg = [[UdeskAVSBaseMessage alloc] init];
                msg.fromType = UdeskAVSMessageFromTypeAgent;
                msg.messageType = UdeskAVSMessageContentTypeText;
                msg.createAt = @"21:30";
                msg.content = @"333";
                msg.customerAvtarImage = [UIImage udavs_imageNamed:@"kefu"];
                msg.customerAvtarUrl = @"https://pic1.zhimg.com/80/v2-d03aa05346fd377da12dc324d79acda3_1440w.jpg?source=1940ef5c";
                [messageList addObject:msg];
            }
            {
                UdeskAVSBaseMessage *msg = [[UdeskAVSBaseMessage alloc] init];
                msg.fromType = UdeskAVSMessageFromTypeAgent;
                msg.messageType = UdeskAVSMessageContentTypeText;
                msg.createAt = @"21:30";
                msg.content = @"444";
                msg.customerAvtarImage = [UIImage udavs_imageNamed:@"kefu"];
                msg.customerAvtarUrl = @"https://pic1.zhimg.com/80/v2-d03aa05346fd377da12dc324d79acda3_1440w.jpg?source=1940ef5c";
                [messageList addObject:msg];
            }
            {
                UdeskAVSBaseMessage *msg = [[UdeskAVSBaseMessage alloc] init];
                msg.fromType = UdeskAVSMessageFromTypeAgent;
                msg.messageType = UdeskAVSMessageContentTypeText;
                msg.createAt = @"21:30";
                msg.content = @"555";
                msg.customerAvtarImage = [UIImage udavs_imageNamed:@"kefu"];
                msg.customerAvtarUrl = @"https://pic1.zhimg.com/80/v2-d03aa05346fd377da12dc324d79acda3_1440w.jpg?source=1940ef5c";
                [messageList addObject:msg];
            }
            {
                UdeskAVSBaseMessage *msg = [[UdeskAVSBaseMessage alloc] init];
                msg.fromType = UdeskAVSMessageFromTypeAgent;
                msg.messageType = UdeskAVSMessageContentTypeText;
                msg.createAt = @"21:30";
                msg.customerAvtarImage = [UIImage udavs_imageNamed:@"kefu"];
                msg.customerAvtarUrl = @"https://pic1.zhimg.com/80/v2-d03aa05346fd377da12dc324d79acda3_1440w.jpg?source=1940ef5c";
                [messageList addObject:msg];
            }
            {
                UdeskAVSBaseMessage *msg = [[UdeskAVSBaseMessage alloc] init];
                msg.fromType = UdeskAVSMessageFromTypeAgent;
                msg.messageType = UdeskAVSMessageContentTypeText;
                msg.createAt = @"21:30";
                msg.customerAvtarImage = [UIImage udavs_imageNamed:@"kefu"];
                msg.customerAvtarUrl = @"https://pic1.zhimg.com/80/v2-d03aa05346fd377da12dc324d79acda3_1440w.jpg?source=1940ef5c";
                [messageList addObject:msg];
            }
            {
                UdeskAVSBaseMessage *msg = [[UdeskAVSBaseMessage alloc] init];
                msg.fromType = UdeskAVSMessageFromTypeAgent;
                msg.messageType = UdeskAVSMessageContentTypeText;
                msg.createAt = @"21:30";
                msg.customerAvtarImage = [UIImage udavs_imageNamed:@"kefu"];
                msg.customerAvtarUrl = @"https://pic1.zhimg.com/80/v2-d03aa05346fd377da12dc324d79acda3_1440w.jpg?source=1940ef5c";
                [messageList addObject:msg];
            }
            
            NSMutableArray *layoutList = [[NSMutableArray alloc] init];
            for (UdeskAVSBaseMessage *msg in messageList) {
                BOOL showDateTime = YES;
                if (msg.messageType == UdeskAVSMessageContentTypeText) {
                    UdeskAVSTextLayout *layout = [[UdeskAVSTextLayout alloc] initWithMessage:msg dateDisplay:showDateTime];
                    [layoutList addObject:layout];
                }
            }
            self.context.messageList = layoutList;
        }
    }
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
}

- (void)updateMessageList:(NSArray *)messageList{
    NSMutableArray *layoutList = [[NSMutableArray alloc] init];
    for (UdeskAVSBaseMessage *msg in messageList) {
        BOOL showDateTime = YES;
        if (msg.messageType == UdeskAVSMessageContentTypeText) {
            UdeskAVSTextLayout *layout = [[UdeskAVSTextLayout alloc] initWithMessage:msg dateDisplay:showDateTime];
            [layoutList addObject:layout];
        }
    }
    self.context.messageList = layoutList;
}


- (void)hangup:(NSDictionary *)info{
    [UIAlertController udeskShowAlert:@"对方已挂机" onViewController:self.navigationController completion:^{
        [self close];
    }];
}

- (void)close{
    [UdeskAVSSDKManager destoryInstance];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)sendBye{
    [[UdeskAVSSDKManager sharedInstance] sendBye];
}

- (void)exitRoom{
    
}

- (void)dealloc{
    NSLog(@"%@ dealloc", [self class]);
}

#pragma mark - UdeskTRTCMessageListViewDelegate
- (void)didInputText:(NSString *)text{
    [[UdeskAVSSDKManager sharedInstance] sendText:text];
}

#pragma mark - YYTextKeyboardObserver

#pragma mark - Lazy
- (UdeskTRTCRoomView *)roomView{
    if (!_roomView) {
        _roomView = [[UdeskTRTCRoomView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) context:self.context];
    }
    return _roomView;
}

- (UdeskTRTCBottomView *)bottomView{
    if (!_bottomView) {
        CGFloat h = 176 + kUdeskScreenTabBarSafeAreaHeight;
        _bottomView = [[UdeskTRTCBottomView alloc] initWithFrame:CGRectMake(0, kScreenHeight - h, kScreenWidth, h) context:self.context];
    }
    return _bottomView;
}

- (UdeskTRTCMessageListView *)messageListView{
    if (!_messageListView) {
        CGFloat h = kScreenHeight - kUdeskScreenNavBarHeight - kScreenWidth/2.0;
        _messageListView = [[UdeskTRTCMessageListView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, h) context:self.context];
        _messageListView.delegate = self;
        _messageListView.backgroundColor = [UIColor lightGrayColor];
    }
    return _messageListView;
}

- (UdeskTRTCToolView *)toolView{
    if (!_toolView) {
        _toolView = [[UdeskTRTCToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) context:self.context];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
