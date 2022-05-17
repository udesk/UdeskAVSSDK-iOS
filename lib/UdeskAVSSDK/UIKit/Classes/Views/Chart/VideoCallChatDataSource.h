//
//  VideoCallChatDataSource.h
//  UdeskApp
//
//  Created by 陈历 on 2020/4/1.
//  Copyright © 2020 xushichen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface VideoCallChatDataSource : NSObject <UITableViewDataSource>


@property (nonatomic, strong) NSMutableArray *messageArray;


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
