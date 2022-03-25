//
//  UdeskAVSBaseTableViewCell.m
//  UdeskAvsSDKDemo
//
//  Created by 陈历 on 2021/6/2.
//

#import "UdeskAVSBaseTableViewCell.h"
#import "UdeskAVSBaseLayout.h"
#import <UdeskAVSSDK/UdeskAVSSDK.h>

@implementation UdeskAVSBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBaseLayout:(UdeskAVSBaseLayout *)layout{
    self.timeLabel.text = layout.message.createAt;
    
    if (layout.message.agentAvtarImage) {
        self.avatorImageView.image = layout.message.agentAvtarImage;
    }
    self.avatorImageView.frame = layout.avatarFrame;
    self.avatorImageView.layer.cornerRadius = layout.avatarFrame.size.width/2.0;
    
    self.bubbleImageView.frame = layout.bubleFrame;
    self.bubbleImageView.backgroundColor = [UIColor whiteColor];
    
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 15)];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UIImageView *)bubbleImageView{
    if (!_bubbleImageView) {
        _bubbleImageView = [[UIImageView alloc] init];
        [self addSubview:_bubbleImageView];
    }
    return _bubbleImageView;
}

- (UIImageView *)avatorImageView{
    if (!_avatorImageView) {
        _avatorImageView = [[UIImageView alloc] init];
        _avatorImageView.backgroundColor = [UIColor yellowColor];
        [self addSubview:_avatorImageView];
    }
    return _avatorImageView;
}

@end
