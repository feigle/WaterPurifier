//
//  PPImageScrollingCellView.m
//  VideoMonitor
//
//  Created by Andy on 14-9-3.
//  Copyright (c) 2014年 Andy. All rights reserved.
//
#import "PPImageScrollingCellView.h"
#import "PPCollectionViewCell.h"
#define Cell_TAG 66445
@interface  PPImageScrollingCellView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) PPCollectionViewCell *myCollectionViewCell;
@property (strong, nonatomic) UICollectionView *myCollectionView;
@property (strong, nonatomic) NSArray *collectionImageData;
@property (nonatomic) CGFloat imagetitleWidth;
@property (nonatomic) CGFloat imagetitleHeight;
@property (strong, nonatomic) UIColor *imageTilteBackgroundColor;
@property (strong, nonatomic) UIColor *imageTilteTextColor;


@end

@implementation PPImageScrollingCellView

- (id)initWithFrame:(CGRect)frame
{
     self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code

        /* Set flowLayout for CollectionView*/
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(75, 75);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 4, 0, 4);
        flowLayout.minimumLineSpacing = 4;
        flowLayout.minimumInteritemSpacing = 4;
//        flowLayout.s
        /* Init and Set CollectionView */
        CLog(@"self.bounds.origin.x, = %f,self.bounds.origin.y = %f",self.bounds.origin.x,self.bounds.origin.y);
        
        CLog(@"self.bounds.size.width = %f,self.bounds.size.height = %f",self.bounds.size.width,self.bounds.size.height);
        
        self.myCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        self.myCollectionView.delegate = self;
        self.myCollectionView.backgroundColor = [UIColor whiteColor];
        self.myCollectionView.dataSource = self;
        self.myCollectionView.showsHorizontalScrollIndicator = NO;
        self.myCollectionView.scrollEnabled = NO;
        [self.myCollectionView registerClass:[PPCollectionViewCell class] forCellWithReuseIdentifier:@"PPCollectionCell"];
        [self addSubview:_myCollectionView];
    }
    return self;
}

- (void) setImageData:(NSArray*)collectionImageData{
    _collectionImageData = collectionImageData;
    NSInteger count = collectionImageData.count;
    NSInteger total = count/4;
    int countMod = count%4;
    if (countMod > 0 ) {
        total++;
    }

    _myCollectionView.frame = CGRectMake(0, 0, MRScreenWidth, total*80);
    [_myCollectionView reloadData];
}

- (void) setBackgroundColor:(UIColor*)color{
//    self.myCollectionView.backgroundColor = color;
//    [_myCollectionView reloadData];
}

- (void) setImageTitleLabelWitdh:(CGFloat)width withHeight:(CGFloat)height{
    _imagetitleWidth = width;
    _imagetitleHeight = height;
}
- (void) setImageTitleTextColor:(UIColor*)textColor withBackgroundColor:(UIColor*)bgColor{
    _imageTilteTextColor = textColor;
    _imageTilteBackgroundColor = bgColor;
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    CLog(@"self.collectionImageData count = %lu",(unsigned long)[self.collectionImageData count]);
    
    return [self.collectionImageData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{    
    PPCollectionViewCell *cell = (PPCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"PPCollectionCell" forIndexPath:indexPath];

    // 获取Documents目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *imageDic = [self.collectionImageData objectAtIndex:[indexPath row]];
    NSString *imageName =[imageDic objectForKey:@"name"];
    NSString *dateStr = [[imageName componentsSeparatedByString:@" "] firstObject];
    NSString *docDir = [NSString stringWithFormat:@"%@/Photo/%@/%@",[paths objectAtIndex:0],dateStr,imageName];
    NSData*data = [NSData dataWithContentsOfFile:docDir];
    [cell setImageCell:[UIImage imageWithData:data]];
    [cell setImageVideo:[imageDic objectForKey:@"isVideo"]];
    [cell setImageSelect:[imageDic objectForKey:@"isSelect"]];
    [cell setImageTitleLabelWitdh:_imagetitleWidth withHeight:_imagetitleHeight];
    [cell setImageTitleTextColor:_imageTilteTextColor withBackgroundColor:_imageTilteBackgroundColor];
    [cell setTitle:[imageDic objectForKey:@"title"]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *indexPathTemp = [NSIndexPath indexPathForRow:indexPath.row inSection:self.sectionInCell];
    indexPath = indexPathTemp;
    CLog(@"row:%d,section:%d",indexPath.row,indexPath.section);
    [self.delegate collectionView:self didSelectImageItemAtIndexPath:(NSIndexPath*)indexPath];
    
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
