//
//  SHGalleryViewController.h
//  SHGalleryView
//
//  Created by SHAN UL HAQ on 8/4/14.
//  Copyright (c) 2014 com.grevolution.shgalleryview. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHMediaItem;
@protocol SHGalleryViewControllerDataSource;
@protocol SHGalleryViewControllerDelegate;
@class SHMediaControlTheme;


static NSString * const kNotificationMediaPlay = @"kNotificationMediaPlay";
static NSString * const kNotificationMediaPause = @"kNotificationMediaPause";
static NSString * const kNotificationMediaStop = @"kNotificationMediaStop";
static NSString * const kNotificationMediaSliderValueChanged = @"kNotificationMediaSliderValueChanged";
static NSString * const kNotificationMediaDone = @"kNotificationMediaDone";

@interface SHGalleryViewController : UIViewController

@property (nonatomic, assign) id<SHGalleryViewControllerDataSource>dataSource;
@property (nonatomic, assign) id<SHGalleryViewControllerDelegate>delegate;
@property (nonatomic, strong) SHMediaControlTheme *theme;
@property (nonatomic) int currentIndex;
@property (nonatomic) int currentSection;

- (void)reloadData;
- (void)scrollToItemAtIndex:(int)index;

@end

@protocol SHGalleryViewControllerDataSource <NSObject>

@required
- (CGFloat)numberOfItems;
- (SHMediaItem *)mediaItemIndex:(int)index andSection:(int)section;

@end

@protocol SHGalleryViewControllerDelegate <NSObject>

- (void)galleryView:(SHGalleryViewController *)galleryView willDisplayItemAtIndex:(int)index;
- (void)galleryView:(SHGalleryViewController *)galleryView didDisplayItemAtIndex:(int)index;
- (void)doneClicked;

@end

@protocol SHGalleryViewControllerChild <NSObject>

@property (nonatomic, strong) SHMediaItem *mediaItem;
@property (nonatomic) NSInteger pageIndex;

@end