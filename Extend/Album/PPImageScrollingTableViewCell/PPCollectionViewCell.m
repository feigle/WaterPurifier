//
//  PPCollectionViewCell.m
//  VideoMonitor
//
//  Created by Andy on 14-9-3.
//  Copyright (c) 2014年 Andy. All rights reserved.
//

#import "PPCollectionViewCell.h"

@interface PPCollectionViewCell ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UITextView *imageTitle;
@property (strong, nonatomic) UIImageView  *imageViewSelect;
@property (strong, nonatomic) UIImageView  *imageViewVideo;

@end

@implementation PPCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0., 0., frame.size.width, frame.size.height)];
        self.imageView.backgroundColor = [UIColor blackColor];
        self.imageViewVideo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        CGPoint center = self.imageView.center;
        self.imageViewVideo.center = center;
        
        self.imageViewVideo.image = [UIImage imageNamed:@"playButton"];
        self.imageViewSelect = [[UIImageView alloc] initWithFrame:CGRectMake(48, 48, 30, 30)];
        //选中图片
        self.imageViewSelect.image = [UIImage imageNamed:@"selectedImg"];
    }
    return self;
}

-(void)setImageCell:(UIImage *)image
{
    self.imageView.image = image;
}

- (void)setImageVideo:(NSString*) image{
    if([image isEqualToString:@"YES"]){
        _imageViewVideo.hidden = NO;
    }else{
        _imageViewVideo.hidden = YES;
    }}
- (void)setImageSelect:(NSString*) image{
    if([image isEqualToString:@"YES"]){
        _imageViewSelect.hidden = NO;
    }else{
        _imageViewSelect.hidden = YES;
    }
}
- (void)setImageTitleLabelWitdh:(CGFloat)width withHeight:(CGFloat)height
{
    self.imageTitle = [[UITextView alloc] initWithFrame:CGRectMake(0., _imageView.frame.size.height/2+5, width,height)];
    self.imageTitle.contentInset = UIEdgeInsetsMake(1,1,1,1);
    self.imageTitle.userInteractionEnabled = NO;
    self.imageTitle.backgroundColor = [UIColor grayColor];
}

- (void)setImageTitleTextColor:(UIColor*)textColor withBackgroundColor:(UIColor*)bgColor
{
    self.imageTitle.textColor = textColor;
//    self.imageTitle.backgroundColor = bgColor;
}

- (void)setTitle:(NSString*)title ;
{
    if ([self.contentView subviews]){
        for (UILabel *subview in [self.contentView subviews]) {
            [subview removeFromSuperview];
        }
    }
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.imageViewSelect];
    [self.contentView addSubview:self.imageViewVideo];

    self.imageTitle.text = title;
//    [self.contentView addSubview:self.imageTitle];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
