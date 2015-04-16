//
//  PPCollectionViewCell.h
//  VideoMonitor
//
//  Created by Andy on 14-9-3.
//  Copyright (c) 2014年 Andy. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface PPCollectionViewCell : UICollectionViewCell

- (void)setImageCell:(UIImage*) image;
- (void)setImageVideo:(NSString*) image;
- (void)setImageSelect:(NSString*) image;
- (void)setTitle:(NSString*) title;
- (void) setImageTitleLabelWitdh:(CGFloat)width withHeight:(CGFloat)height;
- (void) setImageTitleTextColor:(UIColor*)textColor withBackgroundColor:(UIColor*)bgColor;
@end
