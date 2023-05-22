//
//  UdeskSurveyView.m
//  UdeskSDK
//
//  Created by xuchen on 2018/4/9.
//  Copyright © 2018年 Udesk. All rights reserved.
//

#import "UAVSSurveyView.h"
#import "UAVSSurveyTitleView.h"
#import "UdeskProjectHeader.h"
#import "UAVSStringSizeUtil.h"
#import "UdeskAVSBundleUtils.h"
#import "UAVSToast.h"
#import "UAVSStringSizeUtil.h"

#import "UAVSSurveyViewController.h"
#import "UdeskRoomViewController.h"
//#import "UdeskAVSChatViewController.h"

@interface UAVSSurveyView()<UdeskSurveyViewDelegate> {
    
    
}
@property (nonatomic, weak)UAVSSurveyViewController *surveyController;;

@property (nonatomic, strong) UAVSSurveyTitleView *titleView;
@property (nonatomic, strong) UAVSSurveyModel *surveyModel;

@property (nonatomic, copy  ) NSString *roomId;

@end

@implementation UAVSSurveyView

- (instancetype)initWithSurvey:(UAVSSurveyModel *)surveyModel roomId:(NSString *)roomId
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        _roomId = roomId;
        _surveyModel = surveyModel;
        [self setupUI];
        self.surveyModel = surveyModel;
        [self reloadSurveyView];
    }
    return self;
}

- (void)setupUI {
    
    self.userInteractionEnabled = YES;
    
    _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    
    _titleView = [[UAVSSurveyTitleView alloc] initWithFrame:CGRectZero];
    [_titleView.closeButton addTarget:self action:@selector(closeSurveyViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_titleView];
    
    _surveyContentView = [[UAVSSurveyContentView alloc] init];
    _surveyContentView.delegate = self;
    [_contentView addSubview:_surveyContentView];
}


//刷新UI
- (void)reloadSurveyView {
    
    self.surveyContentView.surveyModel = self.surveyModel;
    self.titleView.titleLabel.text = self.surveyModel.title;
    [self setNeedsLayout];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.surveyContentView.remarkTextView resignFirstResponder];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.surveyModel || self.surveyModel == (id)kCFNull) return ;
    
    CGFloat surveyOptionHeight = 0;
    
    if (self.surveyModel.judgmentSet) {
        surveyOptionHeight += kUAVSSurveyStarOptionHeight;
    }

    if (self.surveyModel.resolveSet) {
        NSArray *array = self.surveyModel.resolveSet.resolveSetOptions;
        surveyOptionHeight += array.count * ((kUAVSTextSurveyButtonToVerticalEdgeSpacing+kUAVSTextSurveyButtonHeight)) - kUAVSTextSurveyButtonToVerticalEdgeSpacing;
        surveyOptionHeight += kUAVSSurveyExpressionOptionHeight;
    }

    CGFloat tagsHeight = [self tagsHeight];
    
    CGFloat tagsCollectionHeight = tagsHeight > kUAVSSurveyTagsCollectionViewMaxHeight ? kUAVSSurveyTagsCollectionViewMaxHeight : tagsHeight;
    
    CGFloat surveyButtonSpacing = surveyOptionHeight ? kUAVSTextSurveyButtonToVerticalEdgeSpacing : 0;
    CGFloat tagsCollectionViewSpacing = tagsCollectionHeight ? kUAVSSurveyCollectionViewItemToVerticalEdgeSpacing : 0;
    
    CGFloat remarkHeight = kUAVSSurveyRemarkTextViewMaxHeight;
    CGFloat remarkPlaceholderHeight = [UAVSStringSizeUtil sizeWithText:self.surveyContentView.remarkTextView.placeholder font:[UIFont systemFontOfSize:15] size:CGSizeMake(self.contentView.width-(kUAVSSurveyContentSpacing*3), MAXFLOAT)].height + 15;
    
    if (!self.surveyContentView.remarkTextView.text.length) {
        remarkHeight = MAX(remarkPlaceholderHeight, kUAVSSurveyRemarkTextViewHeight);
    }
    
    CGFloat contentHeight = kUAVSSurveyTitleHeight + kUAVSTextSurveyButtonToVerticalEdgeSpacing + surveyOptionHeight + surveyButtonSpacing + tagsCollectionHeight + tagsCollectionViewSpacing + remarkHeight + kUAVSSurveySubmitButtonSpacing + kUAVSSurveySubmitButtonHeight + kUAVSSurveySubmitButtonSpacing;
    
//    if (!self.surveyModel.remarkEnabled.boolValue) {
//        contentHeight -= (remarkHeight+kUAVSSurveySubmitButtonSpacing);
//    }
//    else {
        
        UAVSSurveySetOptionModel *option = [self selectedJudgmentSetOption];
        if (option) {//remarkType
            if (option.remarkType == UAVSRemarkOptionTypeHide) {
                contentHeight -= (remarkHeight+kUAVSSurveySubmitButtonSpacing);
            }
        }
        else {
            contentHeight -= (remarkHeight+kUAVSSurveySubmitButtonSpacing);
        }
//    }
    
    contentHeight = udeskIPhoneXSeries ? contentHeight+34 : contentHeight;
    
    CGFloat contentTop = kUdeskScreenStatusHeight;
    
    self.contentView.frame = CGRectMake(0, 0, self.width, contentHeight);
    self.titleView.frame = CGRectMake(0, contentTop, self.contentView.width, kUAVSSurveyTitleHeight);
    self.surveyContentView.frame = CGRectMake(0, self.titleView.bottom, self.contentView.width, contentHeight - kUAVSSurveyTitleHeight);
}

//标签高度
- (CGFloat)tagsHeight {
    
    UAVSSurveySetOptionModel *optionModel = [self selectedJudgmentSetOption];
    if (!optionModel || optionModel == (id)kCFNull) return 0;
    
    if (!optionModel.labels.count) {
        return 0;
    }
    
    NSArray *array = optionModel.labels;
    return (ceilf(array.count/2.0)) * (kUAVSSurveyCollectionViewItemSizeHeight+kUAVSSurveyCollectionViewItemToVerticalEdgeSpacing) - kUAVSSurveyCollectionViewItemToVerticalEdgeSpacing;
    
}

//选择的选项
- (UAVSSurveySetOptionModel *)selectedJudgmentSetOption
{
    
    NSArray *selectedOption = [self.surveyModel.judgmentSet.judgmentSetOptions filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"optionId = %@",self.surveyContentView.selectedJudgmentSetOptionId]];
    UAVSSurveySetOptionModel *optionModel = selectedOption.firstObject;
    if (optionModel) {
        if ([optionModel isKindOfClass:[UAVSSurveySetOptionModel class]]) {
            return optionModel;
        }
    }
    
    return nil;
}


//选择的选项
- (UAVSSurveySetOptionModel *)selectedResolveSetOption
{
    
    NSArray *selectedOption = [self.surveyModel.resolveSet.resolveSetOptions filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"optionValue = %@",self.surveyContentView.selectedResolveSetOptionValue]];
    UAVSSurveySetOptionModel *optionModel = selectedOption.firstObject;
    if (optionModel) {
        if ([optionModel isKindOfClass:[UAVSSurveySetOptionModel class]]) {
            return optionModel;
        }
    }
    
    return nil;
}

#pragma mark - Button Action
- (void)clickSubmitSurvey:(UAVSSurveyContentView *)survey {
    
    [self.surveyContentView.remarkTextView resignFirstResponder];
    
    UAVSSurveySetOptionModel *judgmentOption = [self selectedJudgmentSetOption];
    UAVSSurveySetOptionModel *resolveOption = [self selectedResolveSetOption];
    
    if (!judgmentOption || !resolveOption) {
        [UAVSToast showToast:getUDAVSLocalizedString(@"udesk_survey_tips") duration:0.5f window:self];
        return;
    }
    
    if (judgmentOption.remarkType == UAVSRemarkOptionTypeRequired) {
        if (!self.surveyContentView.remarkTextView.text.length) {
            [UAVSToast showToast:getUDAVSLocalizedString(@"udesk_survey_remark_required") duration:0.5f window:self];
            return;
        }
    }

    if (self.surveyContentView.remarkTextView.text.length > 255) {
        [UAVSToast showToast:getUDAVSLocalizedString(@"udesk_survey_remark_max_num") duration:0.5f window:self];
        return;
    }
    
    //是否解决（自定义名称）是（自定义名称）、否（自定义名称）、未评价
    NSString * judgmentResolveResult = resolveOption.optionValue ?: @"未评价";
    //满意度 设定的自定义名称/未评价
    NSString *judgmentDesc = judgmentOption.optionName ?: @"未评价";
    
    //标签 显示标签的名称 可多选，逗号隔开
    NSString *judgmentLabels = [survey.selectedOptionTags componentsJoinedByString:@","];
    //备注 显示备注信息
    NSString *judgmentRemark = survey.remarkTextView.text;
    
    
    NSDictionary *parameters = @{
        @"roomId": self.roomId ?: @"",
        @"judgmentResolveResult":judgmentResolveResult?:@"",
        @"judgmentLabels":judgmentLabels?:@"",
        @"judgmentRemark":judgmentRemark?:@"",
        @"judgmentDesc":judgmentDesc ?: @"",
    };
    
    [[UdeskAVSSDKManager sharedInstance] submitSurvey:parameters completion:^(NSError * _Nonnull error) {
        NSString *string = getUDAVSLocalizedString(@"udesk_top_view_thanks_evaluation");
        if (error) {
            string = getUDAVSLocalizedString(@"udesk_top_view_failure");
        }
        
        [UAVSToast showToast:string duration:1.5f window:self];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self closeSurveyViewAction:nil];
        });
    }];
        
}

- (void)didUpdateContentView:(UAVSSurveyContentView *)survey {
    [self setNeedsLayout];
}

- (void)closeSurveyViewAction:(UdeskAVSButton *)button {
    [self.surveyContentView.remarkTextView resignFirstResponder];
    [self dismiss];
}

- (void)dismiss {
    [_surveyController dismissWithCompletion:nil];
}

- (void)dismissWithCompletion:(void (^)(void))completion {
    [_surveyController dismissWithCompletion:completion];
}

- (void)showWithBaseVC:(UIViewController *)baseVC
{
    
    if ([[UdeskAVSUtil currentViewController] isKindOfClass:[UAVSSurveyViewController class]]) {
        return;
    }
    
    UAVSSurveyViewController *surveyController = [[UAVSSurveyViewController alloc] init];
    
    surveyController.modalPresentationStyle = 0;
    [surveyController showSurveyView:self completion:nil];
    [baseVC.view endEditing:YES];
    [baseVC presentViewController:surveyController animated:YES completion:^{
        self.surveyController = surveyController;
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
