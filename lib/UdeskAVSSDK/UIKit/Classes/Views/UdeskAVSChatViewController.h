//
//  UdeskAVSChatViewController.h
//  UdeskApp
//
//  Created by 陈历 on 2020/5/22.
//  Copyright © 2020 xushichen. All rights reserved.
//


#import <UIKit/UIKit.h>

@class VideoCallUIManager;

NS_ASSUME_NONNULL_BEGIN

@interface UdeskAVSChatViewController : UIViewController

- (instancetype)initWithUIManager:(VideoCallUIManager *)manager;

-  (void)showOnViewController:(UIViewController *)parentController animated:(BOOL)animated;

-  (void)dismissFromParentViewController;

- (void)reloadTableView;

@property (nonatomic, copy) dispatch_block_t dismissBlock;

@end

NS_ASSUME_NONNULL_END
