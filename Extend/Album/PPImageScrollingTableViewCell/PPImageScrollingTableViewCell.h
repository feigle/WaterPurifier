//  PPScrollingTableViewCell.h
//  VideoMonitor
//
//  Created by Andy on 14-9-3.
//  Copyright (c) 2014年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PPImageScrollingTableViewCell;

@protocol PPImageScrollingTableViewCellDelegate <NSObject>

// Notifies the delegate when user click image
- (void)scrollingTableViewCell:(PPImageScrollingTableViewCell *)scrollingTableViewCell didSelectImageAtIndexPath:(NSIndexPath*)indexPathOfImage atCategoryRowIndex:(NSInteger)categoryRowIndex;

@end

@interface PPImageScrollingTableViewCell : UITableViewCell

@property (weak, nonatomic) id<PPImageScrollingTableViewCellDelegate> delegate;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat heightCell;
@property (nonatomic,strong) NSArray *docArray;
@property (nonatomic) NSInteger sectionInCell;

- (void) setImageData:(NSDictionary*) image;
- (void) setCollectionViewBackgroundColor:(UIColor*) color;
- (void) setCategoryLabelText:(NSString*)text withColor:(UIColor*)color;
- (void) setImageTitleLabelWitdh:(CGFloat)width withHeight:(CGFloat)height;
- (void) setImageTitleTextColor:(UIColor*)textColor withBackgroundColor:(UIColor*)bgColor;

@end