//
//  TMTopView.h
//  TMCamera_Example
//
//  Created by 龙格 on 2020/3/1.
//  Copyright © 2020 uponup. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TMTopViewDelegate <NSObject>
- (void)topviewDidClick;
@end
@interface TMTopView : UIView
@property (nonatomic, assign) id<TMTopViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
