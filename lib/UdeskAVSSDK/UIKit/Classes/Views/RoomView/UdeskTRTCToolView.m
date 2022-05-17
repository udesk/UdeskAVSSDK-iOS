//
//  UdeskTRTCToolView.m
//  UdeskAvsSDKDemo
//
//  Created by 陈历 on 2021/5/29.
//

#import "UdeskTRTCToolView.h"
#import "UdeskProjectHeader.h"

@interface  UdeskTRTCToolView()

@property (nonatomic, strong) UIStackView *bgView;

@property (nonatomic, strong) UIButton *muteButton;
@property (nonatomic, strong) UIButton *stopVideoButton;
@property (nonatomic, strong) UIButton *cameraSwitchButton;


@end

@implementation UdeskTRTCToolView

- (instancetype)initWithFrame:(CGRect)frame context:(UdeskRoomViewModel *)context{
    if (self = [super initWithFrame:frame context:context]) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.alpha = 0.8;
        [self setupViews];
        [self addObservers:@[
            NSStringFromSelector(@selector(zoomMode)),
            NSStringFromSelector(@selector(mute)),
            NSStringFromSelector(@selector(stopVideo)),
            NSStringFromSelector(@selector(cameraSwitch))
        ]];
    }
    return self;
}

- (void)setupViews{
    UIStackView *sView = [[UIStackView alloc] initWithArrangedSubviews:[self createButtons]];
    sView.frame = self.bounds;
    sView.axis = UILayoutConstraintAxisHorizontal;
    sView.alignment = UIStackViewAlignmentCenter;
    sView.distribution = UIStackViewDistributionFillEqually;
    [self addSubview:sView];
    self.bgView = sView;
}

- (NSArray *)createButtons{
    NSMutableArray *views = [NSMutableArray arrayWithCapacity:0];
    
    UIButton *chat = [self createButton:@"zoomin" selectedImage:@"zoomin" tag:UDESK_VIDEO_TOOL_ACTION_TYPE_ZOOM];
    [views addObject:chat];
    
    UIButton *mute = [self createButton:@"mic-on-white" selectedImage:@"mic-off" tag:UDESK_VIDEO_TOOL_ACTION_TYPE_MICRO];
    [views addObject:mute];
    self.muteButton = mute;
    
    UIButton *enableVideo = [self createButton:@"cam-on-white" selectedImage:@"cam-off" tag:UDESK_VIDEO_TOOL_ACTION_TYPE_ENABLE_VIDEO];
    [views addObject:enableVideo];
    self.stopVideoButton = enableVideo;
    
    UIButton *switchCamera = [self createButton:@"switch-white" selectedImage:@"switch-white" tag:UDESK_VIDEO_TOOL_ACTION_TYPE_EXCHANGE];
    [views addObject:switchCamera];
    
    UIButton *handoff = [self createButton:@"hangup" selectedImage:@"hangup" tag:UDESK_VIDEO_TOOL_ACTION_TYPE_HANDOFF];
    [views addObject:handoff];
    
    return views;
}

- (UIButton *)createButton:(NSString *)normalImage selectedImage:(NSString *)selectImage tag:(NSInteger)tag{
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/4.0 , 40)];
    [button setImage:[[UIImage udavs_imageNamed:normalImage] udeskImageByScalingToSize:CGSizeMake(24, 24)] forState:UIControlStateNormal];
    [button setImage:[[UIImage udavs_imageNamed:selectImage] udeskImageByScalingToSize:CGSizeMake(24, 24)] forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    button.layer.cornerRadius = 4.0;
    return button;
}

- (void)buttonPressed:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(doToolBarAction:)]) {
        [self.delegate doToolBarAction:sender.tag];
        return;
    }
}

- (void)muteChanged:(NSNumber *)mute{
    self.muteButton.selected = mute.boolValue;
}

- (void)stopVideoChanged:(NSNumber *)stopVideo{
    self.stopVideoButton.selected = stopVideo.boolValue;
}

- (void)cameraSwitchChanged:(NSNumber *)cameraSwitch{
    self.cameraSwitchButton.selected = cameraSwitch.boolValue;
}


- (void)zoomModeChanged:(NSNumber *)zoomMode{
    self.bottom = kUdeskScreenNavBarHeight + kScreenWidth/2.0;
    if (zoomMode.intValue == UDESK_AVS_VIDEO_MODE_VIDEO_FULLSCREEN) {
        self.hidden = YES;
    }
    else{
        self.hidden = NO;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
