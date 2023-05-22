//
//  UdeskTRTCTimerView.m
//  UdeskAvsSDKDemo
//
//  Created by 陈历 on 2021/5/29.
//

#import "UdeskTRTCTimerView.h"
#import "UdeskProjectHeader.h"
#import "UdeskAVSBundleUtils.h"

@interface UdeskTRTCTimerView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, strong) NSDate *startDate;


@end

@implementation UdeskTRTCTimerView

- (instancetype)initWithFrame:(CGRect)frame context:(nonnull UdeskRoomViewModel *)context{
    if (self = [super initWithFrame:frame context:context]) {
        self.startDate = [NSDate date];
        [self setupViews];
        [self addObservers:@[NSStringFromSelector(@selector(zoomMode))]];
        [self startLoop];
    }
    return self;
}

- (void)startLoop{
    NSTimeInterval delt = [[NSDate date] timeIntervalSince1970] - [self.startDate timeIntervalSince1970];
    self.timerLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)(delt/60),(int)((int)delt%60)];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf startLoop];
    });
}

- (void)setupViews{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height - 44, kScreenWidth, 44)];
    label.text = getUDAVSLocalizedString(@"uavs_tip_talkWithAgent");
    label.font = [UIFont boldSystemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.titleLabel = label;
    
    UILabel *timerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    timerLabel.text = @"";
    timerLabel.textColor = [UIColor whiteColor];
    timerLabel.textAlignment = NSTextAlignmentCenter;
    timerLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:timerLabel];
    self.timerLabel = timerLabel;
    
}

- (void)zoomModeChanged:(NSNumber *)zoomMode{
    if (zoomMode.intValue == UDESK_AVS_VIDEO_MODE_VIDEO_FULLSCREEN) {
        self.backgroundColor = [UIColor clearColor];
        self.timerLabel.frame = CGRectMake(0, self.height - 44, kScreenWidth, 44);
        self.titleLabel.hidden = YES;
    }
    else if(zoomMode.intValue == UDESK_AVS_VIDEO_MODE_VIDEO_SMALL){
        self.backgroundColor = [UIColor whiteColor];
        self.timerLabel.frame = CGRectMake(kScreenWidth - 60, self.height - 44, 64, 44);
        self.titleLabel.hidden = NO;
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
