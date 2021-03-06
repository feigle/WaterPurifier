//
//  TGCameraViewController.m
//  TGCameraViewController
//
//  Created by Bruno Tortato Furtado on 13/09/14.
//  Copyright (c) 2014 Tudo Gostoso Internet. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "TGCameraViewController.h"
#import "TGPhotoViewController.h"
#import "TGCameraSlideView.h"
#import "RSKImageCropper.h"
static const CGFloat kPhotoDiameter = 130.0f;

@interface TGCameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate,RSKImageCropViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *captureView;
@property (strong, nonatomic) IBOutlet UIImageView *topLeftView;
@property (strong, nonatomic) IBOutlet UIImageView *topRightView;
@property (strong, nonatomic) IBOutlet UIImageView *bottomLeftView;
@property (strong, nonatomic) IBOutlet UIImageView *bottomRightView;
@property (strong, nonatomic) IBOutlet UIView *separatorView;
@property (strong, nonatomic) IBOutlet UIView *actionsView;
@property (strong, nonatomic) IBOutlet UIButton *gridButton;
@property (strong, nonatomic) IBOutlet UIButton *toggleButton;
@property (strong, nonatomic) IBOutlet UIButton *shotButton;
@property (strong, nonatomic) IBOutlet UIButton *albumButton;
@property (strong, nonatomic) IBOutlet UIButton *flashButton;
@property (strong, nonatomic) IBOutlet TGCameraSlideView *slideUpView;
@property (strong, nonatomic) IBOutlet TGCameraSlideView *slideDownView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

@property (strong, nonatomic) TGCamera *camera;
@property (nonatomic) BOOL wasLoaded;

- (IBAction)closeTapped;
- (IBAction)gridTapped;
- (IBAction)flashTapped;
- (IBAction)shotTapped;
- (IBAction)albumTapped;
- (IBAction)toggleTapped;
- (IBAction)handleTapGesture:(UITapGestureRecognizer *)recognizer;

- (void)deviceOrientationDidChangeNotification;
- (AVCaptureVideoOrientation)videoOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation;
- (void)viewWillDisappearWithCompletion:(void (^)(void))completion;

@end



@implementation TGCameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (CGRectGetHeight([[UIScreen mainScreen] bounds]) <= 480) {
        _topViewHeight.constant = 0;
    }
    
    _camera = [TGCamera cameraWithFlashButton:_flashButton];
    
    _captureView.backgroundColor = [UIColor clearColor];
    
    _topLeftView.transform = CGAffineTransformMakeRotation(0);
    _topRightView.transform = CGAffineTransformMakeRotation(M_PI_2);
    _bottomLeftView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _bottomRightView.transform = CGAffineTransformMakeRotation(M_PI_2*2);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChangeNotification)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    _separatorView.hidden = NO;
    
    _actionsView.hidden = YES;
    
    _topLeftView.hidden =
    _topRightView.hidden =
    _bottomLeftView.hidden =
    _bottomRightView.hidden = YES;
    
    _gridButton.enabled =
    _toggleButton.enabled =
    _shotButton.enabled =
    _albumButton.enabled =
    _flashButton.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self deviceOrientationDidChangeNotification];
    
    [_camera startRunning];
    
    _separatorView.hidden = YES;
    
    [TGCameraSlideView hideSlideUpView:_slideUpView slideDownView:_slideDownView atView:_captureView completion:^{
        _topLeftView.hidden =
        _topRightView.hidden =
        _bottomLeftView.hidden =
        _bottomRightView.hidden = NO;
        
        _actionsView.hidden = NO;
        
        _gridButton.enabled =
        _toggleButton.enabled =
        _shotButton.enabled =
        _albumButton.enabled =
        _flashButton.enabled = YES;
    }];
     
    if (_wasLoaded == NO) {
        _wasLoaded = YES;
       [_camera insertSublayerWithCaptureView:_captureView atRootView:self.view];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_camera stopRunning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)dealloc
{
    _captureView = nil;
    _topLeftView = nil;
    _topRightView = nil;
    _bottomLeftView = nil;
    _bottomRightView = nil;
    _separatorView = nil;
    _actionsView = nil;
    _gridButton = nil;
    _toggleButton = nil;
    _shotButton = nil;
    _albumButton = nil;
    _flashButton = nil;
    _slideUpView = nil;
    _slideDownView = nil;
    _camera = nil;
}

#pragma mark - 选择相册图片
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *photo = [TGAlbum imageWithMediaInfo:info];
    [self dismissViewControllerAnimated:YES completion:nil];
    //裁剪
    [self CropImage:photo];
    
}
#pragma mark - 相册图片选择取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 关闭
#pragma mark - Actions

- (IBAction)closeTapped
{
    if ([_delegate respondsToSelector:@selector(cameraDidCancel)]) {
        [_delegate cameraDidCancel];
    }
}
#pragma mark - 网格
- (IBAction)gridTapped
{
    [_camera disPlayGridView];
}
#pragma mark - 闪光灯
- (IBAction)flashTapped
{
    [_camera changeFlashModeWithButton:_flashButton];
}
#pragma mark - 拍照
- (IBAction)shotTapped
{
    _shotButton.enabled =
    _albumButton.enabled = NO;

    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation videoOrientation = [self videoOrientationForDeviceOrientation:deviceOrientation];
    
    [self viewWillDisappearWithCompletion:^{
        [_camera takePhotoWithCaptureView:_captureView videoOrientation:videoOrientation cropSize:_captureView.frame.size
        completion:^(UIImage *photo) {
            [self CropImage:photo];
        }];
    }];
}
#pragma mark - 相册
- (IBAction)albumTapped
{
    _shotButton.enabled =
    _albumButton.enabled = NO;
    
    [self viewWillDisappearWithCompletion:^{
        UIImagePickerController *pickerController = [TGAlbum imagePickerControllerWithDelegate:self];
        [self presentViewController:pickerController animated:YES completion:nil];
    }];
}
#pragma mark - 前后摄像头切换
- (IBAction)toggleTapped
{
    [_camera toogleWithFlashButton:_flashButton];
}
#pragma mark - 对焦
- (IBAction)handleTapGesture:(UITapGestureRecognizer *)recognizer
{
    CGPoint touchPoint = [recognizer locationInView:_captureView];
    [_camera focusView:_captureView inTouchPoint:touchPoint];
}

#pragma mark -
#pragma mark - Private methods

- (void)deviceOrientationDidChangeNotification
{
    UIDeviceOrientation orientation = [UIDevice.currentDevice orientation];
    NSInteger degress;
    
    switch (orientation) {
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationUnknown:
            degress = 0;
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            degress = 90;
            break;
            
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationPortraitUpsideDown:
            degress = 180;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            degress = 270;
            break;
    }
    
    CGFloat radians = degress * M_PI / 180;
    CGAffineTransform transform = CGAffineTransformMakeRotation(radians);
    
    [UIView animateWithDuration:.5f animations:^{
        _gridButton.transform =
        _toggleButton.transform =
        _albumButton.transform =
        _flashButton.transform = transform;
    }];
}

- (AVCaptureVideoOrientation)videoOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation) deviceOrientation;
    
    switch (deviceOrientation) {
        case UIDeviceOrientationLandscapeLeft:
            result = AVCaptureVideoOrientationLandscapeRight;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            result = AVCaptureVideoOrientationLandscapeLeft;
            break;
            
        default:
            break;
    }
    
    return result;
}

- (void)viewWillDisappearWithCompletion:(void (^)(void))completion
{
    _actionsView.hidden = YES;
    
    [TGCameraSlideView showSlideUpView:_slideUpView slideDownView:_slideDownView atView:_captureView completion:^{
        completion();
    }];
}
#pragma mark - 相片裁剪回调
//add photo
- (void)CropImage:(UIImage *)img
{
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:img cropMode:RSKImageCropModeCircle];
    imageCropVC.delegate = self;
    [self.navigationController pushViewController:imageCropVC animated:YES];
    
}

#pragma mark - RSKImageCropViewControllerDelegate
//cancel callback
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}
//choose callback
- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect
{
    TGPhotoViewController *viewController = [TGPhotoViewController newWithDelegate:_delegate photo:croppedImage];
    [viewController setAlbumPhoto:YES];
    [self.navigationController pushViewController:viewController animated:NO];
    
//    [self dismissViewControllerAnimated:YES completion:nil];

}
@end