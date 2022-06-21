//
//  ParamSetViewController.m
//  UdeskAVSExample
//
//  Created by Admin on 2022/6/21.
//

#import "ParamSetViewController.h"

#import "UdeskAVSHeader.h"
#import "UdeskProjectHeader.h"
#import "UAVSFloatWindowManager.h"


@interface ParamSetViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *mainVIew;

@property (weak, nonatomic) IBOutlet UITextField *nickNameT;
@property (weak, nonatomic) IBOutlet UITextField *avatarT;
@property (weak, nonatomic) IBOutlet UITextField *emailT;
@property (weak, nonatomic) IBOutlet UITextField *customLevelT;
@property (weak, nonatomic) IBOutlet UITextField *telephonesT;
@property (weak, nonatomic) IBOutlet UITextField *tagsT;
@property (weak, nonatomic) IBOutlet UITextField *use_descriptionT;
@property (weak, nonatomic) IBOutlet UITextField *customFieldsT;

@property (weak, nonatomic) IBOutlet UITextField *agentGroupIdT;
@property (weak, nonatomic) IBOutlet UITextField *customChannelT;

@property (weak, nonatomic) IBOutlet UITextField *noteInfo_titleT;
@property (weak, nonatomic) IBOutlet UITextField *noteInfo_customFieldsT;

@property (weak, nonatomic) IBOutlet UISwitch *isScreenS;
@property (weak, nonatomic) IBOutlet UISwitch *isMineS;

@end

@implementation ParamSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.mainVIew addGestureRecognizer:tap];
    
}


- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)fullClick:(id)sender {
    
    //设置客户信息
    self.nickNameT.text = @"测试客户姓名2";
    self.avatarT.text = @"https://c-ssl.duitang.com/uploads/blog/202107/09/20210709142454_dc8dc.jpeg";
    self.emailT.text = @"testzsy@test.cn";
    self.customLevelT.text = @"1";
    self.telephonesT.text = @"18812345678";
    self.tagsT.text = @"少年,学生,男人";
    self.use_descriptionT.text = @"这是iOSDdkDemo的客户描述";
    self.customFieldsT.text = @"name:哇哈哈;age:18";
    
    //设置客服信息
    self.agentGroupIdT.text = @"112";
    self.customChannelT.text = @"iosSDK";
    
    //设置业务记录
    self.noteInfo_titleT.text = @"iosSDK业务记录主题";
    self.noteInfo_customFieldsT.text = @"city:0,1,2;location:0.1.2";

    
}


- (IBAction)clearClick:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定清空所有参数"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *conform = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.nickNameT.text = @"";
        self.avatarT.text = @"";
        self.emailT.text = @"";
        self.customLevelT.text = @"";
        self.telephonesT.text = @"";
        self.tagsT.text = @"";
        self.use_descriptionT.text = @"";
        self.customFieldsT.text = @"";
        
        self.agentGroupIdT.text = @"";
        self.customChannelT.text = @"";
        
        self.noteInfo_titleT.text = @"";
        self.noteInfo_customFieldsT.text = @"";

    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:conform];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];

    
}
- (IBAction)callClick:(id)sender {
    
    if ([UdeskAVSConnector sharedInstance].isLeveling) {
        [[UAVSFloatWindowManager shared] hidBubble];
        [[UdeskAVSConnector sharedInstance] screenShowOnViewController:self];
        return;
    }
    
    UdeskAVSParams * params = [self getVCParam];
    UdeskAVSConfig *config = [UdeskAVSConfig defaultConfig];
    config.sdkParam = params;
    
    config.isScreenShare = self.isScreenS.isOn;
    config.isMiniView = self.isMineS.isOn;
    
    
    config.willMinViewBlock = ^BOOL(UIViewController *controller) {
        [[UAVSFloatWindowManager shared] showBubble];
        return YES;
        
        /**
         //此处可以做 view 缩小到 浮窗 的UI动画。
         [[UdeskAVSConnector sharedInstance].baseUavsViewController dismissViewControllerAnimated:NO completion:nil];
         return NO;
         */
    
    };
    
#if 1
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
#elif 0
    
    config.sdkParam = nil;
    [[UdeskAVSConnector sharedInstance] presentUdeskOnViewController:self
                                                           sdkConfig:config
                                                          completion:^(NSError * _Nullable error) {
        
    }];
    
    UdeskRoomViewController *room = [[UdeskRoomViewController alloc] initWithRoom:@{}];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:room];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [UdeskAVSConnector sharedInstance].baseUavsViewController = nav;
    
    [self presentViewController:nav animated:YES completion:nil];
    
    
#else
    UdeskIndexViewController *index = [[UdeskIndexViewController alloc] init];
    index.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:index animated:YES completion:^{
        
    }];
#endif
    
}

- (UdeskAVSParams *)getVCParam
{
    
    UdeskAVSParams *params = [[UdeskAVSParams alloc] init];
    
    //基础参数： 域名、appId、customCode
    params.udeskDomin = self.params.udeskDomin;
    params.sdkAppId = self.params.sdkAppId;
    params.customCode = self.params.customCode;
    params.agentId = self.params.agentId;
    
    
    if (self.nickNameT.text.length) {
        params.nickName = self.nickNameT.text;
    }
    
    if (self.avatarT.text.length) {
        params.avatar = self.avatarT.text;
    }
    
    if (self.emailT.text.length) {
        params.email = self.emailT.text;
    }
    
    if (self.customLevelT.text.length) {
        params.customLevel = [self.customLevelT.text integerValue] == 1 ? UdeskAVSCustomLevelTypeVIP : UdeskAVSCustomLevelTypeNormal;
    }
    
    if (self.telephonesT.text.length) {
        NSArray *phones = [self.telephonesT.text componentsSeparatedByString:@","];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSString *phone in phones) {
            [arr addObject:@{@"content":phone}];
        }
        params.telephones = arr;
    }
    
    
    if (self.tagsT.text.length) {
        params.tags = self.tagsT.text;
    }
    
    if (self.use_descriptionT.text.length) {
        params.use_description = self.use_descriptionT.text;
    }
    
    if (self.customFieldsT.text.length) {
        NSArray *fields = [self.customFieldsT.text componentsSeparatedByString:@";"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (NSString *field in fields) {
            NSArray *tmp = [field componentsSeparatedByString:@":"];
            if (tmp.count == 2) {
                dic[tmp[0]]= tmp[1];
            }
        }
        params.customFields = dic;
    }
    
    
    
    if (self.agentGroupIdT.text.length) {
        params.agentGroupId = self.agentGroupIdT.text;
    }
    if (self.customChannelT.text.length) {
        params.customChannel = self.customChannelT.text;
    }
    
    
    if (self.noteInfo_titleT.text.length) {
        params.noteInfo_title = self.noteInfo_titleT.text;
    }
    if (self.noteInfo_customFieldsT.text.length) {
        NSArray *fields = [self.noteInfo_customFieldsT.text componentsSeparatedByString:@";"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (NSString *field in fields) {
            NSArray *tmp = [field componentsSeparatedByString:@":"];
            if (tmp.count == 2) {
                dic[tmp[0]]= tmp[1];
            }
        }
        params.noteInfo_customFields = dic;
    }
    

    return params;
}


@end
