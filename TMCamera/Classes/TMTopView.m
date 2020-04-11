//
//  TMTopView.m
//  TMCamera_Example
//
//  Created by 龙格 on 2020/3/1.
//  Copyright © 2020 uponup. All rights reserved.
//

#import "TMTopView.h"
#import "TMCamera.h"

@interface TMTopView ()
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UIButton *btn;
@end
@implementation TMTopView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.0];
        [self commonInit];
    }
    return self;
}

- (void)btnAction:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(topviewDidClick)]) {
        [self.delegate topviewDidClick];
    }
}

#pragma mark - UI Init
- (void)commonInit {
    self.labelTitle = [UILabel new];
    self.labelTitle.font = [UIFont systemFontOfSize:17];
    self.labelTitle.textColor = UIColor.whiteColor;;
    [self addSubview:self.labelTitle];
    [self.labelTitle autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.labelTitle autoSetDimension:ALDimensionHeight toSize:44];
    [self.labelTitle autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:STATUS_HEIGHT];
    [self.labelTitle autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn setImage:[TMUtils imageCustomNamed:@"ic_back"] forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btn];
    [self.btn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.labelTitle];
    [self.btn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:13];
}

@end
