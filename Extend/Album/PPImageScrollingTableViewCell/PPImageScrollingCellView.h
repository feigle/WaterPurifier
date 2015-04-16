//
//  PPImageScrollingCellView.h
//  VideoMonitor
//
//  Created by Andy on 14-9-3.
//  Copyright (c) 2014年 Andy. All rights reserved.
//
#import <UIKit/UIKit.h>

@class PPImageScrollingCellView;

@protocol PPImageScrollingViewDelegate <NSObject>

- (void)collectionView:(PPImageScrollingCellView *)collectionView didSelectImageItemAtIndexPath:(NSIndexPath*)indexPath;

@end


@interface PPImageScrollingCellView : UIView

@property (weak, nonatomic) id<PPImageScrollingViewDelegate> delegate;
@property (nonatomic) int sectionInCell;
- (void) setImageTitleLabelWitdh:(CGFloat)width withHeight:(CGFloat)height;
- (void) setImageTitleTextColor:(UIColor*)textColor withBackgroundColor:(UIColor*)bgColor;
- (void) setImageData:(NSArray*)collectionImageData;
- (void) setBackgroundColor:(UIColor*)color;

@end
