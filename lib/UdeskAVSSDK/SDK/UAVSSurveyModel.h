//
//  UAVSJudgmentInfoModel.h
//  UdeskAVSExample
//
//  Created by Admin on 2022/6/29.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, UAVSRemarkOptionType) {
    UAVSRemarkOptionTypeOptional = 1, //选填 默认
    UAVSRemarkOptionTypeRequired, //必填
    UAVSRemarkOptionTypeHide, //隐藏
};


@interface UAVSSurveySetOptionModel : NSObject

@property (nonatomic, assign) BOOL isDefault;//是否默认选中

//是否解决使用
@property (nonatomic, copy  ) NSString *optionValue;

//满意度使用
@property (nonatomic, strong) NSNumber *optionId;
@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, copy  ) NSString *optionName;
@property (nonatomic, strong) NSArray <NSString *> *labels;
@property (nonatomic, assign) UAVSRemarkOptionType remarkType;

@end


@interface UAVSSurveySetModel : NSObject

@property (nonatomic, strong) NSArray<UAVSSurveySetOptionModel *> *judgmentSetOptions;
@property (nonatomic, strong) NSNumber *judgmentType;

@end


@interface UAVSSurveyResolveSetModel : NSObject

@property (nonatomic, strong) NSArray<UAVSSurveySetOptionModel *> *resolveSetOptions;
@property (nonatomic, copy  ) NSString *title;

@end

@interface UAVSSurveyModel : NSObject

@property (nonatomic, assign) BOOL status;//是否开启
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong)UAVSSurveySetModel *judgmentSet;
@property (nonatomic, strong) UAVSSurveyResolveSetModel *resolveSet;

@property (nonatomic, strong) NSString *remarkSchema;

@end


