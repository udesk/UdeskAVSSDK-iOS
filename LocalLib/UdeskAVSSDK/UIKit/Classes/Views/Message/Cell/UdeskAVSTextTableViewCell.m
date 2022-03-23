//
//  UdeskAVSTextTableViewCell.m
//  UdeskAvsSDKDemo
//
//  Created by 陈历 on 2021/6/2.
//

#import "UdeskAVSTextTableViewCell.h"
#import "UdeskAVSTextLayout.h"
#import <UdeskAVSSDK/UdeskAVSSDK.h>

@implementation UdeskAVSTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBaseLayout:(UdeskAVSBaseLayout *)baseLayout{
    [super setBaseLayout:baseLayout];
    UdeskAVSTextLayout *layout = (UdeskAVSTextLayout *)baseLayout;
    self.udeskTextLabel.text = layout.message.content;
    
    self.udeskTextLabel.frame = self.bubbleImageView.bounds;
}

- (UILabel *)udeskTextLabel{
    if (!_udeskTextLabel) {
        _udeskTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _udeskTextLabel.font = [UIFont systemFontOfSize:14];
        _udeskTextLabel.numberOfLines = 0;
        [self.bubbleImageView addSubview:_udeskTextLabel];
    }
    return _udeskTextLabel;
}

@end
