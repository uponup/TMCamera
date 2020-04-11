//
//  TMCameraController.h
//  TMCamera_Example
//
//  Created by 龙格 on 2020/2/29.
//  Copyright © 2020 uponup. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TMCameraController;

typedef NSString * TMCropAttributeKey NS_TYPED_ENUM;
extern TMCropAttributeKey const TMCropBorderColorKey;

typedef NS_ENUM(NSInteger, TMCameraAuthStatus) {
    TMCameraAuthStatus_avNotDetermined = 1,
    TMCameraAuthStatus_avDenied,
    TMCameraAuthStatus_phNotDetermined,
    TMCameraAuthStatus_phDenied
};

@protocol TMCameraControllerDelegate <NSObject>

- (void)cameraVc:(TMCameraController *)camera takesPhoto:(UIImage *)image;
- (void)cameraVc:(TMCameraController *)camera authFailed:(TMCameraAuthStatus)status;

@end

@interface TMCameraController : UIViewController
@property (nonatomic, assign) id<TMCameraControllerDelegate> delegate;

- (instancetype)initWithConfig:(NSDictionary<TMCropAttributeKey, id> *)config;
@end

