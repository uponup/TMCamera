//
//  TMCamera.h
//  TMCamera
//
//  Created by 龙格 on 2020/3/1.
//  Copyright © 2020 uponup. All rights reserved.
//

#ifndef TMCamera_h
#define TMCamera_h


#import "PureLayout.h"
#import "TMTopView.h"
#import "TMBottomView.h"

#define KWIDTH [UIScreen mainScreen].bounds.size.width
#define KHEIGHT [UIScreen mainScreen].bounds.size.height

#define IS_IPHONEX ({\
BOOL iPhoneX = NO;\
if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {\
(iPhoneX);\
}\
if (@available(iOS 11.0, *)) {\
UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];\
if (mainWindow.safeAreaInsets.bottom > 0.0) {\
iPhoneX = YES;\
}\
}\
(iPhoneX);\
})


#define BOTTOM_SAFE_AREA_HEIGTHT (IS_IPHONEX ? 34 : 0)

#define STATUS_HEIGHT \
({ \
CGFloat height; \
if (IS_IPHONEX) { \
height = 44; \
} else { \
height = 20; \
} \
(height); \
})



#endif /* TMCamera_h */
