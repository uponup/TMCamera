//
//  TMBottomView.h
//  TMCamera_Example
//
//  Created by 龙格 on 2020/3/1.
//  Copyright © 2020 uponup. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TMBottomView;
NS_ASSUME_NONNULL_BEGIN

@protocol TMBottomViewDelegate <NSObject>

- (void)bottomView:(TMBottomView *)view didClickAtIndex:(NSInteger)index andSender:(UIButton *)sender;

@end

@interface TMBottomView : UIView
@property (nonatomic, strong) NSArray<NSString *> *btnsImageNames;
@property (nonatomic, assign) id<TMBottomViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
