//
//  PPScrollingTableViewCell.m
//  VideoMonitor
//
//  Created by Andy on 14-9-3.
//  Copyright (c) 2014年 Andy. All rights reserved.
//
#import "PPImageScrollingTableViewCell.h"
#import "PPImageScrollingCellView.h"

#define kScrollingViewHieght 240
#define kCategoryLabelWidth 250
#define kCategoryLabelHieght 20
#define kStartPointY 20

@interface PPImageScrollingTableViewCell() <PPImageScrollingViewDelegate>

@property (strong,nonatomic) UIColor *categoryTitleColor;
@property(strong, nonatomic) PPImageScrollingCellView *imageScrollingView;
@property (strong, nonatomic) NSString *categoryLabelText;

@end

@implementation PPImageScrollingTableViewCell
@synthesize docArray = _docArray;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _docArray = [[NSArray alloc]init];
        
        // Initialization code
        
//        [self initialize];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}

- (void)initialize
{
    // Set ScrollImageTableCellView
    if (!_imageScrollingView) {
        _imageScrollingView = [[PPImageScrollingCellView alloc] initWithFrame:CGRectMake(0, 0, MRScreenWidth, self.heightCell)];
        CLog(@"sectionInCell:%d",self.sectionInCell);
        _imageScrollingView.sectionInCell = self.sectionInCell;
        _imageScrollingView.delegate = self;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];    
    // Configure the view for the selected state
}
#pragma mark--设置tableview图片
- (void)setImageData:(NSDictionary*)collectionImageData
{
    NSInteger count = [[collectionImageData objectForKey:@"images"] count];
    NSInteger total = count/4;
    int countMod = count%4;
    if (countMod > 0 ) {
        total++;
    }
    self.heightCell = total*80;
    [self initialize];
    CLog(@"self.heightCell = %f",self.heightCell);
    _imageScrollingView.frame =CGRectMake(0, 20, MRScreenWidth, self.heightCell);

    [_imageScrollingView setImageData:[collectionImageData objectForKey:@"images"]];
    _categoryLabelText = [collectionImageData objectForKey:@"category"];
}

- (void)setCategoryLabelText:(NSString*)text withColor:(UIColor*)color{
    if ([self.contentView subviews]){
        for (UIView *subview in [self.contentView subviews]) {
            [subview removeFromSuperview];
        }
    }
    UILabel *categoryTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, kCategoryLabelWidth, kCategoryLabelHieght)];
    categoryTitle.textAlignment = NSTextAlignmentLeft;
    categoryTitle.text = text;
    categoryTitle.font = [UIFont systemFontOfSize:12];
    categoryTitle.textColor = color;
    categoryTitle.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:categoryTitle];
}
    
- (void) setImageTitleLabelWitdh:(CGFloat)width withHeight:(CGFloat)height {
    [_imageScrollingView setImageTitleLabelWitdh:width withHeight:height];
}

- (void) setImageTitleTextColor:(UIColor *)textColor withBackgroundColor:(UIColor *)bgColor{
    [_imageScrollingView setImageTitleTextColor:textColor withBackgroundColor:bgColor];
}

- (void)setCollectionViewBackgroundColor:(UIColor *)color{
    _imageScrollingView.backgroundColor = color;
    [self.contentView addSubview:_imageScrollingView];
}

#pragma mark - PPImageScrollingViewDelegate
#pragma mark ---点击图片缩略图
- (void)collectionView:(PPImageScrollingCellView *)collectionView didSelectImageItemAtIndexPath:(NSIndexPath*)indexPath {
    int dataCount = 0;
    //读取相片
    NSString *strPhoto = @"Photo";

    // 获取Documents目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],strPhoto];
    NSFileManager *FM=[NSFileManager defaultManager];
    for (int i = 0; i< indexPath.section; i++) {
        NSString *docName = [self.docArray objectAtIndex:i];
        //返回文件夹路径
        NSString *pathCur = [NSString stringWithFormat:@"%@/%@",docDir,docName];
        NSError *error = nil;
        //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
        NSArray *fileList = [FM contentsOfDirectoryAtPath:pathCur error:&error];
        dataCount = dataCount + [fileList count];
        
    }
    
    CLog(@"section:%d,row:%d",indexPath.section,indexPath.row);
    int index = dataCount+indexPath.row;
    [self.delegate scrollingTableViewCell:self didSelectImageAtIndexPath:indexPath atCategoryRowIndex:index];
}

@end
