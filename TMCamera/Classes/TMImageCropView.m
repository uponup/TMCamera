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
    
@interface TMImageCropView () {
    NSInteger _rotateCount;
}
@property (nonatomic, strong) TKImageView *ivCrop;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *btnClose;
@property (nonatomic, strong) UIButton *btnRotate;
@property (nonatomic, strong) UIButton *btnSave;
@end

@implementation TMImageCropView

- (instancetype)init {
    self = [super init];
    if (self) {
        _rotateCount = 0;
        [self commonInit];
    }
    return self;
}

- (void)updateImage:(UIImage *)image {
    self.ivCrop.toCropImage = image;
}

- (void)setCropBorderColor:(UIColor *)cropBorderColor {
    _cropBorderColor = cropBorderColor;
    _ivCrop.cropAreaCornerLineColor = _cropBorderColor;
    _ivCrop.cropAreaBorderLineColor = _cropBorderColor;
}

#pragma mark - Action

- (void)btnCloseAction:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageCropViewDidCancelEdit)]) {
        [self.delegate imageCropViewDidCancelEdit];
    }
}

- (void)btnSaveAction:(UIButton *)btn {
    UIImage *currentImage = [self.ivCrop currentCroppedImage];
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageCropViewDidCompleteEditWithImage:)]) {
        [self.delegate imageCropViewDidCompleteEditWithImage:currentImage];
    }
}

- (void)btnRotateAction:(UIButton *)btn {
    _rotateCount++;
    UIImage *image = [self.ivCrop imageRotatedByDegrees:0];
    self.ivCrop.toCropImage = image;
}

#pragma mark - Init UI
- (void)commonInit {
    [self addSubview:self.ivCrop];
    [self.ivCrop autoPinEdgesToSuperviewEdges];
    
    [self addSubview:self.bottomView];
    [self.bottomView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
    
    [self.bottomView addSubview:self.btnRotate];
    self.btnRotate.hidden = YES;
    [self.btnRotate autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.btnRotate autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15+BOTTOM_SAFE_AREA_HEIGTHT];
    [self.btnRotate autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15];
    
    [self.bottomView addSubview:self.btnClose];
    [self.btnClose autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:40];
    [self.btnClose autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.btnRotate];
    
    
    [self.bottomView addSubview:self.btnSave];
    [self.btnSave autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:40];
    [self.btnSave autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.btnRotate];
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
        _ivCrop.cropAreaCornerHeight = 84;
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
        _ivCrop.maskColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.6];
        _ivCrop.showLine = YES;
    }
    return _ivCrop;
}

- (UIButton *)btnSave {
    if (!_btnSave) {
        _btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSave.bounds = CGRectMake(0, 0, 44, 44);
        [_btnSave setImage:[UIImage imageNamed:@"ic_yes"] forState:UIControlStateNormal];
        [_btnSave addTarget:self action:@selector(btnSaveAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSave;
}

- (UIButton *)btnRotate {
    if (!_btnRotate) {
        _btnRotate = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRotate.bounds = CGRectMake(0, 0, 44, 44);
        [_btnRotate setImage:[UIImage imageNamed:@"ic_rotate"] forState:UIControlStateNormal];
        [_btnRotate addTarget:self action:@selector(btnRotateAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRotate;
}

- (UIButton *)btnClose {
    if (!_btnClose) {
        _btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnClose.bounds = CGRectMake(0, 0, 44, 44);
        [_btnClose setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
        [_btnClose addTarget:self action:@selector(btnCloseAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnClose;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.7];
    }
    return _bottomView;
}

@end
