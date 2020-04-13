//
//  TMImageCropView.h
//  TMCamera_Example
//
//  Created by 龙格 on 2020/4/10.
//  Copyright © 2020 uponup. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TMImageCropViewDelegate <NSObject>

- (void)imageCropViewDidCancelEdit;
- (void)imageCropViewDidCompleteEditWithImage:(UIImage *)image;

@end

@interface TMImageCropView : UIView

@property (nonatomic, strong) UIColor *cropBorderColor;
@property (nonatomic, weak) id<TMImageCropViewDelegate> delegate;
- (void)updateImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
