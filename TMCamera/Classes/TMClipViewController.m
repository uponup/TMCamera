//
//  TMClipViewController.m
//  TMCamera_Example
//
//  Created by 龙格 on 2020/2/29.
//  Copyright © 2020 uponup. All rights reserved.
//

#import "TMClipViewController.h"
#import "TKImageView.h"

#define KWIDTH [UIScreen mainScreen].bounds.size.width
#define KHEIGHT [UIScreen mainScreen].bounds.size.height

@interface TMClipViewController () {
    UIImage *_originalImage;
    BOOL _isClip;
}
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (nonatomic, strong) TKImageView *tkImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@end

@implementation TMClipViewController

- (instancetype)init {
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:[NSBundle tm_subBundleWithBundleName:@"TMCamera" targetClass:[self class]]];
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

    [self.view addSubview:self.tkImageView];
    self.tkImageView.toCropImage = _originalImage;
}

- (IBAction)dismissAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 临时裁剪
- (IBAction)resizeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _isClip = sender.selected;
    if (_isClip) {
        sender.titleLabel.text = @"重来";
        self.tkImageView.toCropImage = [_tkImageView currentCroppedImage];
    }else {
        sender.titleLabel.text = @"裁剪";
        self.tkImageView.toCropImage = _originalImage;
    }
    
    self.tkImageView.cropAreaBorderLineWidth = _isClip ? 0 : 1;
    self.tkImageView.showLine = !_isClip;

}

- (IBAction)saveAction:(id)sender {
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


#pragma mark - Lazy Methpd

- (TKImageView *)tkImageView {
    if (!_tkImageView) {
        CGFloat top = self.headView.frame.size.height;
        
        _tkImageView = [[TKImageView alloc] initWithFrame:CGRectMake(0, top, KWIDTH, KHEIGHT - top -  self.bottomView.frame.size.height)];
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


@end
