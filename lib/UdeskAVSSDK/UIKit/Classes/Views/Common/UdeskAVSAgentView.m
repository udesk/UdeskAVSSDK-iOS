//
//  UdeskAVSAgentView.m
//  UdeskAVSExample
//
//  Created by 陈历 on 2021/6/7.
//

#import "UdeskAVSAgentView.h"
#import "UdeskProjectHeader.h"

@interface UdeskAVSAgentView ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *avatarImageView;

@end

@implementation UdeskAVSAgentView

- (void)updateAgentInfo:(UdeskAVSAgentInfo *)info{
    if (info.avatar.length > 0) {
        [self.avatarImageView ud_setImageWithURL:info.avatar.convertToURL];
    }
    else{
        self.avatarImageView.image = [UIImage udavs_imageNamed:@"kefu"];
    }
    
    self.nameLabel.text = info.nickname;
}

- (UIImageView *)avatarImageView{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _avatarImageView.layer.cornerRadius = 25.0;
        _avatarImageView.layer.borderWidth = 1.0;
        _avatarImageView.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.1].CGColor;
        [self addSubview:_avatarImageView];
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(66, 0, 200, 50)];
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
