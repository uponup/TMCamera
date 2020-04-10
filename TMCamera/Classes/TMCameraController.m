//
//  TMCameraController.m
//  TMCamera_Example
//
//  Created by 龙格 on 2020/2/29.
//  Copyright © 2020 uponup. All rights reserved.
//

#import "TMCameraController.h"
#import "TMImageCropView.h"
#import <AVFoundation/AVFoundation.h>
#import "TMCamera.h"

@interface TMCameraController () <UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TMTopViewDelegate, TMBottomViewDelegate, TMImageCropViewDelegate>
@property (nonatomic, strong) TMTopView *topView;
@property (nonatomic, strong) TMBottomView *bottomView;
@property (nonatomic, strong) TMImageCropView *cropView;

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureConnection *stillImageConnection;

@property (nonatomic, assign) CGFloat beginGestureScale;    // 缩放比例初始值
@property (nonatomic, assign) CGFloat effectiveScale;       // 缩放比例最后值
@property (nonatomic, strong) NSData *jpegData;
@property (nonatomic, assign) CFDictionaryRef attachments;

@end

@implementation TMCameraController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self commonInit];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinch.delegate = self;
    [self.view addGestureRecognizer:pinch];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.session) {
        [self.session startRunning];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.session) {
        [self.session stopRunning];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self.view];
    [self focusAtPoint:point];
}

- (void)openPhotoLibrary:(UIButton *)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        NSLog(@"没有权限");
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.navigationBar.tintColor = UIColor.blackColor;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)takePhots:(UIButton *)sender {
    _stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [_stillImageConnection setVideoOrientation:avcaptureOrientation];
    [_stillImageConnection setVideoScaleAndCropFactor:self.effectiveScale];
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:_stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        [self jumpImageView:jpegData];
    }];
}

- (void)openFlashLamp:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.isSelected == YES) { //打开闪光灯
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        
        if ([captureDevice hasTorch]) {
            BOOL locked = [captureDevice lockForConfiguration:&error];
            if (locked) {
                captureDevice.torchMode = AVCaptureTorchModeOn;
                [captureDevice unlockForConfiguration];
            }
        }
    }else{//关闭闪光灯
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) {
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOff];
            [device unlockForConfiguration];
        }
    }
}

//缩放手势 用于调整焦距
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer{
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    for ( i = 0; i < numTouches; ++i ) {
        CGPoint location = [recognizer locationOfTouch:i inView:self.view];
        CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
        if ( ! [self.previewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if ( allTouchesAreOnThePreviewLayer ) {
        self.effectiveScale = self.beginGestureScale * recognizer.scale;
        if (self.effectiveScale < 1.0){
            self.effectiveScale = 1.0;
        }
    NSLog(@"%f-------------->%f------------recognizerScale%f",self.effectiveScale,self.beginGestureScale,recognizer.scale);
        
        CGFloat maxScaleAndCropFactor = [[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        
        NSLog(@"%f",maxScaleAndCropFactor);
        if (self.effectiveScale > maxScaleAndCropFactor)
            self.effectiveScale = maxScaleAndCropFactor;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
        [CATransaction commit];
    }
    
}
#pragma mark - TMImageCropViewDelegate
- (void)imageCropViewDidCancelEdit {
    self.cropView.hidden = YES;
}

- (void)imageCropViewDidCompleteEditWithImage:(UIImage *)image {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraVc:takesPhoto:)]) {
        [self dismissViewControllerAnimated:NO completion:^{
            [self.delegate cameraVc:self takesPhoto:image];
            self.cropView.hidden = YES;
        }];
    }
}

#pragma mark - TMTopViewDelegate
- (void)topviewDidClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TMBottomViewDelegate
- (void)bottomView:(TMBottomView *)view didClickAtIndex:(NSInteger)index andSender:(nonnull UIButton *)sender{
    if (index==0) {
        [self openPhotoLibrary:sender];
    }else if (index==1){
        [self takePhots:sender];
    }else {
        [self openFlashLamp:sender];
    }
}

#pragma mark - Delegate: UIGestureDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}

#pragma mark - Private Method
//自动聚焦、曝光
- (BOOL)resetFocusAndExposureModes{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureExposureMode exposureMode = AVCaptureExposureModeContinuousAutoExposure;
    AVCaptureFocusMode focusMode = AVCaptureFocusModeContinuousAutoFocus;
    BOOL canResetFocus = [device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode];
    BOOL canResetExposure = [device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode];
    CGPoint centerPoint = CGPointMake(0.5f, 0.5f);
    NSError *error;
    if ([device lockForConfiguration:&error]) {
        if (canResetFocus) {
            device.focusMode = focusMode;
            device.focusPointOfInterest = centerPoint;
        }
        if (canResetExposure) {
            device.exposureMode = exposureMode;
            device.exposurePointOfInterest = centerPoint;
        }
        [device unlockForConfiguration];
        return YES;
    }
    else{
        NSLog(@"%@", error);
        return NO;
    }
}

//获取设备方向
-(AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation {
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}

//拍照之后调到相片详情页面
- (void)jumpImageView:(NSData*)data{
    UIImage *image = [UIImage imageWithData:data];
    [self.cropView updateImage:image];
    self.cropView.hidden = NO;
}

//聚焦
- (void)focusAtPoint:(CGPoint)point {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([self cameraSupportsTapToFocus] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.focusPointOfInterest = point;
            device.focusMode = AVCaptureFocusModeAutoFocus;
            [device unlockForConfiguration];
        }
        else{
            NSLog(@"%@", error);
        }
    }
}

- (BOOL)cameraSupportsTapToFocus {
    return [[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] isFocusPointOfInterestSupported];
}
// 响应代理
- (void)responseAuth:(TMCameraAuthStatus)status {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraVc:authFailed:)]) {
        [self.delegate cameraVc:self authFailed:status];
    }
}

#pragma mark - UI Init

- (void)commonInit {
    [self.view addSubview:self.topView];
    [self.topView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];

    [self.view addSubview:self.bottomView];
    [self.bottomView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];

    [self.view addSubview:self.cropView];
    [self.cropView autoPinEdgesToSuperviewEdges];
    
    [self initAVCaptureSession];
}
- (void)initAVCaptureSession{
    
    self.session = [[AVCaptureSession alloc] init];
    
    NSError *error;
    
    self.effectiveScale = 1.0;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [device lockForConfiguration:nil];
    
    [device unlockForConfiguration];
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    //初始化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];

    self.previewLayer.frame = CGRectMake(0, 0, KWIDTH, KHEIGHT);
    self.view.layer.masksToBounds = YES;
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    
    [self resetFocusAndExposureModes];
}

#pragma mark - Lazy Method
- (TMTopView *)topView {
    if (!_topView) {
        _topView = [[TMTopView alloc] init];
        _topView.delegate = self;
    }
    return _topView;
}

- (TMBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[TMBottomView alloc] init];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

- (TMImageCropView *)cropView {
    if (!_cropView) {
        _cropView = [[TMImageCropView alloc] init];
        _cropView.delegate = self;
        _cropView.hidden = YES;
    }
    return _cropView;
}
@end
