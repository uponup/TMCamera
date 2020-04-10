//
//  TMImageCropView.m
//  TMCamera_Example
//
//  Created by 龙格 on 2020/4/10.
//  Copyright © 2020 uponup. All rights reserved.
//

#import "TMImageCropView.h"
#import "TKImageView.h"
#import "TMCamera.h"
    
@interface TMImageCropView ()
@property (nonatomic, strong) TKImageView *ivCrop;
@property (nonatomic, strong) UIButton *btnClose;
@property (nonatomic, strong) UIButton *btnSave;
@end

@implementation TMImageCropView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)updateImage:(UIImage *)image {
    self.ivCrop.toCropImage = image;
}

#pragma mark - Action

- (void)btnSaveAction:(UIButton *)btn {
    UIImage *currentImage = [self.ivCrop currentCroppedImage];
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageCropViewDidCompleteEditWithImage:)]) {
        [self.delegate imageCropViewDidCompleteEditWithImage:currentImage];
    }
}

- (void)btnCloseAction:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageCropViewDidCancelEdit)]) {
        [self.delegate imageCropViewDidCancelEdit];
    }
}

#pragma mark - Init UI
- (void)commonInit {
    [self addSubview:self.ivCrop];
    [self.ivCrop autoPinEdgesToSuperviewEdges];
    
    [self addSubview:self.btnClose];
    [self.btnClose autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:40];
    [self.btnClose autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15+BOTTOM_SAFE_AREA_HEIGTHT];
    
    [self addSubview:self.btnSave];
    [self.btnSave autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:40];
    [self.btnSave autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.btnClose];
}

#pragma mark - Lazy Method
- (TKImageView *)ivCrop {
    if (!_ivCrop) {
        _ivCrop = [[TKImageView alloc] initWithFrame:CGRectZero];
        _ivCrop.backgroundColor = UIColor.lightTextColor;
        //需要进行裁剪的图片对象
        //是否显示中间线
        _ivCrop.showMidLines = YES;
        //是否需要支持缩放裁剪
        _ivCrop.needScaleCrop = YES;
        //是否显示九宫格交叉线
        _ivCrop.showCrossLines = YES;
        _ivCrop.cornerBorderInImage = NO;
        _ivCrop.cropAreaCornerWidth = 44;
        _ivCrop.cropAreaCornerHeight = 44;
        _ivCrop.minSpace = 30;
        _ivCrop.cropAreaCornerLineColor = [UIColor whiteColor];
        _ivCrop.cropAreaBorderLineColor = [UIColor whiteColor];
        _ivCrop.cropAreaCornerLineWidth = 6;
        _ivCrop.cropAreaBorderLineWidth = 1;
        _ivCrop.cropAreaMidLineWidth = 20;
        _ivCrop.cropAreaMidLineHeight = 6;
        _ivCrop.cropAreaMidLineColor = [UIColor whiteColor];
        _ivCrop.cropAreaCrossLineColor = [UIColor whiteColor];
        _ivCrop.cropAreaCrossLineWidth = 0.5;
        _ivCrop.initialScaleFactor = .8f;
        _ivCrop.cropAspectRatio = 0;
        _ivCrop.maskColor = [UIColor clearColor];
        _ivCrop.showLine = YES;
    }
    return _ivCrop;
}

- (UIButton *)btnSave {
    if (!_btnSave) {
        _btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSave setImage:[UIImage imageNamed:@"ic_yes"] forState:UIControlStateNormal];
        [_btnSave addTarget:self action:@selector(btnSaveAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSave;
}

- (UIButton *)btnClose {
    if (!_btnClose) {
        _btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnClose addTarget:self action:@selector(btnCloseAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnClose;
}

@end
