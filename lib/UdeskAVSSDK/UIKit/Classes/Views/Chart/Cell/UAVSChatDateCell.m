//
//  ChatDateCell.m
//  UdeskApp
//
//  Created by xuchen on 2018/1/11.
//  Copyright © 2018年 xushichen. All rights reserved.
//

#import "UAVSChatDateCell.h"
#import "UAVSChatDateLayout.h"
#import <YYText/YYText.h>

@interface UAVSChatDateCell()

@property (nonatomic, strong) YYLabel *dateLabel;

@end

@implementation UAVSChatDateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (YYLabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[YYLabel alloc] init];
        [self.contentView addSubview:_dateLabel];
    }
    return _dateLabel;
}

- (void)setBaseLayout:(UAVSChatBaseLayout *)baseLayout {
    [super setBaseLayout:baseLayout];
    
    UAVSChatDateLayout *dateLayout = (UAVSChatDateLayout *)baseLayout;
    if (!dateLayout || ![dateLayout isKindOfClass:[UAVSChatDateLayout class]]) return;
    
    //时间
    self.dateLabel.textLayout = dateLayout.dateLayout;
    self.dateLabel.frame = dateLayout.dateRect;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
