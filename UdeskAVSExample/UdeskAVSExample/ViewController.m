//
//  ViewController.m
//  UdeskAVSExample
//
//  Created by 陈历 on 2021/6/3.
//

#import "ViewController.h"

#import <UdeskAVSSDK/UdeskAVSHeader.h>

#import "ParamSetViewController.h"
#import "UAVSFloatWindowManager.h"
#import "CommonViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *dominTextField;
@property (weak, nonatomic) IBOutlet UITextField *sdkAppIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *agentTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property (weak, nonatomic) IBOutlet UITextField *webUrlTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *domain = @"https://baseavs.udesk.cn/avs";
    NSString *appId = @"DP8BD0dWUTvkOKGZ";
    NSString *agentId = @"445271";
    
    self.dominTextField.text = domain;
    self.sdkAppIdTextField.text = appId;
    self.agentTextField.text = agentId;
    self.codeTextField.text = [NSString stringWithFormat:@"demo%03X%03X", arc4random(), arc4random()];
    
    NSLog(@"UdeskAVSSDK 版本：%@", [UdeskAVSSDKManager sharedInstance].getSDKVersion);
    
    //实现最小化悬浮窗时的回调
    __weak typeof(self) weakSelf = self;
    [UAVSFloatWindowManager shared].tapBlock = ^{
        [[UAVSFloatWindowManager shared] hidBubble];
        if ([UdeskAVSConnector sharedInstance].isLeveling) {
            UIViewController *vc=  [weakSelf theTopviewControler];
            [[UdeskAVSConnector sharedInstance] screenShowOnViewController:vc];
            return;
        }
    };
}

-(UIViewController *)theTopviewControler {
    UIViewController *rootVC = [[UIApplication sharedApplication] keyWindow].rootViewController;
    
    UIViewController *parent = rootVC;
    while ((parent = rootVC.presentedViewController) != nil ) {
        rootVC = parent;
    }
    
    while ([rootVC isKindOfClass:[UINavigationController class]]) {
        rootVC = [(UINavigationController *)rootVC topViewController];
    }
    
    return rootVC;
}

- (IBAction)startCall:(id)sender {
    
    if ([UdeskAVSConnector sharedInstance].isLeveling) {
        [[UAVSFloatWindowManager shared] hidBubble];
        [[UdeskAVSConnector sharedInstance] screenShowOnViewController:self];
        return;
    }
    
    
    if(![self baseCheck]){
        return;
    }
    

    NSString *domin = self.dominTextField.text;// @"https://avs.t2.tryudesk.com/avs/";
    NSString *agentId = self.agentTextField.text;
    NSString *code = self.codeTextField.text;
    NSString *sdkAppid = self.sdkAppIdTextField.text;

    UdeskAVSParams *params = [[UdeskAVSParams alloc] init];
    params.udeskDomin = domin ?: @"";
    params.sdkAppId = sdkAppid ?: @"";
    params.customCode = code ?: @"";
    params.agentId = agentId ?: @"";
    
    UdeskAVSConfig *config = [UdeskAVSConfig defaultConfig];
    config.sdkParam = params;
    config.willMinViewBlock = ^BOOL(UIViewController *controller) {
        /**
        //此处可以做 view 缩小到 浮窗 的UI动画。
         [[UdeskAVSConnector sharedInstance].baseUavsViewController dismissViewControllerAnimated:NO completion:nil];
         return NO;
         */
        [[UAVSFloatWindowManager shared] showBubble];//demo 实现了一个悬浮窗效果，仅供参考。
        return YES;
       
    };

    [[UdeskAVSConnector sharedInstance] presentUdeskOnViewController:self
                                                           sdkConfig:config
                                                          completion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"error = %@", error);
        }
        else{
            NSLog(@"start call....");
        }
        
    }];

    
}


- (IBAction)paramSetting:(id)sender {
    
    if(![self baseCheck]){
        return;
    }
    
    ParamSetViewController*setVC = [ParamSetViewController new];
    
    NSString *domin = self.dominTextField.text;// @"https://avs.t2.tryudesk.com/avs/";
    NSString *agentId = self.agentTextField.text;
    NSString *code = self.codeTextField.text;
    NSString *sdkAppid = self.sdkAppIdTextField.text;

    UdeskAVSParams *params = [[UdeskAVSParams alloc] init];
    
    //基础参数： 域名、appId、customCode
    params.udeskDomin = domin;
    params.sdkAppId = sdkAppid;
    params.customCode = code;
    params.agentId = agentId;
    
    setVC.params = params;
    setVC.modalPresentationStyle = 0;
    [self presentViewController:setVC animated:YES completion:nil];
    
}

- (IBAction)openWeb:(id)sender {
    
    if (!self.webUrlTextField.text.length) {
        return;
    }
    
    if (![NSURL URLWithString:self.webUrlTextField.text]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"非法Url"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *conform = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:conform];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    CommonViewController *vc = [CommonViewController new];
    vc.url = self.webUrlTextField.text;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    nvc.modalPresentationStyle = 0;
    [self presentViewController:nvc animated:YES completion:nil];
    
}

- (BOOL)baseCheck
{

    NSString *domin = self.dominTextField.text;// @"https://avs.t2.tryudesk.com/avs/";
    NSString *agentId = self.agentTextField.text;
    NSString *code = self.codeTextField.text;
    NSString *sdkAppid = self.sdkAppIdTextField.text;

    if(!domin.length || !code.length || !sdkAppid.length){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请填写必要信息"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *conform = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:conform];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
