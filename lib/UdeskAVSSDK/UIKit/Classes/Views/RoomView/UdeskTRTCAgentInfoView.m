//
//  UdeskTRTCAgentInfoView.m
//  UdeskAvsSDKDemo
//
//  Created by 陈历 on 2021/5/29.
//

#import "UdeskTRTCAgentInfoView.h"
#import "UdeskProjectHeader.h"

@interface UdeskTRTCAgentInfoView ()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *agentLabel;

@end

@implementation UdeskTRTCAgentInfoView

- (instancetype)initWithFrame:(CGRect)frame context:(nonnull UdeskRoomViewModel *)context{
    if (self = [super initWithFrame:frame context:context]) {
        [self setupViews];
        [self addObservers:@[
            NSStringFromSelector(@selector(zoomMode)),
            NSStringFromSelector(@selector(agentName)),
            NSStringFromSelector(@selector(agentAvatar))
        ]];
    }
    return self;
}

- (void)setupViews{
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    headerImageView.image = [UIImage udavs_imageNamed:@"kefu"];
    headerImageView.layer.cornerRadius = 16.0;
    headerImageView.clipsToBounds = YES;
    [self addSubview:headerImageView];
    self.headerImageView = headerImageView;
    
    UILabel *agentLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 150, 32)];
    agentLabel.text = @"";
    agentLabel.textColor = [UIColor whiteColor];//[UIColor colorWithRed:0 green:0 blue:0 alpha:0.45];
    agentLabel.textAlignment = NSTextAlignmentLeft;
    agentLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:agentLabel];
    self.agentLabel = agentLabel;
}

- (void)zoomModeChanged:(NSNumber *)zoomMode{
    if (zoomMode.intValue == 1) {
        self.hidden = NO;
    }
    else{
        self.hidden = YES;
    }
}

- (void)agentAvatarChanged:(NSString *)avatar{
    [self.headerImageView ud_setImageWithURL:avatar.convertToURL];
}

- (void)agentNameChanged:(NSString *)name{
    self.agentLabel.text = name;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
