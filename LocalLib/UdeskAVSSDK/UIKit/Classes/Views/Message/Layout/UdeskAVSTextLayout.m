//
//  UdeskAVSTextLayout.m
//  UdeskAvsSDKDemo
//
//  Created by 陈历 on 2021/6/2.
//

#import "UdeskAVSTextLayout.h"
#import "UdeskAVSTextTableViewCell.h"
#import <UdeskAVSSDK/UdeskAVSSDK.h>


//如果不现实时间，则留空
CGFloat const kUdeskAVSCellMarginTop = 10.0;
//底部留空
CGFloat const kUdeskAVSCellMarginBotton = 10.0;
//显示时间的高度
CGFloat const kUdeskAVSCellTopTimeHeight = 20;
// 头像的宽高
CGFloat const kUdeskAVSCellHeaderImageWidth = 40;
// 头像边距
CGFloat const kUdeskAVSCellHeaderImageMarginToBoarder = 10;
// 头像跟消息体的距离
CGFloat const kUdeskAVSCellHeaderImageMarginToBody = 10;
// 字体大小
CGFloat const kUdeskAVSCellTextFont = 14.0;

CGFloat contentMaxWidth(void){
    return [UIScreen mainScreen].bounds.size.width - 2*(kUdeskAVSCellHeaderImageMarginToBody + kUdeskAVSCellHeaderImageMarginToBoarder + kUdeskAVSCellHeaderImageWidth);
}

@implementation UdeskAVSTextLayout

- (instancetype)initWithMessage:(UdeskAVSBaseMessage *)message dateDisplay:(BOOL)dateDisplay{
    if (self = [super initWithMessage:message dateDisplay:dateDisplay]) {
        [self setupLayout];
    }
    return self;
}

- (void)setupLayout{
    CGFloat h = 0;
    if (self.dateDisplay) {
        h = kUdeskAVSCellTopTimeHeight;
    }
    else{
        h = kUdeskAVSCellMarginTop;
    }
    
    NSString *message = [NSString stringWithFormat:@"%@", self.message.content];
    
    CGSize size = [message boundingRectWithSize:CGSizeMake(contentMaxWidth()-1, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
  
    
    if (self.message.fromType == UdeskAVSMessageFromTypeAgent) {
        self.avatarFrame = CGRectMake(kUdeskAVSCellHeaderImageMarginToBoarder, h, kUdeskAVSCellHeaderImageWidth, kUdeskAVSCellHeaderImageWidth);
        CGFloat left = kUdeskAVSCellHeaderImageMarginToBoarder + kUdeskAVSCellHeaderImageWidth + kUdeskAVSCellHeaderImageMarginToBody;
        CGFloat bubleH = (ceil(size.height)<kUdeskAVSCellHeaderImageWidth)?kUdeskAVSCellHeaderImageWidth:ceil(size.height);
        self.bubleFrame = CGRectMake(left, h, size.width, bubleH);
    }
    else if(self.message.fromType == UdeskAVSMessageFromTypeCustomer){
        self.avatarFrame = CGRectMake([UIScreen mainScreen].bounds.size.width - (kUdeskAVSCellHeaderImageMarginToBoarder + kUdeskAVSCellHeaderImageWidth), h, kUdeskAVSCellHeaderImageWidth, kUdeskAVSCellHeaderImageWidth);
        
        CGFloat left = [UIScreen mainScreen].bounds.size.width - (kUdeskAVSCellHeaderImageMarginToBoarder + kUdeskAVSCellHeaderImageWidth + kUdeskAVSCellHeaderImageMarginToBody) - size.width ;
        CGFloat bubleH = (ceil(size.height)<kUdeskAVSCellHeaderImageWidth)?kUdeskAVSCellHeaderImageWidth:ceil(size.height);
        self.bubleFrame = CGRectMake(left, h, size.width, bubleH);
    }

    CGFloat suggestContentHeight = size.height;
    if (size.height < kUdeskAVSCellHeaderImageWidth) {
        suggestContentHeight = kUdeskAVSCellHeaderImageWidth;
    }
    self.height = h + suggestContentHeight + kUdeskAVSCellMarginBotton;
}

- (UITableViewCell *)getCellWithReuseIdentifier:(NSString *)cellReuseIdentifer{
    return [[UdeskAVSTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifer];
}


@end
