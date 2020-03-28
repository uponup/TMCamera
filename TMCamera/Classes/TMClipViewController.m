//
//  TMClipViewController.m
//  TMCamera_Example
//
//  Created by 龙格 on 2020/2/29.
//  Copyright © 2020 uponup. All rights reserved.
//

#import "TMClipViewController.h"
#import "TKImageView.h"
#import "TMCamera.h"

@interface TMClipViewController ()<TMBottomViewDelegate> {
    UIImage *_originalImage;
    BOOL _isClip;
}
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) TMBottomView *bottomView;
@property (nonatomic, strong) TKImageView *tkImageView;
@end

@implementation TMClipViewController

- (instancetype)init {
    self = [super init];
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _isClip = NO;
        _originalImage = image;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self commonInit];
    self.tkImageView.toCropImage = _originalImage;
}

- (void)dismissAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 临时裁剪
- (void)resizeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _isClip = sender.selected;
    if (_isClip) {
        [sender setTitle:@"重来" forState:UIControlStateNormal];
        self.tkImageView.toCropImage = [_tkImageView currentCroppedImage];
    }else {
        [sender setTitle:@"裁剪" forState:UIControlStateNormal];
        self.tkImageView.toCropImage = _originalImage;
    }
    
    self.tkImageView.cropAreaBorderLineWidth = _isClip ? 0 : 1;
    self.tkImageView.showLine = !_isClip;
}

- (void)saveAction:(id)sender {
    //裁剪
    if (_isClip) {
        UIImage *image = [_tkImageView currentCroppedImage];
        if (self.delegate && [self.delegate respondsToSelector:@selector(clipPhoto:)]) {
            [self.delegate clipPhoto:image];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(clipPhoto:)]) {
            [self.delegate clipPhoto:_originalImage];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 裁剪并保存
- (void)clipAndSave {
    UIImage *image = [_tkImageView currentCroppedImage];
//    self.tkImageView.toCropImage = image;
    if (self.delegate && [self.delegate respondsToSelector:@selector(clipPhoto:)]) {
        [self dismissViewControllerAnimated:NO completion:^{
            [self.delegate clipPhoto:image];
        }];
    }
}

#pragma mark - TMBottomViewDelegate
- (void)bottomView:(TMBottomView *)view didClickAtIndex:(NSInteger)index andSender:(UIButton *)sender {
    if (index==0) {
        [self dismissAction:sender];
    }else if (index==1) {
//        [self resizeAction:sender];
    }else {
//        [self saveAction:sender];
        [self clipAndSave];
    }
}

#pragma mark - UI Init
- (void)commonInit {
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIView *topView = [UIView new];
    topView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.6];
    [self.view addSubview:topView];
    [topView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [topView autoSetDimension:ALDimensionHeight toSize:STATUS_HEIGHT];

    [self.view addSubview:self.bottomView];
    [self.bottomView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    
    [self.view addSubview:self.tkImageView];
    [self.tkImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.tkImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:topView];
    [self.tkImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.bottomView];
    [self.tkImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
}

#pragma mark - Lazy Methpd

- (TKImageView *)tkImageView {
    if (!_tkImageView) {
        _tkImageView = [[TKImageView alloc] initWithFrame:CGRectZero];
        _tkImageView.backgroundColor = UIColor.lightTextColor;
        //需要进行裁剪的图片对象
        //是否显示中间线
        _tkImageView.showMidLines = YES;
        //是否需要支持缩放裁剪
        _tkImageView.needScaleCrop = YES;
        //是否显示九宫格交叉线
        _tkImageView.showCrossLines = YES;
        _tkImageView.cornerBorderInImage = NO;
        _tkImageView.cropAreaCornerWidth = 44;
        _tkImageView.cropAreaCornerHeight = 44;
        _tkImageView.minSpace = 30;
        _tkImageView.cropAreaCornerLineColor = [UIColor whiteColor];
        _tkImageView.cropAreaBorderLineColor = [UIColor whiteColor];
        _tkImageView.cropAreaCornerLineWidth = 6;
        _tkImageView.cropAreaBorderLineWidth = 1;
        _tkImageView.cropAreaMidLineWidth = 20;
        _tkImageView.cropAreaMidLineHeight = 6;
        _tkImageView.cropAreaMidLineColor = [UIColor whiteColor];
        _tkImageView.cropAreaCrossLineColor = [UIColor whiteColor];
        _tkImageView.cropAreaCrossLineWidth = 0.5;
        _tkImageView.initialScaleFactor = .8f;
        _tkImageView.cropAspectRatio = 0;
        _tkImageView.maskColor = [UIColor clearColor];
        _tkImageView.showLine = YES;
    }
    return _tkImageView;
}

- (TMBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[TMBottomView alloc] init];
        _bottomView.leftTitle = @"取消";
//        _bottomView.midTitle = @"裁剪";
        _bottomView.rightTitle = @"裁剪";
        _bottomView.delegate = self;
    }
    return _bottomView;
}
@end
