//
//  SHMediaItemViewController.m
//  SHGalleryView
//
//  Created by SHAN UL HAQ on 8/4/14.
//  Copyright (c) 2014 com.grevolution.shgalleryview. All rights reserved.
//

#import "SHImageMediaItemViewController.h"
#import "SHMediaControlView.h"
#import "SHGalleryViewController.h"
#import "SHMediaItem.h"

#define ZOOM_VIEW_TAG 100

@interface SHImageMediaItemViewController () <SHGalleryViewControllerChild, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation SHImageMediaItemViewController

@synthesize pageIndex;
@synthesize mediaItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark --  屏幕旋转
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {//竖屏

    }
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {//横屏
        

        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //根据url设置图片
    NSData*data = [NSData dataWithContentsOfFile:self.mediaItem.resourcePath];
    UIImage *image = [UIImage imageWithData:data];
    [_imageView setImage:image];
    [_imageScrollView setDelegate:self];
    [_imageScrollView setBouncesZoom:YES];

    [_imageView setTag:ZOOM_VIEW_TAG];
    [_imageScrollView setContentSize:[_imageView frame].size];
    
    // calculate minimum scale to perfectly fit image width, and begin at that scale
    float minimumScale = [_imageScrollView frame].size.width  / [_imageView frame].size.width;
    [_imageScrollView setMinimumZoomScale:minimumScale];
    [_imageScrollView setZoomScale:minimumScale];
    _imageScrollView.center = CGPointMake(self.view.center.x, (MRScreenHeight-64)/2);
    self.view.backgroundColor = [UIColor clearColor];
}

#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [_imageScrollView viewWithTag:ZOOM_VIEW_TAG];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
