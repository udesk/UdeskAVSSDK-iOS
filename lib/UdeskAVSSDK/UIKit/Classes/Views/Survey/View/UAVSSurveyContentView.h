//
//  UdeskSurveyContentView.h
//  UdeskSDK
//
//  Created by xuchen on 2018/4/2.
//  Copyright © 2018年 Udesk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAVSSurveyTitleView.h"
#import "UAVSResolveSurveyView.h"
#import "UAVSStarSurveyView.h"
#import "UdeskAVSHPGrowingTextView.h"
#import "UdeskAVSButton.h"

@class UAVSSurveyModel;
@class UAVSSurveyContentView;

/** 按钮间距 */
extern const CGFloat kUAVSTextSurveyButtonToVerticalEdgeSpacing;
/** 按钮高度 */
extern const CGFloat kUAVSTextSurveyButtonHeight;


extern const CGFloat kUAVSSurveyRemarkTextViewHeight;
extern const CGFloat kUAVSSurveyRemarkTextViewMaxHeight;
extern const CGFloat kUAVSSurveySubmitButtonSpacing;
extern const CGFloat kUAVSSurveySubmitButtonHeight;
extern const CGFloat kUAVSSurveyContentSpacing;
extern const CGFloat kUAVSSurveyCollectionViewItemSizeHeight;
extern const CGFloat kUAVSSurveyCollectionViewItemSizeWidth;
extern const CGFloat kUAVSSurveyCollectionViewItemToVerticalEdgeSpacing;
extern const CGFloat kUAVSSurveyTagsCollectionViewMinimumLineSpacing;
extern const CGFloat kUAVSSurveyTagsCollectionViewMinimumInteritemSpacing;
extern const CGFloat kUAVSSurveyTagsCollectionViewMaxHeight;
extern const CGFloat kUAVSSurveyStarOptionHeight;
extern const CGFloat kUAVSSurveyExpressionOptionHeight;
extern const CGFloat kUAVSSurveyOptionToVerticalEdgeSpacing;
extern const CGFloat kUAVSSurveyTitleHeight;
extern const CGFloat kUAVSSurveyRemarkRequiredLabelToVerticalEdgeSpacing;

@protocol UdeskSurveyViewDelegate <NSObject>

- (void)clickSubmitSurvey:(UAVSSurveyContentView *)survey;
- (void)didUpdateContentView:(UAVSSurveyContentView *)survey;

@end

@interface UAVSSurveyContentView : UIView

/** 载体 */
@property (nonatomic, strong) UIScrollView *contentScrollerView;
/** 表情模式 */
@property (nonatomic, strong) UAVSResolveSurveyView *resolveSurveyView;
/** 五星模式 */
@property (nonatomic, strong) UAVSStarSurveyView *starSurveyView;
/** 标签 */
@property (nonatomic, strong) UICollectionView *tagsCollectionView;
/** 备注 */
@property (nonatomic, strong) UdeskAVSHPGrowingTextView *remarkTextView;
/** 备注必填 */
@property (nonatomic, strong) UILabel           *remarkRequiredLabel;
/** 提交按钮 */
@property (nonatomic, strong) UdeskAVSButton            *submitButton;

/** 数据 */
@property (nonatomic, strong) UAVSSurveyModel *surveyModel;

@property (nonatomic, strong, readonly) NSString *selectedResolveSetOptionValue;
@property (nonatomic, strong, readonly) NSNumber *selectedJudgmentSetOptionId;

@property (nonatomic, strong, readonly) NSArray  *selectedOptionTags;

@property (nonatomic, assign) CGFloat tagsHeight;
@property (nonatomic, assign) CGFloat surveyOptionHeight;

@property (nonatomic, assign) CGFloat keyboardHeight;

@property (nonatomic, weak  ) id<UdeskSurveyViewDelegate> delegate;

@end
