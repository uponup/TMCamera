//
//  TMClipViewController.h
//  TMCamera_Example
//
//  Created by 龙格 on 2020/2/29.
//  Copyright © 2020 uponup. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TMClipPhotoDelegate <NSObject>

- (void)clipPhoto:(UIImage *)image;

@end

@interface TMClipViewController : UIViewController

@property (nonatomic, assign) id<TMClipPhotoDelegate> delegate;

- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)init __deprecated_msg("Use 'initWithImage:'");

@end

NS_ASSUME_NONNULL_END
