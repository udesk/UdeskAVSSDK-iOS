//
//  UdeskIndexViewController.m
//  UdeskAVSExample
//
//  Created by 陈历 on 2021/6/3.
//

#import "UdeskIndexViewController.h"
#import "UdeskProjectHeader.h"
#import <UdeskAVSSDK/UdeskAVSSDK.h>
#import "UdeskRoomViewController.h"

@interface UdeskIndexViewController () <UdeskAVSSDKDelegate>

@property (nonatomic, strong) UIImageView *topBgImageView;
@property (nonatomic, strong) UIView *bottomBgImageView;

@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *queueLabel;
@property (nonatomic, strong) UIButton *stopButton;
@property (nonatomic, strong) UdeskAVSAgentView *agentView;

@property (nonatomic, strong) UdeskAVSAgentInfo *agentInfo;
@property (nonatomic, strong) UdeskRoomViewController *roomViewController;

@property (nonatomic, strong) UIAlertController *alertController;

@end

@implementation UdeskIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupView];
    
    [self udeskLayout];
    [self initState];
    
    //开始呼叫
    
    [[UdeskAVSSDKManager sharedInstance] registerDelgate:self];
    [[UdeskAVSSDKManager sharedInstance] call];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHandOffNotifycation:) name:kUdeskGlobalMessageHandOff object:nil];
    
    // Do any additional setup after loading the view.
}
- (void)udeskLayout{
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = w*180/375;
    self.topBgImageView.frame = CGRectMake(0, 0, w, kScreenHeight - h);
    self.bottomBgImageView.frame = CGRectMake(0, kScreenHeight-h, w, h);
    
    self.tipLabel.frame = CGRectMake(16, 0, kScreenWidth - 80, 56);
    self.queueLabel.frame = CGRectMake(0, 84, kScreenWidth, 24);
    self.stopButton.frame = CGRectMake(kScreenWidth - 65, 0, 65, 56);
    self.agentView.frame = CGRectMake(16, 72, kScreenWidth - 32, 50);
}

- (void)initState{
    self.tipLabel.text = @"正在发起呼叫...";
    self.queueLabel.hidden = YES;
    self.agentView.hidden = NO;
    if ([UdeskAVSSDKManager sharedInstance].callProcessUrl.length) {
        [self.topBgImageView ud_setImageWithURL:[UdeskAVSSDKManager sharedInstance].callProcessUrl.convertToURL];
    }
}

#pragma mark -
- (void)getHandOffNotifycation:(NSNotification *)notify{
    NSLog(@"getHandOffNotifycation");
    self.alertController = [UIAlertController udeskShowSimpleAlert:@"是否结束当前通话？" onViewController:self.navigationController completion:^(int value) {
        if (value == 0) {
            [self.roomViewController sendBye];
            [self close];
        }
    }];
}

#pragma mark -
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
   
}
#pragma mark -
- (void)didGetRoomInfo:(UdeskAVSTRTCRoomInfo *)trtcInfo{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:trtcInfo forKey:@"roomInfo"];
    if (self.agentInfo) {
        [params setObject:self.agentInfo forKey:@"agent"];
    }
    UdeskRoomViewController *room = [[UdeskRoomViewController alloc] initWithRoom:params];
    [self.navigationController pushViewController:room animated:YES];
    self.roomViewController = room;
}

- (void)didGetAgentBusy:(NSDictionary *)trtcInfo{
    [UdeskAVSSDKManager destoryInstance];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"目前坐席繁忙,请您稍后重试" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *conform = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
        }];
    [alert addAction:conform];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)didWaitAnswer:(NSDictionary *)info
{
    self.tipLabel.text = [UdeskAVSSDKManager sharedInstance].waitScreenText;
    self.queueLabel.hidden = YES;
}

- (void)didUpdateAgentInfo:(nonnull UdeskAVSAgentInfo *)agent {
    //更新当前agent info
    self.agentInfo = agent;
    if (self.roomViewController) {
        [self.roomViewController updateAgentInfo:agent];
    }
    
    [self.agentView updateAgentInfo:agent];
    self.agentView.hidden = NO;
    self.tipLabel.text = [UdeskAVSSDKManager sharedInstance].waitScreenText;
    self.queueLabel.hidden = YES;
}


- (void)didUpdateQueueNumber:(NSInteger)queueNumber {
    self.tipLabel.text = [UdeskAVSSDKManager sharedInstance].queueTipsText;
    //更新当前排队号
    NSLog(@"didUpdateQueueNumber");
    self.agentView.hidden = YES;
    self.queueLabel.hidden = NO;
    self.queueLabel.text = [NSString stringWithFormat:@"您当前排在第%ld位,请您耐心等待...", queueNumber];
}

- (void)didAgentHangup:(nonnull NSDictionary *)info {
    //客服挂机
    [UIAlertController udeskShowAlert:@"客服已挂机" onViewController:self.navigationController completion:^{
        [self close];
    }];
}

- (void)didUpdateMessageList:(NSArray *)messageList{
    if (self.roomViewController) {
        [self.roomViewController updateMessageList:messageList];
    }
}

- (void)didGetError:(nonnull NSError *)error {
    //未知的严重错误
    NSLog(@"didGetError");
}
#pragma mark - Close
- (void)close{
    
    [UdeskAVSSDKManager destoryInstance];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - Private
- (void)setupView{
    [self.view addSubview:self.topBgImageView];
    [self.view addSubview:self.bottomBgImageView];
    
    [self.bottomBgImageView addSubview:self.stopButton];
    [self.bottomBgImageView addSubview:self.tipLabel];
    [self.bottomBgImageView addSubview:self.agentView];
    [self.bottomBgImageView addSubview:self.queueLabel];
}

#pragma mark - Event
- (void)stopButtonPressed{
    [UdeskAVSSDKManager destoryInstance];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Lazy
- (UIImageView *)topBgImageView{
    if (!_topBgImageView) {
        _topBgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _topBgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _topBgImageView.image = [UIImage udavs_imageNamed:@"waitback.png"];
    }
    return _topBgImageView;
}

- (UIButton *)stopButton{
    if (!_stopButton) {
        _stopButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_stopButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_stopButton setTitle:@"取消" forState:UIControlStateNormal];
        [_stopButton addTarget:self action:@selector(stopButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _stopButton;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.textColor = [UIColor colorWithWhite:0 alpha:0.85];
        _tipLabel.font = [UIFont systemFontOfSize:16];
    }
    return _tipLabel;
}

- (UILabel *)queueLabel{
    if (!_queueLabel) {
        _queueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _queueLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _queueLabel;
}

- (UdeskAVSAgentView *)agentView{
    if (!_agentView) {
        _agentView = [[UdeskAVSAgentView alloc] initWithFrame:CGRectZero];
    }
    return _agentView;
}

- (UIView *)bottomBgImageView{
    if (!_bottomBgImageView) {
        _bottomBgImageView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomBgImageView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomBgImageView;
}

- (void)dealloc{
    NSLog(@"%@ dealloc", [self class]);
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
