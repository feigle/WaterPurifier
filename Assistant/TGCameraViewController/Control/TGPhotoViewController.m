//
//  TGPhotoViewController.m
//  TGCameraViewController
//
//  Created by Bruno Tortato Furtado on 15/09/14.
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

@import AssetsLibrary;
#import "TGPhotoViewController.h"
#import "TGAssetsLibrary.h"
#import "TGCameraColor.h"
#import "TGCameraFilterView.h"
#import "UIImage+CameraFilters.h"

static NSString* const kTGCacheSatureKey = @"TGCacheSatureKey";
static NSString* const kTGCacheCurveKey = @"TGCacheCurveKey";
static NSString* const kTGCacheVignetteKey = @"TGCacheVignetteKey";



@interface TGPhotoViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *photoView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet TGCameraFilterView *filterView;
@property (strong, nonatomic) IBOutlet UIButton *defaultFilterButton;
@property (strong, nonatomic) IBOutlet UIButton *statureBtn;
@property (strong, nonatomic) IBOutlet UIButton *curveBtn;
@property (strong, nonatomic) IBOutlet UIButton *vignetteBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

@property (weak) id<TGCameraDelegate> delegate;
@property (strong, nonatomic) UIView *detailFilterView;
@property (strong, nonatomic) UIImage *photo;
@property (strong, nonatomic) NSCache *cachePhoto;
@property (nonatomic) BOOL albumPhoto;


- (IBAction)backTapped;
- (IBAction)confirmTapped;
- (IBAction)filtersTapped;

- (IBAction)defaultFilterTapped:(UIButton *)button;
- (IBAction)satureFilterTapped:(UIButton *)button;
- (IBAction)curveFilterTapped:(UIButton *)button;
- (IBAction)vignetteFilterTapped:(UIButton *)button;

- (void)addDetailViewToButton:(UIButton *)button;
+ (instancetype)newController;

@end



@implementation TGPhotoViewController

+ (instancetype)newWithDelegate:(id<TGCameraDelegate>)delegate photo:(UIImage *)photo
{
    TGPhotoViewController *viewController = [TGPhotoViewController newController];
    
    if (viewController) {
        viewController.delegate = delegate;
        viewController.photo = photo;
        viewController.cachePhoto = [[NSCache alloc] init];
    }
    
    return viewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    if (CGRectGetHeight([[UIScreen mainScreen] bounds]) <= 480) {
        _topViewHeight.constant = 0;
    }
    _photoView.frame = CGRectMake(0, 0, MRScreenWidth, MRScreenWidth);
    _photoView.layer.cornerRadius = (_photoView.frame.size.width)/2;
    _photoView.layer.masksToBounds = YES;
    _photoView.clipsToBounds = YES;
    _photoView.image = _photo;
    dispatch_queue_t newThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); dispatch_async(newThread,^{
        [self setBtnImages];
    });

}
- (void)setBtnImages
{
    UIImage *img = [self cropImage:[_photo copy] withCropSize:self.defaultFilterButton.frame.size];
    [self.defaultFilterButton setImage:img forState:UIControlStateNormal];
    [self.statureBtn setImage:img forState:UIControlStateNormal];
    [self.curveBtn setImage:img forState:UIControlStateNormal];
    [self.vignetteBtn setImage:img forState:UIControlStateNormal];
    [self addDetailViewToButton:_defaultFilterButton];
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
    _photoView = nil;
    _bottomView = nil;
    _filterView = nil;
    _defaultFilterButton = nil;
    _detailFilterView = nil;
    _photo = nil;
    _cachePhoto = nil;
}

#pragma mark -
#pragma mark - Controller actions

- (IBAction)backTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  确定保存按键
 */
#pragma mark --确定保存按键
- (IBAction)confirmTapped
{
    if ( [_delegate respondsToSelector:@selector(cameraWillTakePhoto)]) {
        [_delegate cameraWillTakePhoto];
    }
    
    if ([_delegate respondsToSelector:@selector(cameraDidTakePhoto:)]) {
        _photo = _photoView.image;
        
        if (_albumPhoto) {
            [_delegate cameraDidSelectAlbumPhoto:_photo];
        } else {
            [_delegate cameraDidTakePhoto:_photo];
        }
        
    }
#pragma mark -- 保存图片到本地
    dispatch_queue_t newThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); dispatch_async(newThread,^{
        [self savePhoto];
    });
}
- (void)savePhoto
{
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    TGAssetsLibrary *library = [TGAssetsLibrary defaultAssetsLibrary];
    
    void (^saveJPGImageAtDocumentDirectory)(UIImage *) = ^(UIImage *photo) {
        [library saveJPGImageAtDocumentDirectory:_photo resultBlock:^(NSURL *assetURL) {
            [_delegate cameraDidSavePhotoAtPath:assetURL];
        } failureBlock:^(NSError *error) {
            if ([_delegate respondsToSelector:@selector(cameraDidSavePhotoWithError:)]) {
                [_delegate cameraDidSavePhotoWithError:error];
            }
        }];
    };
    
    if ([[TGCamera getOption:kTGCameraOptionSaveImageToAlbum] boolValue] && status != ALAuthorizationStatusDenied) {
        [library saveImage:_photo resultBlock:^(NSURL *assetURL) {
            if ([_delegate respondsToSelector:@selector(cameraDidSavePhotoAtPath:)]) {
                [_delegate cameraDidSavePhotoAtPath:assetURL];
            }
        } failureBlock:^(NSError *error) {
            saveJPGImageAtDocumentDirectory(_photo);
        }];
    } else {
        if ([_delegate respondsToSelector:@selector(cameraDidSavePhotoAtPath:)]) {
            saveJPGImageAtDocumentDirectory(_photo);
        }
    }
}
//弹出效果按钮
- (IBAction)filtersTapped
{
    if ([_filterView isDescendantOfView:self.view]) {
        [_filterView removeFromSuperviewAnimated];
    } else {
        [_filterView addToView:self.view aboveView:_bottomView];
        [self.view sendSubviewToBack:_filterView];
        [self.view sendSubviewToBack:_photoView];
    }
}

#pragma mark -
#pragma mark - Filter view actions
//各种效果
- (IBAction)defaultFilterTapped:(UIButton *)button
{
    [self addDetailViewToButton:button];
    _photoView.image = _photo;
}

- (IBAction)satureFilterTapped:(UIButton *)button
{
    [self addDetailViewToButton:button];
    
    if ([_cachePhoto objectForKey:kTGCacheSatureKey]) {
        _photoView.image = [_cachePhoto objectForKey:kTGCacheSatureKey];
    } else {
        [_cachePhoto setObject:[_photo saturateImage:1.8 withContrast:1] forKey:kTGCacheSatureKey];
        _photoView.image = [_cachePhoto objectForKey:kTGCacheSatureKey];
    }
    
}

- (IBAction)curveFilterTapped:(UIButton *)button
{
    [self addDetailViewToButton:button];
    
    if ([_cachePhoto objectForKey:kTGCacheCurveKey]) {
        _photoView.image = [_cachePhoto objectForKey:kTGCacheCurveKey];
    } else {
        [_cachePhoto setObject:[_photo curveFilter] forKey:kTGCacheCurveKey];
        _photoView.image = [_cachePhoto objectForKey:kTGCacheCurveKey];
    }
}

- (IBAction)vignetteFilterTapped:(UIButton *)button
{
    [self addDetailViewToButton:button];
    
    if ([_cachePhoto objectForKey:kTGCacheVignetteKey]) {
        _photoView.image = [_cachePhoto objectForKey:kTGCacheVignetteKey];
    } else {
        [_cachePhoto setObject:[_photo vignetteWithRadius:0 intensity:6] forKey:kTGCacheVignetteKey];
        _photoView.image = [_cachePhoto objectForKey:kTGCacheVignetteKey];
    }
}


#pragma mark -
#pragma mark - Private methods

- (void)addDetailViewToButton:(UIButton *)button
{
    [_detailFilterView removeFromSuperview];
    
    CGFloat height = 2.5;
    
    CGRect frame = button.frame;
    frame.size.height = height;
    frame.origin.x = 0;
    frame.origin.y = CGRectGetMaxY(button.frame) - height;
    
    _detailFilterView = [[UIView alloc] initWithFrame:frame];
    _detailFilterView.backgroundColor = [TGCameraColor orangeColor];
    _detailFilterView.userInteractionEnabled = NO;
    
    [button addSubview:_detailFilterView];
}

+ (instancetype)newController
{
    return [super new];
}
#pragma mark - Private methods
//裁剪图片
-(UIImage *)cropImage:(UIImage *)image withCropSize:(CGSize)cropSize
{
    UIImage *newImage = nil;
    
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = cropSize.width;
    CGFloat targetHeight = cropSize.height;
    
    CGFloat scaleFactor = 0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0, 0);
    
    if (CGSizeEqualToSize(imageSize, cropSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        } else {
            scaleFactor = heightFactor;
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * .5f;
        } else {
            if (widthFactor < heightFactor) {
                thumbnailPoint.x = (targetWidth - scaledWidth) * .5f;
            }
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(cropSize, YES, 0);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [image drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
