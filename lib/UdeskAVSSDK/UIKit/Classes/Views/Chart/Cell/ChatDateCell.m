//
//  ChatDateCell.m
//  UdeskApp
//
//  Created by xuchen on 2018/1/11.
//  Copyright © 2018年 xushichen. All rights reserved.
//

#import "ChatDateCell.h"
#import "ChatDateLayout.h"
#import <YYText/YYText.h>

@interface ChatDateCell()

@property (nonatomic, strong) YYLabel *dateLabel;

@end

@implementation ChatDateCell

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

- (void)setBaseLayout:(ChatBaseLayout *)baseLayout {
    [super setBaseLayout:baseLayout];
    
    ChatDateLayout *dateLayout = (ChatDateLayout *)baseLayout;
    if (!dateLayout || ![dateLayout isKindOfClass:[ChatDateLayout class]]) return;
    
    //时间
    self.dateLabel.textLayout = dateLayout.dateLayout;
    self.dateLabel.frame = dateLayout.dateRect;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
