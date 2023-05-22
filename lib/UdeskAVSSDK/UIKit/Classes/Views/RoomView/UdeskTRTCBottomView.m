//
//  UdeskTRTCBottomView.m
//  UdeskAvsSDKDemo
//
//  Created by 陈历 on 2021/5/28.
//

#import "UdeskTRTCBottomView.h"
#import "UdeskAVSSDK.h"
#import "UdeskAVSMacroHeader.h"
#import "UAVSChatBaseLayout.h"

//#import "UdeskProjectHeader.h"
#import "UIView+UdeskAVS.h"
#import "UIImage+UdeskAVS.h"
#import "UIImageView+UdeskAVS.h"
#import "NSString+UdeskAVS.h"
#import "UIColor+UdeskAVS.h"
#import "UdeskAVSMacroHeader.h"
#import "UdeskAVSEnumHeader.h"
#import "UAVSProtocolHeader.h"
#import "UdeskRoomViewModel.h"
#import "UdeskAVSConnector.h"
#import "UdeskAVSBundleUtils.h"

@interface UdeskTRTCBottomView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *partMessageTableView;
@property (nonatomic, strong) UIView *toolsBgView;


@property (nonatomic, strong) UIButton *stopVideoButton;
@property (nonatomic, strong) UIButton *muteButton;
@property (nonatomic, strong) UIButton *cameraSwitchButton;


@property (nonatomic, strong) NSArray *messageList;

@property (nonatomic, strong) UIButton *shareViewButton;

@end

@implementation UdeskTRTCBottomView

- (instancetype)initWithFrame:(CGRect)frame context:(UdeskRoomViewModel *)context{
    if (self = [super initWithFrame:frame context:context]) {
        [self setupViews];
        [self addObservers:@[NSStringFromSelector(@selector(zoomMode)),
                             NSStringFromSelector(@selector(messageList)),
                             NSStringFromSelector(@selector(mute)),
                             NSStringFromSelector(@selector(stopVideo)),
                             NSStringFromSelector(@selector(isViewShare)),
                             NSStringFromSelector(@selector(cameraSwitch))
        ]];
    }
    return self;
}

- (void)setupViews{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(12, 0, 176, 104)];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.partMessageTableView = tableView;
    [self addSubview:tableView];
    [tableView reloadData];
    
    UIStackView *sView = [[UIStackView alloc] initWithArrangedSubviews:[self createButtonViews]];
    sView.axis = UILayoutConstraintAxisHorizontal;
    sView.alignment = UIStackViewAlignmentCenter;
    sView.distribution = UIStackViewDistributionFillEqually;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 276, 40)];
    bgView.bottom = self.height - 16 - kUdeskScreenTabBarSafeAreaHeight;
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 20.0;
    bgView.centerX = self.centerX;

    [self addSubview:bgView];
    self.toolsBgView = bgView;
    
    sView.frame = bgView.bounds;
    [self.toolsBgView addSubview:sView];
    
    if (@available(iOS 13.0, *)) { // ios 13+ 才支持屏幕分享
        UdeskAVSConfig *config = [UdeskAVSConnector sharedInstance].sdkConfig;
        if (config.isScreenShare) {
            self.shareViewButton = [[UIButton alloc] initWithFrame:CGRectMake(self.toolsBgView.right - 42, self.toolsBgView.top - 50, 40, 40)];
            self.shareViewButton.backgroundColor = [UIColor clearColor];
            self.shareViewButton.tag = UDESK_VIDEO_TOOL_ACTION_TYPE_SHARE_VIEW;
            [self.shareViewButton setBackgroundImage:[UIImage udavs_imageNamed:@"shareView"] forState:UIControlStateNormal];
            [self.shareViewButton setBackgroundImage:[UIImage udavs_imageNamed:@"closeShare"] forState:UIControlStateSelected];
            [self.shareViewButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.shareViewButton];
        }
    }
    
}

- (NSArray *)createButtonViews{
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:0];
    
    {
        UIButton *chat = [self createButton:@"zoomout" selectedImage:@"zoomout" tag:UDESK_VIDEO_TOOL_ACTION_TYPE_ZOOM];
        [buttons addObject:chat];
    }
    {
        UIButton *info = [self createButton:@"talk" selectedImage:@"talk" tag:UDESK_VIDEO_TOOL_ACTION_TYPE_INFO];
        [buttons addObject:info];
    }
    {
        UIButton *mute = [self createButton:@"mic-on" selectedImage:@"mic-off" tag:UDESK_VIDEO_TOOL_ACTION_TYPE_MICRO];
        [buttons addObject:mute];
        self.muteButton = mute;
    }
    {
        UIButton *video = [self createButton:@"cam-on" selectedImage:@"cam-off" tag:UDESK_VIDEO_TOOL_ACTION_TYPE_ENABLE_VIDEO];
        [buttons addObject:video];
        self.stopVideoButton = video;
    }
    {
        UIButton *exchange = [self createButton:@"switch" selectedImage:@"switch" tag:UDESK_VIDEO_TOOL_ACTION_TYPE_EXCHANGE];
        [buttons addObject:exchange];
        self.cameraSwitchButton = exchange;
    }
    {
        UIButton *handoff = [self createButton:@"hangup" selectedImage:@"hangup" tag:UDESK_VIDEO_TOOL_ACTION_TYPE_HANDOFF];
        [buttons addObject:handoff];
    }
   
    return buttons;
}

- (UIButton *)createButton:(NSString *)normalImage selectedImage:(NSString *)selectImage tag:(NSInteger)tag{
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24 , 24)];
    [button setImage:[[UIImage udavs_imageNamed:normalImage] udeskImageByScalingToSize:CGSizeMake(24, 24)] forState:UIControlStateNormal];
    [button setImage:[[UIImage udavs_imageNamed:selectImage] udeskImageByScalingToSize:CGSizeMake(24, 24)] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    button.layer.cornerRadius = 4.0;
    return button;
}

- (void)buttonPressed:(UIButton *)sender{
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(doToolBarAction:)]) {
        [self.delegate doToolBarAction:sender.tag];
        return;
    }
}

#pragma mark ---
- (void)zoomModeChanged:(NSNumber *)zoomMode{
    if (zoomMode.intValue == 2) {
        self.hidden = YES;
    }
    else{
        self.hidden = NO;
    }
}
- (void)messageListChanged:(NSArray *)messageList{
    //少于4个消息的话，插空值填满
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:messageList];
    if (tmpArray.count >= 4) {
        self.messageList = [tmpArray subarrayWithRange:NSMakeRange(tmpArray.count - 4, 4)];
    }
    else{
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        //比4个少几个
        NSInteger number = 4 - tmpArray.count;
        for (int i = 0; i<number; i++) {
            [array addObject:[NSNull null]];
        }
        [array addObjectsFromArray:tmpArray];
        self.messageList = tmpArray;
    }

    [self.partMessageTableView reloadData];
    self.partMessageTableView.hidden = (self.messageList.count == 0);
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

- (void)isViewShareChanged:(NSNumber *)isViewShare
{
    self.shareViewButton.selected = [isViewShare boolValue];
}

#pragma mark UITableViewDelegate/UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    if (section < 4) {
        return 4.0;
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        return 20;
    }
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.messageList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id obj = [self.messageList objectAtIndex:indexPath.section];
    if ([obj isKindOfClass:[NSNull class]]) {
        return [self tableView:tableView getEmptyCellForRowAtIndexPath:indexPath];
    }
    else{
        return [self tableView:tableView getContentCellForRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(doToolBarAction:)]) {
        [self.delegate doToolBarAction:UDESK_VIDEO_TOOL_ACTION_TYPE_INFO];
        return;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView getEmptyCellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier_empty";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView getContentCellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UAVSChatBaseLayout *layout = (UAVSChatBaseLayout *)[self.messageList objectAtIndex:indexPath.section];
    if ([layout isKindOfClass:[NSNull class]]) {
        static NSString *identifier = @"identifier_clear";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    else{
        static NSString *identifier = @"identifier_info";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25];
            cell.layer.cornerRadius = 6.0;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        UIImageView *imageView = [self imageViewInCell:cell];
        UILabel *titleLabel = [self textLabelViewInCell:cell];
        UdeskAVSBaseMessage *message = layout.message;
        if (message.fromType == UdeskAVSMessageFromTypeAgent) {
            [imageView ud_setImageWithURL:message.agentAvtarUrl.convertToURL placeholderImage:[UIImage udavs_imageNamed:@"kefu"]];
        }
        else{
            imageView.image = [UIImage udavs_imageNamed:@"customer"];
        }
        if (message.messageType == UdeskAVSMessageContentTypeText) {
            titleLabel.text = [NSString stringWithFormat:@"%@", layout.message.content];
            titleLabel.textColor = [UIColor whiteColor];
        }
        else if (message.messageType == UdeskAVSMessageContentTypeImage) {
            
            titleLabel.attributedText = [[NSAttributedString alloc] initWithString:getUDAVSLocalizedString(@"uavs_msg_type_IMG") attributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]}];
        }
        return cell;
    }
   
    
}

- (UIImageView *)imageViewInCell:(UITableViewCell *)cell{
    UIImageView *iv = [cell.contentView viewWithTag:100];
    if (!iv) {
        iv = [[UIImageView alloc] initWithFrame:CGRectMake(4, 2, 16, 16)];
        iv.tag = 100;
        iv.layer.cornerRadius = 10.0;
        iv.layer.masksToBounds = YES;
        [cell.contentView addSubview:iv];
    }
    return iv;
}

- (UILabel *)textLabelViewInCell:(UITableViewCell *)cell{
    UILabel *textLabel = [cell.contentView viewWithTag:101];
    if (!textLabel) {
        textLabel =  [[UILabel alloc] initWithFrame:CGRectMake(24, 0, self.width  - 24, 20)];
        textLabel.font = [UIFont systemFontOfSize:12];
        textLabel.tag = 101;
        textLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:textLabel];
    }
    return textLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
