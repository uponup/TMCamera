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
- (void)setBtnsImageNames:(NSArray<NSString *> *)btnsImageNames {
    if (btnsImageNames.count==0) {
        self.btnLeft.hidden = YES;
        self.btnMid.hidden = YES;
        self.btnRight.hidden = YES;
        return;
    }
    
    if (btnsImageNames.count == 1) {
        NSString *imgName = btnsImageNames.firstObject;
        UIImage *img = [TMUtils imageCustomNamed:imgName];
        
        self.btnLeft.hidden = YES;
        if (img) {
//            [self.btnMid setImage:img forState:UIControlStateNormal];
        }else {
            self.btnMid.hidden = YES;
        }
        self.btnRight.hidden = YES;
        return;
    }
    
    if (btnsImageNames.count == 2) {
        UIImage *imgLeft = [TMUtils imageCustomNamed:btnsImageNames.firstObject];
        UIImage *imgRight = [TMUtils imageCustomNamed:btnsImageNames.lastObject];
        if (imgLeft) {
//            [self.btnLeft setImage:imgLeft forState:UIControlStateNormal];
        }else {
            self.btnLeft.hidden = YES;
        }
        self.btnMid.hidden = YES;
        if (imgRight) {
//            [self.btnRight setImage:imgRight forState:UIControlStateNormal];
        }else {
            self.btnRight.hidden = YES;
        }
        return;
    }
    
    NSArray *tempArr = @[self.btnLeft, self.btnMid, self.btnRight];
    NSInteger i=0;
    for (UIButton *btn in tempArr) {
        UIImage *img = [TMUtils imageCustomNamed:btnsImageNames[i]];
        if (img) {
//            [btn setImage:img forState:UIControlStateNormal];
        }else {
            btn.hidden = YES;
        }
        i++;
    }
}

#pragma mark - UI Init
- (void)commonInit {
    self.btnMid = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnMid.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.btnMid setTitle:@"拍照" forState:UIControlStateNormal];
//    [self.btnMid setImage:[TMUtils imageCustomNamed:@"ic_take_photo"] forState:UIControlStateNormal];
    [self.btnMid addTarget:self action:@selector(btnMidAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnMid];
    
    [self.btnMid autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.btnMid autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
    [self.btnMid autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5 + BOTTOM_SAFE_AREA_HEIGTHT];
    [self.btnMid autoSetDimensionsToSize:CGSizeMake(64, 64)];
    
    self.btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnLeft autoSetDimensionsToSize:CGSizeMake(32, 32)];
    [self.btnLeft setTitle:@"相册" forState:UIControlStateNormal];
    self.btnLeft.titleLabel.font = [UIFont systemFontOfSize:15];
//    [self.btnLeft setImage:[TMUtils imageCustomNamed:@"ic_photo"] forState:UIControlStateNormal];
    [self.btnLeft addTarget:self action:@selector(btnLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnLeft];
    [self.btnLeft autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.btnMid];
    [self.btnLeft autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.btnMid withOffset:-90];
    
    self.btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.btnRight autoSetDimensionsToSize:CGSizeMake(32, 32)];
    [self.btnRight setTitle:@"手电筒" forState:UIControlStateNormal];
    self.btnRight.titleLabel.font = [UIFont systemFontOfSize:15];
//    [self.btnRight setImage:[TMUtils imageCustomNamed:@"ic_sdt"] forState:UIControlStateNormal];
    [self.btnRight addTarget:self action:@selector(btnRightAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnRight];
    [self.btnRight autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.btnMid];
    [self.btnRight autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.btnMid withOffset:90];
}

@end
