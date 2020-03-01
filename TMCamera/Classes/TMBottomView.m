//
//  TMBottomView.m
//  TMCamera_Example
//
//  Created by 龙格 on 2020/3/1.
//  Copyright © 2020 uponup. All rights reserved.
//

#import "TMBottomView.h"
#import "TMCamera.h"

@interface TMBottomView ()
@property (nonatomic, strong) UIButton *btnLeft;
@property (nonatomic, strong) UIButton *btnMid;
@property (nonatomic, strong) UIButton *btnRight;
@end
@implementation TMBottomView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.6];
        [self commonInit];
    }
    return self;
}

- (void)btnLeftAction:(UIButton *)btn {
    [self responseDelegateWithIndex:0 andSender:btn];
}

- (void)btnMidAction:(UIButton *)btn {
    [self responseDelegateWithIndex:1 andSender:btn];
}

- (void)btnRightAction:(UIButton *)btn {
    [self responseDelegateWithIndex:2 andSender:btn];
}

- (void)responseDelegateWithIndex:(NSInteger)index andSender:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomView:didClickAtIndex:andSender:)]) {
        [self.delegate bottomView:self didClickAtIndex:index andSender:btn];
    }
}

#pragma mark - Setter
- (void)setLeftTitle:(NSString *)leftTitle {
    _leftTitle = leftTitle;
    [self.btnLeft setTitle:_leftTitle forState:UIControlStateNormal];
}
- (void)setMidTitle:(NSString *)midTitle {
    _midTitle = midTitle;
    [self.btnMid setTitle:_midTitle forState:UIControlStateNormal];
}

- (void)setRightTitle:(NSString *)rightTitle {
    _rightTitle = rightTitle;
    [self.btnRight setTitle:_rightTitle forState:UIControlStateNormal];
}

#pragma mark - UI Init
- (void)commonInit {
    self.btnMid = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnMid.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.btnMid addTarget:self action:@selector(btnMidAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnMid];
    
    [self.btnMid autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.btnMid autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
    [self.btnMid autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5 + BOTTOM_SAFE_AREA_HEIGTHT];
//    [self.btnMid autoSetDimensionsToSize:CGSizeMake(44, 44)];
    
    self.btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnLeft.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.btnLeft addTarget:self action:@selector(btnLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnLeft];
    [self.btnLeft autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.btnMid];
    [self.btnLeft autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.btnMid withOffset:-90];
    
    self.btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnRight.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.btnRight addTarget:self action:@selector(btnRightAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnRight];
    [self.btnRight autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.btnMid];
    [self.btnRight autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.btnMid withOffset:90];
}

@end
