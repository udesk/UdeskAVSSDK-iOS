//
//  VideoCallChatDataSource.m
//  UdeskApp
//
//  Created by 陈历 on 2020/4/1.
//  Copyright © 2020 xushichen. All rights reserved.
//

#import "VideoCallChatDataSource.h"

#import "ChatBaseLayout.h"
#import "ChatBaseCell.h"

@implementation VideoCallChatDataSource

- (CGFloat)tableView:(UITableView *)tableView messageHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatBaseLayout *layout = [self.messageArray objectAtIndex:indexPath.row];
    return layout.height;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self tableView:tableView messageHeightForRowAtIndexPath:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView messageCellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id layout = [self.messageArray objectAtIndex:indexPath.row];
    NSString *messageLayoutName = NSStringFromClass([layout class]);    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:messageLayoutName];
    if (!cell) {
        cell = [(ChatBaseLayout *)layout getCellWithReuseIdentifier:messageLayoutName];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ChatBaseCell *chatCell = (ChatBaseCell *)cell;
    chatCell.baseLayout = layout;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self tableView:tableView messageCellForRowAtIndexPath:indexPath];
}

@end
