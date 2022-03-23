//
//  UdeskAVSBaseLayout.m
//  UdeskAvsSDKDemo
//
//  Created by 陈历 on 2021/6/2.
//

#import "UdeskAVSBaseLayout.h"


@implementation UdeskAVSBaseLayout

- (instancetype)initWithMessage:(UdeskAVSBaseMessage *)message dateDisplay:(BOOL)dateDisplay{
    if (self = [super init]) {
        self.message = message;
        self.dateDisplay = dateDisplay;
    }
    return self;
}

- (UITableViewCell *)getCellWithReuseIdentifier:(NSString *)cellReuseIdentifer{
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifer];
}

@end
