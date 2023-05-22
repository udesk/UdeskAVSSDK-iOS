//
//  UdeskStarSurveyView.m
//  UdeskSDK
//
//  Created by xuchen on 2018/3/29.
//  Copyright © 2018年 Udesk. All rights reserved.
//

#import "UAVSStarSurveyView.h"
#import "UdeskProjectHeader.h"
#import "UAVS_HCSStarRatingView.h"
#import "UAVSSurveyModel.h"
#import "UIImage+UdeskAVS.h"
#import "UIView+UdeskAVS.h"

static CGFloat kUAVSSurveyStarViewToVerticalEdgeSpacing = 12;
static CGFloat kUAVSSurveyStarViewWidth = 215;
static CGFloat kUAVSSurveyStarViewHeight = 21;
static CGFloat kUAVSSurveyTipLabelHeight = 13.5;

@interface UAVSStarSurveyView()

@property (nonatomic, strong) UAVS_HCSStarRatingView *starRatingView;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation UAVSStarSurveyView

- (instancetype)initWithStarSurvey:(UAVSSurveySetModel *)starSurvey
{
    self = [super init];
    if (self) {
        _starSurvey = starSurvey;
    }
    return self;
}

- (void)setStarSurvey:(UAVSSurveySetModel *)starSurvey {
    if (!starSurvey || starSurvey == (id)kCFNull) return ;
    _starSurvey = starSurvey;
    
    _starRatingView = [[UAVS_HCSStarRatingView alloc] init];
    _starRatingView.maximumValue = 5;
    _starRatingView.allowsHalfStars = NO;
    _starRatingView.emptyStarImage = [UIImage udDefaultSurveyStarEmptyImage];
    _starRatingView.filledStarImage = [UIImage udDefaultSurveyStarFilledImage];
    [_starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_starRatingView];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _tipLabel.textColor = [UIColor colorWithRed:0.165f  green:0.576f  blue:0.98f alpha:1];
    _tipLabel.font = [UIFont systemFontOfSize:14];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_tipLabel];
    
    for (UAVSSurveySetOptionModel *option in starSurvey.judgmentSetOptions) {
        if (option.isDefault) {
            NSInteger index = [starSurvey.judgmentSetOptions indexOfObject:option];
            _tipLabel.text = option.optionName;
            
            int newIndex = fabs((CGFloat)index - 5);
            _starRatingView.value = newIndex;
        }
    }
}

- (void)didChangeValue:(UAVS_HCSStarRatingView *)sender {
    
    int index = fabs(sender.value - 5);
    if (index >=0 && self.starSurvey.judgmentSetOptions.count > index) {
        UAVSSurveySetOptionModel *option = self.starSurvey.judgmentSetOptions[index];
        _tipLabel.text = option.optionName;
    }
    
    if (index >=0 && self.starSurvey.judgmentSetOptions.count > index) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectExpressionSurveyWithOption:)]) {
            [self.delegate didSelectExpressionSurveyWithOption:self.starSurvey.judgmentSetOptions[index]];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _starRatingView.frame = CGRectMake((self.width-kUAVSSurveyStarViewWidth)/2, kUAVSSurveyStarViewToVerticalEdgeSpacing, kUAVSSurveyStarViewWidth, kUAVSSurveyStarViewHeight);
    _tipLabel.frame = CGRectMake(0, _starRatingView.bottom +kUAVSSurveyStarViewHeight, self.width, kUAVSSurveyTipLabelHeight);
}

@end
