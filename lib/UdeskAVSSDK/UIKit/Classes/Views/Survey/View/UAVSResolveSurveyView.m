//
//  UdeskExpressionSurveyView.m
//  UdeskSDK
//
//  Created by xuchen on 2018/3/29.
//  Copyright © 2018年 Udesk. All rights reserved.
//

#import "UAVSResolveSurveyView.h"
#import "UdeskProjectHeader.h"
#import "UIImage+UdeskAVS.h"
#import "UIView+UdeskAVS.h"
#import "UdeskAVSBundleUtils.h"
#import "UdeskAVSMacroHeader.h"

static CGFloat kUAVSSurveyExpressionSize = 90;
static CGFloat kUAVSSurveyExpressionHeight = 30;
static CGFloat kUAVSSurveyExpressionSpacing = 18;
static CGFloat kUAVSSurveyExpressionToVerticalEdgeSpacing = 15;

@interface UAVSResolveSurveyView()

@property (nonatomic, strong) UIButton *satisfiedItemView;
@property (nonatomic, strong) UIButton *unsatisfiedItemView;

@property (nonatomic, strong) UILabel *isOkLabel;

@property (nonatomic, strong) UIView  *satisfiedView;
@property (nonatomic, strong) UIView  *unsatisfactoryView;

@end

@implementation UAVSResolveSurveyView

- (instancetype)initWithResolveSurvey:(UAVSSurveyResolveSetModel *)resolveSurvey
{
    self = [super init];
    if (self) {
        _resolveSurvey = resolveSurvey;
    }
    return self;
}

- (void)setResolveSurvey:(UAVSSurveyResolveSetModel *)expressionSurvey {
    if (!expressionSurvey || expressionSurvey == (id)kCFNull) return ;
    _resolveSurvey = expressionSurvey;
    {
        UILabel *label = [[UILabel alloc] init];
        label.text = expressionSurvey.title ?:@"";
        label.textColor = [UIColor colorWithRed:0.2f  green:0.2f  blue:0.2f alpha:1];
        label.font = [UIFont systemFontOfSize:16.0];
        label.textAlignment = NSTextAlignmentCenter;
        _isOkLabel = label;
    }
    
    [self addSubview:_isOkLabel];
    
    _satisfiedView = [self expressionView];
    [_satisfiedView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapSatisfiedAction)]];
    [self addSubview:_satisfiedView];
    
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
        [button setImage:[UIImage udDefaultSurveyExpressionSatisfiedImage] forState:UIControlStateNormal];
        [button setTitle:getUDAVSLocalizedString(@"udesk_survey_satisfied") forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.3f  green:0.3f  blue:0.3f alpha:1] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 4);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
        [button addTarget:self action:@selector(didTapSatisfiedAction) forControlEvents:UIControlEventTouchUpInside];
        _satisfiedItemView = button;
    }
    [_satisfiedView addSubview:_satisfiedItemView];
    [self addSubview:_satisfiedView];
    
    
    _unsatisfactoryView = [self expressionView];
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
        [button setImage:[UIImage udDefaultSurveyExpressionUnsatisfactoryImage] forState:UIControlStateNormal];
        [button setTitle:getUDAVSLocalizedString(@"udesk_survey_unsatisfactory") forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.3f  green:0.3f  blue:0.3f alpha:1] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 4);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
        [button addTarget:self action:@selector(didTapUnsatisfactoryAction) forControlEvents:UIControlEventTouchUpInside];
        _unsatisfiedItemView = button;
    }
    [_unsatisfactoryView addSubview:_unsatisfiedItemView];
    [self addSubview:_unsatisfactoryView];
    
    
    for (UAVSSurveySetOptionModel *option in expressionSurvey.resolveSetOptions) {
        if (option.isDefault) {
            NSInteger index = [expressionSurvey.resolveSetOptions indexOfObject:option];
            [self updateSelectedViewWithIndex:index];
        }
    }
   
}

//满意
- (void)didTapSatisfiedAction {
    
    self.satisfiedItemView.selected = !self.satisfiedItemView.selected;
    self.unsatisfiedItemView.selected = !self.satisfiedItemView.selected;
    
    [self updateViewUIWithOtherView:self.unsatisfactoryView];
    [self updateSelectedViewWithIndex:0];
    
    [self callbackClickWithIndex:0];
}


//不满意
- (void)didTapUnsatisfactoryAction {
    
    self.satisfiedItemView.selected = !self.satisfiedItemView.selected;
    self.unsatisfiedItemView.selected = !self.satisfiedItemView.selected;
    
    [self updateViewUIWithOtherView:self.satisfiedView];
    [self updateSelectedViewWithIndex:1];
    
    [self callbackClickWithIndex:1];
}

- (void)updateSelectedViewWithIndex:(NSInteger)index {
    
    if (index == 0) {
        self.satisfiedView.backgroundColor = [UIColor colorWithRed:0.914f  green:0.98f  blue:0.937f alpha:1];
        self.satisfiedView.layer.borderColor = [UIColor colorWithRed:0.576f  green:0.902f  blue:0.682f alpha:1].CGColor;
    }
    else if (index == 1) {
        self.unsatisfactoryView.backgroundColor = [UIColor colorWithRed:1  green:0.922f  blue:0.922f alpha:1];
        self.unsatisfactoryView.layer.borderColor = [UIColor colorWithRed:1  green:0.608f  blue:0.6f alpha:1].CGColor;
    }
}

- (void)updateViewUIWithOtherView:(UIView *)otherView {
    
    otherView.backgroundColor = [UIColor whiteColor];
    otherView.layer.borderColor = [UIColor colorWithRed:0.9f  green:0.9f  blue:0.9f alpha:1].CGColor;
}

- (void)callbackClickWithIndex:(NSInteger)index {
    
    if (self.resolveSurvey.resolveSetOptions.count > index) {
     
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectResolveSurveyWithOption:)]) {
            [self.delegate didSelectResolveSurveyWithOption:self.resolveSurvey.resolveSetOptions[index]];
        }
    }
}

- (UIView *)expressionView {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    UDAVS_ViewBorderRadius(view, 2, 1, [UIColor colorWithRed:0.9f  green:0.9f  blue:0.9f alpha:1]);
    
    return view;
}

- (UIImageView *)expressionImageViewWithImage:(UIImage *)image {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    return imageView;
}

- (UILabel *)expressionLabelWithTitle:(NSString *)title {
    
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = [UIColor colorWithRed:0.6f  green:0.6f  blue:0.6f alpha:1];
    label.font = [UIFont systemFontOfSize:12.0];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_isOkLabel sizeToFit];
    _isOkLabel.frame = CGRectMake(kUAVSSurveyExpressionSpacing, 0, self.width - kUAVSSurveyExpressionSpacing*2, 20);
    
    
    _satisfiedView.frame = CGRectMake((self.width-(kUAVSSurveyExpressionSize*2 + kUAVSSurveyExpressionSpacing))/2, self.isOkLabel.bottom + kUAVSSurveyExpressionToVerticalEdgeSpacing *2, kUAVSSurveyExpressionSize, kUAVSSurveyExpressionHeight);
    
    _satisfiedView.frame = CGRectMake((self.width-(kUAVSSurveyExpressionSize*2 + kUAVSSurveyExpressionSpacing))/2, self.isOkLabel.bottom + kUAVSSurveyExpressionToVerticalEdgeSpacing *2, kUAVSSurveyExpressionSize, kUAVSSurveyExpressionHeight);
    
    _unsatisfactoryView.frame = CGRectMake(_satisfiedView.right+kUAVSSurveyExpressionSpacing, _satisfiedView.top, kUAVSSurveyExpressionSize, kUAVSSurveyExpressionHeight);
    
    _satisfiedItemView.frame = CGRectMake(0, 0, _satisfiedView.width, _satisfiedView.height);
    _unsatisfiedItemView.frame = CGRectMake(0, 0, _unsatisfactoryView.width, _unsatisfactoryView.height);;
    
}

@end
