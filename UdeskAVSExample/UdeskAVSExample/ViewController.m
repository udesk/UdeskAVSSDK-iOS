//
//  ViewController.m
//  UdeskAVSExample
//
//  Created by 陈历 on 2021/6/3.
//

#import "ViewController.h"

#import <UdeskAVSSDK/UdeskAVSHeader.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *dominTextField;
@property (weak, nonatomic) IBOutlet UITextField *sdkAppIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *agentTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

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
    
}

- (IBAction)startCall:(id)sender {
    
    

    NSString *domin = self.dominTextField.text;// @"https://avs.t2.tryudesk.com/avs/";
    NSString *agentId = self.agentTextField.text;
    NSString *code = self.codeTextField.text;
    NSString *sdkAppid = self.sdkAppIdTextField.text;

    UdeskAVSParams *params = [[UdeskAVSParams alloc] init];
    params.udeskDomin = domin;
    params.sdkAppId = sdkAppid;
    params.code = code;
    params.agentId = agentId;
    
    [[UdeskAVSConnector sharedInstance] presentUdeskOnViewController:self
                                                            params:params
                                                        completion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"error = %@", error);
        }
        else{
            NSLog(@"start call....");
        }
        
    }];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
