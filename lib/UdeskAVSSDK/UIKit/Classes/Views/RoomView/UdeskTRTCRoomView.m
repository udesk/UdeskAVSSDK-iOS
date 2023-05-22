//
//  UdeskTRTCRoomView.m
//  UdeskAvsSDKDemo
//
//  Created by 陈历 on 2021/5/28.
//

#import "UdeskTRTCRoomView.h"
#import <TXLiteAVSDK_TRTC/TRTCCloud.h>
#import "UdeskProjectHeader.h"

@interface UdeskTRTCRoomView () <TRTCCloudDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *localView;
@property (nonatomic, strong) UIView *remoteView;
@property (nonatomic, strong) UIView *remoteBgView;
@property (nonatomic, strong) UIView *localBgView;

@property (nonatomic, strong) TRTCCloud *trtcCloud;

@property (nonatomic, strong) UdeskAVSTRTCRoomInfo *roomInfo;

@end

@implementation UdeskTRTCRoomView

- (instancetype)initWithFrame:(CGRect)frame context:(UdeskRoomViewModel *)context{
    if (self = [super initWithFrame:frame context:context]) {
        self.userInteractionEnabled = YES;
        [self setupViews];
        [self addTapGesture];
        [self addObservers:@[
            NSStringFromSelector(@selector(zoomMode)),
            NSStringFromSelector(@selector(mute)),
            NSStringFromSelector(@selector(stopVideo)),
            NSStringFromSelector(@selector(isMainFaceSelf)),
            NSStringFromSelector(@selector(isViewShare)),
            NSStringFromSelector(@selector(cameraSwitch))
        ]];
    }
    return self;
}

- (void)setupViews{
    UIView *remoteView = [[UIView alloc] initWithFrame:self.bounds];
    remoteView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:remoteView];
    self.remoteView = remoteView;
    {
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:remoteView.bounds];
        backgroundView.contentMode = UIViewContentModeScaleAspectFill;
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.layer.masksToBounds = YES;
        [remoteView addSubview:backgroundView];
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin ;
        
        backgroundView.image = [UIImage udavs_imageNamed:@"waitback"];
        if ([UdeskAVSSDKManager sharedInstance].agentBackgroundUrl.isNotEmpty) {
            [backgroundView ud_setImageWithURL:[UdeskAVSSDKManager sharedInstance].agentBackgroundUrl.convertToURL];
        }
        
        self.remoteBgView = backgroundView;
    }
    
    {
        CGFloat height = 90/kScreenWidth*kScreenHeight;
        UIView *localView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 106, kUdeskScreenNavBarHeight, 90, height)];
        localView.backgroundColor = [UIColor blackColor];
        [self addSubview:localView];
        self.localView = localView;
        
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:localView.bounds];
        backgroundView.contentMode = UIViewContentModeScaleAspectFill;
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.layer.masksToBounds = YES;
        [localView addSubview:backgroundView];
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin ;
        if ([UdeskAVSSDKManager sharedInstance].customerBackgroundUrl.isNotEmpty) {
            [backgroundView ud_setImageWithURL:[UdeskAVSSDKManager sharedInstance].customerBackgroundUrl.convertToURL];
        }
        backgroundView.hidden = YES;
        self.localBgView = backgroundView;
    }
}

- (void)addTapGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMainViewAction:)];
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLocalViewAction:)];
    [self.localView addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLocalViewAction:)];
    [self.remoteView addGestureRecognizer:tap3];
    self.remoteView.userInteractionEnabled = NO;
    
}

- (void)enterRoom:(UdeskAVSTRTCRoomInfo *)info{
    NSString *userId = info.userId;
    int sdkAppId = info.sdkAppid;
    NSString *userSig = info.userSig;
    int roomId = info.roomId;

    _trtcCloud = [TRTCCloud sharedInstance];
    [TRTCCloud setLogLevel:TRTCLogLevelNone];
    [_trtcCloud setDelegate:self];
    
    TRTCParams *params = [[TRTCParams alloc] init];
    params.sdkAppId = sdkAppId;
    params.userId = userId;
    params.userSig = userSig;
    params.roomId = roomId;
    NSLog(@"[VIDEOCALL] sdkAppId = %@ userId=%@ roomId=%@", @(params.sdkAppId).stringValue, params.userId, @(params.roomId).stringValue);
    NSLog(@"[VIDEOCALL] userSig=%@", params.userSig);

    TRTCVideoEncParam *encPara = [TRTCVideoEncParam new];
    encPara.resMode = TRTCVideoResolutionModePortrait;
    encPara.videoResolution = TRTCVideoResolution_1280_720;
    encPara.videoBitrate = 1800;
    encPara.videoFps = 15;
    [_trtcCloud setVideoEncoderParam:encPara];
    
    [[_trtcCloud getBeautyManager] setBeautyStyle:TXBeautyStyleNature];
    [[_trtcCloud getBeautyManager] setBeautyLevel:4];
    [[_trtcCloud getBeautyManager] setWhitenessLevel:0];
    
    [_trtcCloud enterRoom:params appScene:TRTCAppSceneVideoCall];
    
    [_trtcCloud startLocalPreview:!self.context.cameraSwitch.boolValue view:self.localView];
}

- (void)mute:(BOOL)flag{
    [_trtcCloud muteLocalAudio:flag];
}
//self.context.cameraSwitch
- (void)startLocalView:(BOOL)flag{
    [_trtcCloud startLocalPreview:!self.context.cameraSwitch.boolValue view:self.localView];
}

- (void)dealloc{
    NSLog(@"dealloc %@", [self class]);
    [TRTCCloud destroySharedIntance];
}

#pragma mark - TRTCCloudDelegate
- (void)onError:(TXLiteAVError)errCode errMsg:(NSString *)errMsg extInfo:(nullable NSDictionary *)extInfo {
    NSLog(@"onError msg=%@", errMsg);
}

- (void)onEnterRoom:(NSInteger)result{
    NSLog(@"onEnterRoom = %@", @(result).stringValue);
}

- (void)onExitRoom:(NSInteger)reason{
    NSLog(@"onExitRoom = %@", @(reason).stringValue);
}

- (void)onUserVideoAvailable:(NSString *)userId available:(BOOL)available{
    NSLog(@"onUserVideoAvailable userId = %@ available=%@", userId, available?@"yes":@"no");
    if (userId && available) {
        [_trtcCloud startRemoteView:userId streamType:TRTCVideoStreamTypeBig view:self.remoteView];
    }
    [self.remoteBgView setHidden:available];
}

- (void)onFirstVideoFrame:(NSString *)userId streamType:(TRTCVideoStreamType)streamType width:(int)width height:(int)height{
    NSLog(@"onFirstVideoFrame = %@", userId);
    //本地摄像头数据达到
    if (!userId) {
        
    }
}

/**
 * 11.1 媒体录制回调
 *
 * @param errCode 错误码 0：初始化录制成功；-1：初始化录制失败；-2: 文件后缀名有误。
 * @param storagePath 录制文件存储路径
 */
- (void)onLocalRecordBegin:(NSInteger)errCode storagePath:(NSString *)storagePath
{
    NSLog(@"onError errCode =%ld", errCode);
}

#pragma mark - content change
- (void)zoomModeChanged:(NSNumber *)zoomMode{
    if (zoomMode.intValue == UDESK_AVS_VIDEO_MODE_VIDEO_SMALL) {
        self.height = kScreenWidth/2.0;
        self.top = kUdeskScreenNavBarHeight;
        CGFloat width = kScreenWidth/2.0;
        self.remoteView.frame = CGRectMake(0, 0, width, width);
        self.localView.frame = CGRectMake(width, 0, width, width);
    }
    else{
        self.height = kScreenHeight;
        self.top = 0;
        CGFloat height = 90/kScreenWidth*kScreenHeight;
        self.remoteView.frame = self.bounds;
        self.localView.frame = CGRectMake(kScreenWidth - 106, kUdeskScreenNavBarHeight, 90, height);
        if ([self.context.isMainFaceSelf boolValue]) {
            self.localView.frame = self.bounds;
            self.remoteView.frame = CGRectMake(kScreenWidth - 106, kUdeskScreenNavBarHeight, 90, height);
        }else{
            self.remoteView.frame = self.bounds;
            self.localView.frame = CGRectMake(kScreenWidth - 106, kUdeskScreenNavBarHeight, 90, height);
        }
        
    }
}

- (void)muteChanged:(NSNumber *)mute{
    if (!_trtcCloud) {
        return;
    }
    if (mute.boolValue) {
        [_trtcCloud stopLocalAudio];
    }
    else{
        [_trtcCloud startLocalAudio:TRTCAudioQualitySpeech];
    }
}

- (void)stopVideoChanged:(NSNumber *)stopVideo{
    if (!_trtcCloud) {
        return;
    }
    
    if(stopVideo.boolValue){
        [_trtcCloud stopLocalPreview];
        self.localBgView.hidden = NO;
    }else{
        [_trtcCloud startLocalPreview:!self.context.cameraSwitch.boolValue view:self.localView];
        self.localBgView.hidden = YES;
    }
    self.localBgView.hidden = !stopVideo.boolValue;
    
    if(![self.context.isViewShare boolValue]){    
        [_trtcCloud muteLocalVideo:stopVideo.boolValue];
    }
}

- (void)cameraSwitchChanged:(NSNumber *)flag{
    if (!_trtcCloud) {
        return;
    }
    
    [[_trtcCloud getDeviceManager] switchCamera:!flag.boolValue];
}

- (void)mainFaceSelfChanged:(NSNumber *)isMainFaceSelf{
    NSLog(@"context.isMainFaceSelf=%@", self.context.isMainFaceSelf);
    CGRect frameTmp = self.localView.frame;
    
    self.localView.frame = self.remoteView.frame;
    self.remoteView.frame = frameTmp;
    
    if (isMainFaceSelf.boolValue) {
        
        [self sendSubviewToBack:self.localView];
        self.localView.userInteractionEnabled = NO;
        self.remoteView.userInteractionEnabled = YES;

        [_trtcCloud setRemoteVideoStreamType:self.roomInfo.userId type:TRTCVideoStreamTypeSmall];
        //- (void)setRemoteRenderParams:(NSString *)userId streamType:(TRTCVideoStreamType)type params:(TRTCRenderParams *)params;
    }
    else{
        [self sendSubviewToBack:self.remoteView];
        self.localView.userInteractionEnabled = YES;
        self.remoteView.userInteractionEnabled = NO;
        [_trtcCloud setRemoteVideoStreamType:self.roomInfo.userId type:TRTCVideoStreamTypeBig];
    }
    
}

- (void)isViewShareChanged:(NSNumber *)isViewShare
{
    if (!_trtcCloud) {
        return;
    }
    
    if (@available(iOS 13.0, *)) {
        BOOL isShare = [isViewShare boolValue];
        if (isShare) {
            [_trtcCloud stopLocalPreview];
            [_trtcCloud muteLocalVideo:NO];
            TRTCVideoEncParam *encPara = [TRTCVideoEncParam new];
            encPara.resMode = TRTCVideoResolutionModePortrait;
            encPara.videoResolution = TRTCVideoResolution_1280_720;
            encPara.videoBitrate = 1600;
            encPara.videoFps = 10;
            [_trtcCloud startScreenCaptureInApp:TRTCVideoStreamTypeBig encParam:encPara];
        }else{
            
            [_trtcCloud stopScreenCapture];
            if(self.context.stopVideo.boolValue){
                [_trtcCloud stopLocalPreview];
                [_trtcCloud muteLocalVideo:YES];
            }else{
                [_trtcCloud startLocalPreview:!self.context.cameraSwitch.boolValue view:self.localView];
            }
            
        }
    }
    
}


- (void)tapMainViewAction:(id)tap
{
    if (self.mainTouchBlock) {
        self.mainTouchBlock();
    }
}

- (void)tapLocalViewAction:(id)tap
{
    if (self.context.isMainFaceSelf.boolValue) {
        self.context.isMainFaceSelf = @(0);
    }else{
        self.context.isMainFaceSelf = @(1);
    }
    [tap view].userInteractionEnabled = NO;
    //NSLog(@"222222=%@", self.context.isChatShowing);
}


@end
