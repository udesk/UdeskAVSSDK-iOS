//
//  UdeskSurveyContentView.m
//  UdeskSDK
//
//  Created by xuchen on 2018/4/2.
//  Copyright © 2018年 Udesk. All rights reserved.
//

#import "UAVSSurveyContentView.h"
#import "UdeskProjectHeader.h"
#import "UAVSSurveyProtocol.h"
#import "UdeskAVSMacroHeader.h"
#import "UIView+UdeskAVS.h"
//#import "UdeskBundleUtils.h"
#import "UAVSStringSizeUtil.h"
#import "UdeskAVSBundleUtils.h"



/** 按钮间距 */
const CGFloat kUAVSTextSurveyButtonToVerticalEdgeSpacing = 20;
/** 按钮高度 */
const CGFloat kUAVSTextSurveyButtonHeight = 22;

const CGFloat kUAVSSurveyRemarkTextViewHeight = 60;
const CGFloat kUAVSSurveyRemarkTextViewMaxHeight = 120;
const CGFloat kUAVSSurveySubmitButtonSpacing = 35;
const CGFloat kUAVSSurveySubmitButtonHeight = 44;
const CGFloat kUAVSSurveyContentSpacing = 40;
const CGFloat kUAVSSurveyCollectionViewItemSizeHeight = 30;
const CGFloat kUAVSSurveyCollectionViewItemSizeWidth = 130;
const CGFloat kUAVSSurveyCollectionViewItemToVerticalEdgeSpacing = 20;
const CGFloat kUAVSSurveyTagsCollectionViewMinimumLineSpacing = 14;
const CGFloat kUAVSSurveyTagsCollectionViewMinimumInteritemSpacing = 5;
const CGFloat kUAVSSurveyTagsCollectionViewMaxHeight = 120;
const CGFloat kUAVSSurveyStarOptionHeight = 80;
const CGFloat kUAVSSurveyExpressionOptionHeight = 100;
const CGFloat kUAVSSurveyOptionToVerticalEdgeSpacing = 24;
const CGFloat kUAVSSurveyTitleHeight = 58;
const CGFloat kUAVSSurveyRemarkRequiredLabelToVerticalEdgeSpacing = 5;

static NSString *kUAVSSurveyTagsCollectionViewCellReuseIdentifier = @"kUAVSSurveyTagsCollectionViewCellReuseIdentifier";

@interface UAVSSurveyContentView()<UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,UAVSSurveyProtocol>

@property (nonatomic, strong) NSArray  *allOptionTags;

@property (nonatomic, strong, readwrite) NSArray  *selectedOptionTags;


@property (nonatomic, strong, readwrite) NSString *selectedResolveSetOptionValue;
@property (nonatomic, strong, readwrite) NSNumber *selectedJudgmentSetOptionId;

@end

@implementation UAVSSurveyContentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _contentScrollerView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _contentScrollerView.delegate = self;
    _contentScrollerView.userInteractionEnabled = YES;
    [self addSubview:_contentScrollerView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScrollerViewAction)];
    tap.delegate = self;
    [_contentScrollerView addGestureRecognizer:tap];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemSizeWidth = ([UIScreen mainScreen].bounds.size.width - 2*kUAVSSurveyContentSpacing - kUAVSTextSurveyButtonToVerticalEdgeSpacing -1)/2;
    layout.itemSize = CGSizeMake(itemSizeWidth, kUAVSSurveyCollectionViewItemSizeHeight);
    layout.minimumInteritemSpacing = kUAVSSurveyTagsCollectionViewMinimumInteritemSpacing;
    layout.minimumLineSpacing = kUAVSSurveyTagsCollectionViewMinimumLineSpacing;
    
    _tagsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _tagsCollectionView.delegate = self;
    _tagsCollectionView.dataSource = self;
    _tagsCollectionView.backgroundColor = [UIColor whiteColor];
    [_tagsCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kUAVSSurveyTagsCollectionViewCellReuseIdentifier];
    [_contentScrollerView addSubview:_tagsCollectionView];
    
    _remarkTextView = [[UdeskAVSHPGrowingTextView alloc] initWithFrame:CGRectZero];
    _remarkTextView.font = [UIFont systemFontOfSize:15];
    _remarkTextView.backgroundColor = [UIColor colorWithRed:0.969f  green:0.969f  blue:0.969f alpha:1];
//    _remarkTextView.backgroundColor = [UIColor redColor];
    _remarkTextView.returnKeyType = UIReturnKeyDone;
    _remarkTextView.delegate = (id)self;
    UDAVS_ViewBorderRadius(_remarkTextView, 2, 1, [UIColor colorWithRed:0.937f  green:0.937f  blue:0.937f alpha:1]);
    [_contentScrollerView addSubview:_remarkTextView];
    
    _remarkRequiredLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _remarkRequiredLabel.font = [UIFont systemFontOfSize:10];
    _remarkRequiredLabel.textColor = [UIColor colorWithRed:0.804f  green:0.247f  blue:0.192f alpha:1];
    [_contentScrollerView addSubview:_remarkRequiredLabel];
    
    _submitButton = [[UdeskAVSButton alloc] initWithFrame:CGRectZero];
    _submitButton.backgroundColor = [UIColor colorWithRed:0.165f  green:0.576f  blue:0.98f alpha:1];
    [_submitButton setTitle:getUDAVSLocalizedString(@"udesk_submit_survey") forState:UIControlStateNormal];
    [_submitButton addTarget:self action:@selector(submitSurvetAction:) forControlEvents:UIControlEventTouchUpInside];
    UDAVS_ViewRadius(_submitButton, 4);
    [_contentScrollerView addSubview:_submitButton];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIScrollView"]) {
        return YES;
    }
    
    return NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (!self.surveyModel || self.surveyModel == (id)kCFNull) return ;
    
    //载体
    CGFloat scrollerViewHeight = self.height > UD_SCREEN_HEIGHT ? (UD_SCREEN_HEIGHT-kUAVSSurveyTitleHeight) : self.height;
    _contentScrollerView.frame = self.bounds;
    _contentScrollerView.height = scrollerViewHeight;
    _contentScrollerView.contentSize = self.bounds.size;
    
    CGFloat surveyOptionHeight = 0;
    
    CGFloat topHeight = kUAVSSurveyOptionToVerticalEdgeSpacing;
    
    if (self.surveyModel.resolveSet && self.surveyModel.resolveSet.resolveSetOptions.count) {
        //选项
        CGRect surveyOptionViewFrame = CGRectMake(kUAVSSurveyContentSpacing, topHeight, self.width-(kUAVSSurveyContentSpacing*2), kUAVSSurveyExpressionOptionHeight);
        self.resolveSurveyView.frame = surveyOptionViewFrame;
    
        surveyOptionHeight += kUAVSSurveyExpressionOptionHeight;
        topHeight += self.resolveSurveyView.height;
    }
    
    if (self.surveyModel.judgmentSet && self.surveyModel.judgmentSet.judgmentSetOptions.count) {
        //选项
        CGRect surveyOptionViewFrame = CGRectMake(kUAVSSurveyContentSpacing, topHeight, self.width-(kUAVSSurveyContentSpacing*2), kUAVSSurveyStarOptionHeight);

        self.starSurveyView.frame = surveyOptionViewFrame;

        surveyOptionHeight += kUAVSSurveyStarOptionHeight;
        topHeight += self.starSurveyView.height;
        NSArray *array = self.surveyModel.judgmentSet.judgmentSetOptions;
        surveyOptionHeight += array.count * ((kUAVSTextSurveyButtonToVerticalEdgeSpacing+kUAVSTextSurveyButtonHeight)) - kUAVSTextSurveyButtonToVerticalEdgeSpacing;
    }

    
    
    //标签
    CGFloat tagsHeight = [self tagsHeightWidthOptions:self.surveyModel.judgmentSet.judgmentSetOptions];
    
    CGFloat tagsCollectionHeight = tagsHeight > kUAVSSurveyTagsCollectionViewMaxHeight ? kUAVSSurveyTagsCollectionViewMaxHeight : tagsHeight;
    
    self.tagsCollectionView.frame = CGRectMake(kUAVSSurveyContentSpacing, topHeight +kUAVSSurveyOptionToVerticalEdgeSpacing, self.width-(kUAVSSurveyContentSpacing*2), tagsCollectionHeight);
    self.tagsCollectionView.contentSize = CGSizeMake(self.width-(kUAVSSurveyContentSpacing*2), tagsHeight);
    
    UAVSRemarkOptionType optionType = [self remarkOptionTypeWithOptions:self.surveyModel.judgmentSet.judgmentSetOptions];
    //备注
    CGFloat remarkY = tagsCollectionHeight ? self.tagsCollectionView.bottom+kUAVSSurveyCollectionViewItemToVerticalEdgeSpacing : kUAVSSurveyOptionToVerticalEdgeSpacing + topHeight;
    CGFloat remarkEnabled = (optionType != UAVSRemarkOptionTypeHide);
    if (remarkEnabled) {
        
        CGFloat remarkHeight = kUAVSSurveyRemarkTextViewMaxHeight;
        if (self.keyboardHeight) {
            remarkHeight = MAX(kUAVSSurveyRemarkTextViewMaxHeight, self.remarkTextView.height);
        }
        else {
            if (!self.remarkTextView.text.length) {
                CGFloat remarkPlaceholderHeight = [UAVSStringSizeUtil sizeWithText:self.remarkTextView.placeholder font:self.remarkTextView.font size:CGSizeMake(self.width-(kUAVSSurveyContentSpacing*3), MAXFLOAT)].height + 15;
                remarkHeight = MAX(kUAVSSurveyRemarkTextViewHeight, remarkPlaceholderHeight);
            }
            else {
                remarkHeight = kUAVSSurveyRemarkTextViewMaxHeight;
            }
        }

        self.remarkTextView.minHeight = remarkHeight;
        self.remarkTextView.frame = CGRectMake(kUAVSSurveyContentSpacing, remarkY, self.width-(kUAVSSurveyContentSpacing*2), MAX(CGRectGetHeight(self.remarkTextView.frame), remarkHeight));
        
        if (optionType == UAVSRemarkOptionTypeRequired) {
            self.remarkRequiredLabel.frame = CGRectMake(kUAVSSurveyContentSpacing, self.remarkTextView.bottom + kUAVSSurveyRemarkRequiredLabelToVerticalEdgeSpacing, self.width-(kUAVSSurveyContentSpacing*2), 10);
        }
        else {
            self.remarkRequiredLabel.frame = CGRectZero;
        }
    }
    else {
        self.remarkTextView.frame = CGRectZero;
        self.remarkRequiredLabel.frame = CGRectZero;
    }
    
    CGFloat submitY = (remarkEnabled ? self.remarkTextView.bottom : (remarkY - kUAVSSurveyOptionToVerticalEdgeSpacing)) + kUAVSSurveySubmitButtonSpacing;
    //提交按钮
    self.submitButton.frame = CGRectMake(kUAVSSurveyContentSpacing, submitY, self.width-(kUAVSSurveyContentSpacing*2), kUAVSSurveySubmitButtonHeight);
    
    [self.tagsCollectionView reloadData];
}

//标签高度
- (CGFloat)tagsHeightWidthOptions:(NSArray *)options {
    if (!options || !options.count) {
        return 0;
    }
    
    NSArray *selectedOption = [options filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"optionId = %@",self.selectedJudgmentSetOptionId]];
    if (!selectedOption.count) {
        return 0;
    }
    UAVSSurveySetOptionModel *optionModel = selectedOption.firstObject;
    if (!optionModel || optionModel == (id)kCFNull) return 0;
    self.selectedJudgmentSetOptionId = optionModel.optionId;
    
 
    if (!optionModel.labels.count) {
        return 0;
    }
    
    self.allOptionTags = optionModel.labels;
    return (ceilf(self.allOptionTags.count/2.0)) * (kUAVSSurveyCollectionViewItemSizeHeight+kUAVSSurveyCollectionViewItemToVerticalEdgeSpacing) - (kUAVSSurveyCollectionViewItemToVerticalEdgeSpacing);
    
}

//备注
- (UAVSRemarkOptionType)remarkOptionTypeWithOptions:(NSArray *)options {
    
    NSArray *selectedOption = [options filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"optionId = %@",self.selectedJudgmentSetOptionId]];
    UAVSSurveySetOptionModel *optionModel = selectedOption.firstObject;
    if (optionModel) {
        if ([optionModel isKindOfClass:[UAVSSurveySetOptionModel class]]) {
            return optionModel.remarkType;
        }
    }
    return UAVSRemarkOptionTypeHide;
}

- (void)setSurveyModel:(UAVSSurveyModel *)surveyModel {
    if (!surveyModel || surveyModel == (id)kCFNull) return ;
    _surveyModel = surveyModel;
    
    [self reloadStarSurvey];
    [self reloadExpressionSurvey];
    
    
    //满意度评价标题
    self.remarkTextView.placeholder = surveyModel.remarkSchema?: getUDAVSLocalizedString(@"udesk_survey_placeholder");
    self.remarkRequiredLabel.text = [NSString stringWithFormat:@"* %@",getUDAVSLocalizedString(@"udesk_survey_remark_required")];
    
    [self setNeedsLayout];
}


//表情模式
- (void)reloadExpressionSurvey {

    NSArray * options = self.surveyModel.resolveSet.resolveSetOptions;
    for (UAVSSurveySetOptionModel *option in options) {
        if (option.isDefault) {
            self.selectedResolveSetOptionValue = option.optionValue;
            break;
        }
    }
    _resolveSurveyView = [[UAVSResolveSurveyView alloc] initWithFrame:CGRectZero];
    _resolveSurveyView.delegate = self;
    _resolveSurveyView.resolveSurvey = self.surveyModel.resolveSet;
    [self.contentScrollerView addSubview:_resolveSurveyView];
}

//星星模式
- (void)reloadStarSurvey {
    
    NSArray * options = self.surveyModel.judgmentSet.judgmentSetOptions;
    for (UAVSSurveySetOptionModel *option in options) {
        if (option.isDefault) {
            self.selectedJudgmentSetOptionId = option.optionId;
            break;
        }
    }
    
    _starSurveyView = [[UAVSStarSurveyView alloc] initWithFrame:CGRectZero];
    _starSurveyView.delegate = self;
    _starSurveyView.starSurvey = self.surveyModel.judgmentSet;
    [self.contentScrollerView addSubview:_starSurveyView];
}


- (void)setKeyboardHeight:(CGFloat)keyboardHeight {
    _keyboardHeight = keyboardHeight;
    
    if (_keyboardHeight) {
        _remarkTextView.minHeight = MAX(kUAVSSurveyRemarkTextViewMaxHeight, _remarkTextView.height);
        _remarkTextView.height = MAX(kUAVSSurveyRemarkTextViewMaxHeight, _remarkTextView.height);
        _remarkRequiredLabel.top = self.remarkTextView.bottom+kUAVSSurveyRemarkRequiredLabelToVerticalEdgeSpacing;
        _submitButton.top = self.remarkTextView.bottom+kUAVSSurveySubmitButtonSpacing;
    }
    else {
        if (!_remarkTextView.text.length) {
            CGFloat remarkPlaceholderHeight = [UAVSStringSizeUtil sizeWithText:self.remarkTextView.placeholder font:self.remarkTextView.font size:CGSizeMake(self.width-(kUAVSSurveyContentSpacing*3), MAXFLOAT)].height + 15;
            if ([UdeskAVSUtil isBlankString:self.remarkTextView.placeholder]) {
                remarkPlaceholderHeight = 0;
            }
            _remarkTextView.minHeight = MAX(kUAVSSurveyRemarkTextViewHeight, remarkPlaceholderHeight);
            _remarkTextView.height = MAX(kUAVSSurveyRemarkTextViewHeight, remarkPlaceholderHeight);
        }
        else {
            _remarkTextView.minHeight = kUAVSSurveyRemarkTextViewMaxHeight;
            _remarkTextView.height = kUAVSSurveyRemarkTextViewMaxHeight;
        }
        _submitButton.top = self.remarkTextView.bottom+kUAVSSurveySubmitButtonSpacing;
        _remarkRequiredLabel.top = self.remarkTextView.bottom+kUAVSSurveyRemarkRequiredLabelToVerticalEdgeSpacing;
    }
    [self checkRemarkTextViewHeight];
}

#pragma mark - UICollectionViewDataSource && Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allOptionTags.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kUAVSSurveyTagsCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    
    if (self.allOptionTags.count > indexPath.row) {
        UILabel *label = [[UILabel alloc] init];
        label.text = self.allOptionTags[indexPath.row];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        cell.backgroundView = label;
        [self normalTagColor:label];
        
        if ([self.selectedOptionTags containsObject:label.text]) {
            [self selectedTagColor:label];
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.allOptionTags.count > indexPath.row) {
        
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        UILabel *label = (UILabel *)cell.backgroundView;
        
        NSString *tag = self.allOptionTags[indexPath.row];
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.selectedOptionTags];
        if ([self.selectedOptionTags containsObject:tag]) {
            
            [array removeObject:tag];
            if ([label isKindOfClass:[UILabel class]]) {
                [self normalTagColor:label];
            }
        }
        else {
            
            [array addObject:tag];
            if ([label isKindOfClass:[UILabel class]]) {
                [self selectedTagColor:label];
            }
        }
        self.selectedOptionTags = [array copy];
    }
}

//选择状态标签颜色
- (void)selectedTagColor:(UILabel *)label {
    
    label.textColor = [UIColor colorWithRed:0.165f  green:0.576f  blue:0.98f alpha:1];
    label.backgroundColor = [UIColor colorWithRed:0.957f  green:0.976f  blue:1 alpha:1];
    UDAVS_ViewBorderRadius(label, 2, 0.6, [UIColor colorWithRed:0.165f  green:0.576f  blue:0.98f alpha:1]);
}

//未选择状态标签颜色
- (void)normalTagColor:(UILabel *)label {
    
    label.textColor = [UIColor colorWithRed:0.6f  green:0.6f  blue:0.6f alpha:1];
    label.backgroundColor = [UIColor clearColor];
    UDAVS_ViewBorderRadius(label, 2, 0.6, [UIColor colorWithRed:0.898f  green:0.898f  blue:0.898f alpha:1]);
}

#pragma mark - UITextViewDelegate
- (BOOL)growingTextView:(UdeskAVSHPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [growingTextView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark @protocol UAVSSurveyProtocol
- (void)didSelectResolveSurveyWithOption:(UAVSSurveySetOptionModel *)option {
    
    if ([self.selectedResolveSetOptionValue isEqual:option.optionValue]) {
        return;
    }
    self.selectedResolveSetOptionValue = option.optionValue;

}

- (void)didSelectExpressionSurveyWithOption:(UAVSSurveySetOptionModel *)option {
    
    if ([self.selectedJudgmentSetOptionId isEqual:option.optionId]) {
        return;
    }
    
    [self.remarkTextView resignFirstResponder];
    
    self.selectedJudgmentSetOptionId = option.optionId;
    self.selectedOptionTags = nil;
    [self updateContentView];
}


#pragma mark - Button Action
- (void)submitSurvetAction:(UdeskAVSButton *)button {

    if (self.delegate && [self.delegate respondsToSelector:@selector(clickSubmitSurvey:)]) {
        [self.delegate clickSubmitSurvey:self];
    }
}

- (void)tapScrollerViewAction {
    [self.remarkTextView resignFirstResponder];
    [self checkRemarkTextViewHeight];
}

//检查备注文本的高度
- (void)checkRemarkTextViewHeight {
    
    [self updateContentView];
}

- (void)updateContentView {
    
    [self setNeedsLayout];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didUpdateContentView:)]) {
        [self.delegate didUpdateContentView:self];
    }
}

@end
