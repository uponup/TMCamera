//
//  TMViewController.m
//  TMCamera
//
//  Created by uponup on 02/29/2020.
//  Copyright (c) 2020 uponup. All rights reserved.
//

#import "TMViewController.h"
#import "TMCameraController.h"
#import <AVFoundation/AVFoundation.h>

@interface TMViewController ()<TMCameraControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation TMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - TMCameraControllerDelegate
- (void)cameraVc:(TMCameraController *)camera takesPhoto:(UIImage *)image {
    self.imageView.image = image;
}

- (void)cameraVc:(nonnull TMCameraController *)camera authFailed:(TMCameraAuthStatus)status {
    
}


#pragma mark - Action

- (IBAction)openCamera:(id)sender {
    // 设备不可用  直接返回
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"没有权限");
        return;
    }
    
    TMCameraController *cameraVc = [[TMCameraController alloc] init];
    cameraVc.delegate = self;
    [self presentViewController:cameraVc animated:YES completion:nil];
}

- (IBAction)openLibrary:(id)sender {
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
