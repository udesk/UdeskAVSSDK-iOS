//
//  UdeskAVSUtilities.h
//  UdeskAvsSDKDemo
//
//  Created by 陈历 on 2021/5/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

CGFloat YYScreenScale(void);

/// Get main screen's size. Height is always larger than width.
CGSize YYScreenSize(void);

// main screen's scale
#ifndef kScreenScale
#define kScreenScale YYScreenScale()
#endif

// main screen's size (portrait)
#ifndef kScreenSize
#define kScreenSize YYScreenSize()
#endif

// main screen's width (portrait)
#ifndef kScreenWidth
#define kScreenWidth YYScreenSize().width
#endif

// main screen's height (portrait)
#ifndef kScreenHeight
#define kScreenHeight YYScreenSize().height
#endif


NS_ASSUME_NONNULL_END
