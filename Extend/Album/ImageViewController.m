//
//  ImageViewController.m
//  VideoMonitor
//
//  Created by Andy on 14-9-3.
//  Copyright (c) 2014年 Andy. All rights reserved.
//

#import "ImageViewController.h"
#import "PPImageScrollingTableViewCell.h"
#import "GalleryViewController.h"
#import "SHGalleryViewController.h"
#import "SHMediaItem.h"
#import "SHImageMediaItemViewController.h"
#import "SHMediaControlView.h"
#import "SHMediaControlTheme.h"
#import "PathService.h"
#define Cell_TAG 66445

#define MRScreenWidth      CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define MRScreenHeight     CGRectGetHeight([UIScreen mainScreen].applicationFrame)+20

@interface ImageViewController ()<PPImageScrollingTableViewCellDelegate,SHGalleryViewControllerDelegate, SHGalleryViewControllerDataSource>{
    BOOL   isEdit;
    int    totalImage;
    NSMutableDictionary  *_dicImageDel;
}

@property (weak, nonatomic) IBOutlet UITableView *tableImage;
@property (strong, nonatomic) NSMutableArray *images;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *BarRight;
@property (weak, nonatomic) IBOutlet UIView *viewControl;
@property (nonatomic, strong) SHGalleryViewController *galleryView;
@property (weak, nonatomic) IBOutlet UINavigationBar *NavBar;
@property (strong, nonatomic)  NSMutableDictionary *dicImageDel;
@property (nonatomic,retain) NSArray *docList;

@end

@implementation ImageViewController
@synthesize dicImageDel = _dicImageDel;
@synthesize docList = _docList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self RefLoadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rect = self.view.frame;
    rect.size.height = MRScreenHeight;
    self.view.frame = rect;
    // Do any additional setup after loading the view from its nib.
    self.dicImageDel = [NSMutableDictionary dictionaryWithCapacity:0];
    self.title = @"PPImageScrollingTableView";
    [self.NavBar setBackgroundImage:[UIImage imageNamed:@"title"] forBarMetrics:UIBarMetricsDefault];
    self.BarRight.title = @"编辑";
//    self.NavBar setb
    isEdit = NO;
    _viewControl.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
    [self.tableImage setBackgroundColor:[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0]];
    self.tableImage.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
    self.tableImage.frame = CGRectMake(0, 64, MRScreenWidth, self.view.frame.size.height-64);
    static NSString *CellIdentifier = @"Cell";
    [self.tableImage registerClass:[PPImageScrollingTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    self.images = [NSMutableArray arrayWithCapacity:0];
    
    
    
    SHMediaControlTheme *theme = [[SHMediaControlTheme alloc] init];
    theme.captionTitleColor = [UIColor whiteColor];
    theme.timeLabelColor = [UIColor whiteColor];
    theme.captionBarBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    theme.captionTitleFont = [UIFont systemFontOfSize:15];
    theme.timeLabelFont = [UIFont systemFontOfSize:11];
    
    theme.sliderProgressColor = [UIColor redColor];
    theme.sliderTrackColor = [UIColor whiteColor];
    //操作图片（停止/播放/关闭。。。。）
    theme.playButtonImage = [UIImage imageNamed:@"btn_player_play"];
    theme.pauseButtonImage = [UIImage imageNamed:@"btn_pause"];
    theme.doneButtonImage = [UIImage imageNamed:@"btn_close"];
    theme.sliderThumbImage = [UIImage imageNamed:@"icn_scrubber"];
    
    self.navigationController.navigationBarHidden = YES;
    _galleryView = [[SHGalleryViewController alloc] init];
    _galleryView.theme = theme;
    _galleryView.delegate = self;
    _galleryView.dataSource = self;
    
}

-(BOOL)shouldAutorotate

{
    return NO;
    
}
#pragma mark--读取相片
-(void)RefLoadData
{
    [self.images removeAllObjects];
    totalImage = 0;
    //读取相片
    NSString *strPhoto = @"Photo";
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //日期命名的全部文件夹
    _docList = [[NSArray alloc] init];
    // 获取Documents目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *docDir = [NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],strPhoto];
    
    NSFileManager *FM=[NSFileManager defaultManager];
    NSError *error = nil;
    _docList = [FM contentsOfDirectoryAtPath:docDir error:&error];
    
    for (int i = 0; i< [_docList count]; i++) {
        NSString *docName = [_docList objectAtIndex:i];
        //返回文件夹路径
        NSString *pathCur = [NSString stringWithFormat:@"%@/%@",docDir,docName];
        
        NSError *error = nil;
        NSArray *fileList = [[NSArray alloc] init];
        //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
        fileList = [FM contentsOfDirectoryAtPath:pathCur error:&error];
        NSLog(@"路径==%@,fileList%@",pathCur,fileList);
        NSMutableDictionary *mDicRoot = [NSMutableDictionary dictionary];
        [mDicRoot setObject: [NSString stringWithFormat:@"%@",docName] forKey:@"category"];

        NSMutableArray *arrayImage = [NSMutableArray arrayWithCapacity:0];
        //设置图片图片信息
        for (int j = 0; j<fileList.count; j++) {
            totalImage++;
            NSMutableDictionary *mDicImg = [NSMutableDictionary dictionary];
            NSString *strName = [NSString stringWithFormat:@"%@",[fileList objectAtIndex:j]];
            [mDicImg setObject: [NSString stringWithFormat:@"%@",[fileList objectAtIndex:j]] forKey:@"name"];
            [mDicImg setObject: [NSString stringWithFormat:@"%@",docName] forKey:@"title"];
            //判断是图片还是视频
            NSRange range = [strName rangeOfString:@".png"];
            if (range.length > 0 ) {
                [mDicImg setObject: @"NO" forKey:@"isVideo"];
                
            }else if([strName rangeOfString:@".mp4"].length > 0){
                
                [mDicImg setObject: @"YES" forKey:@"isVideo"];
            }
            [mDicImg setObject: @"NO" forKey:@"isSelect"];
            [arrayImage addObject:mDicImg];
            
        }
        [mDicRoot setObject:arrayImage forKey:@"images"];
#pragma mark -- 所有图像数据
        [self.images addObject:mDicRoot];
    }
    [self.tableImage reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --点击编辑按钮
/**
 *  点击编辑按钮
 *
 *  @param sender button
 */
- (IBAction)ImageEdit:(id)sender {
    if ([_BarRight.title isEqualToString:@"取消"]) {
        [self toNormal];
    }else{
        _BarRight.title = @"取消";
        isEdit = YES;
        _viewControl.hidden = NO;
        _tableImage.frame = CGRectMake(_tableImage.frame.origin.x, _tableImage.frame.origin.y, _tableImage.frame.size.width,_tableImage.frame.size.height - 48 );
    }
}
-(void)toNormal
{
    _BarRight.title = @"编辑";
    isEdit = NO;
    _viewControl.hidden = YES;
    _tableImage.frame = CGRectMake(_tableImage.frame.origin.x, _tableImage.frame.origin.y, _tableImage.frame.size.width,_tableImage.frame.size.height + 48 );
    for (int i = 0; i < self.images.count; i++) {
        NSDictionary *images = [self.images objectAtIndex:i];
        NSArray *imageCollection = [images objectForKey:@"images"];
        for (int j = 0; j<imageCollection.count; j++) {
            NSString *imageSelect = [[imageCollection objectAtIndex:j]objectForKey:@"isSelect"];
            if ([imageSelect isEqualToString:@"YES"]) {
                [[imageCollection objectAtIndex:j] setObject:@"NO" forKey:@"isSelect"];
            }
        }
        [_tableImage reloadData];
    }
}
#pragma mark --删除按钮
- (IBAction)btnDelete:(id)sender {
    //删除图片
    //遍历字典  一般的方法
    for (int index=0;index<[_dicImageDel count]; index++) {
        
        NSString *object=[_dicImageDel objectForKey:[[_dicImageDel allKeys] objectAtIndex:index]];
        
        NSString *strFileDate = [[object componentsSeparatedByString:@" "] firstObject];
        NSString *strFile = [NSString stringWithFormat:@"%@/%@",strFileDate,object];
        
        NSString *strPhoto = @"Photo";
        // 获取Documents目录路径
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *imagePath = [NSString stringWithFormat:@"%@/%@/%@",[paths objectAtIndex:0],strPhoto,strFile];
        
        NSFileManager *defaultManager;
        defaultManager = [NSFileManager defaultManager];
        NSError *error;
        BOOL bRet = [defaultManager fileExistsAtPath:imagePath];
        if (bRet) {
            if ([defaultManager removeItemAtPath:imagePath error:&error] != YES)
            {
                NSLog(@"delete ok");
            }
        }
        
    }
    /*
    NSLog(@"_dicImageDel = %@",_dicImageDel);
    for (int i = 0; i < self.images.count; i++) {
        NSDictionary *images = [self.images objectAtIndex:i];
        NSArray *imageCollection = [images objectForKey:@"images"];
        for (int j = 0; j<imageCollection.count; j++) {
            NSString *imageSelect = [[imageCollection objectAtIndex:j]objectForKey:@"isSelect"];
            if ([imageSelect isEqualToString:@"YES"]) {
                [[imageCollection objectAtIndex:j] setObject:@"NO" forKey:@"isSelect"];
            }
        }
    }
     */
    [_dicImageDel removeAllObjects];
    [self RefLoadData];
    
    [self toNormal];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    NSLog(@"[self.images count] = %ld",(long)[self.images count]);

    return [self.images count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSLog(@"indexPath.section = %ld",(long)indexPath.section);
    NSDictionary *cellData = [self.images objectAtIndex:[indexPath section]];
    PPImageScrollingTableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath ];
    customCell.sectionInCell = indexPath.section;
    customCell.docArray = _docList;
    [customCell setBackgroundColor:[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0]];
    [customCell setDelegate:self];
    [customCell setImageData:cellData];
    [customCell setCategoryLabelText:[cellData objectForKey:@"category"] withColor:[UIColor blackColor]];
    [customCell setTag:[indexPath section]];
    [customCell setImageTitleTextColor:[UIColor whiteColor] withBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    [customCell setImageTitleLabelWitdh:90 withHeight:45];
    [customCell setCollectionViewBackgroundColor:[UIColor clearColor]];
    
    return customCell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [[[self.images objectAtIndex:indexPath.section] objectForKey:@"images"] count];
    NSInteger total = count/4;
    int countMod = count%4;
    if (countMod > 0 ) {
        total++;
    }
    
    NSLog(@"total = %ld",(long)total);
    return total*80+20;
}

#pragma mark - PPImageScrollingTableViewCellDelegate
#pragma mark --点击图片回调
- (void)scrollingTableViewCell:(PPImageScrollingTableViewCell *)scrollingTableViewCell didSelectImageAtIndexPath:(NSIndexPath*)indexPathOfImage atCategoryRowIndex:(NSInteger)categoryRowIndex
{
/*
    NSMutableArray* assets = [NSMutableArray array];

    GalleryViewController* view = [[GalleryViewController alloc] init];
    view.assets = assets;
    view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    void(^task)() = ^{
        NSLog(@"2self: %@",self);
        NSLog(@"2go ed%@",self.presentedViewController);
        NSLog(@"2go ing%@",self.presentingViewController);
        printf("\n\n");
    };
 ~/Library/Developer/Xcode/DerivedData/bracelet-crntflspwmgbmifsruazirnjuuah
    //task = ^(){};
    task();
    //跳转前没意义
    //[self.navigationController pushViewController:view animated:YES];
    [self  presentViewController:view animated:YES completion:task];
    
    return;
 */
    if (isEdit) {
        NSDictionary *images = [self.images objectAtIndex:indexPathOfImage.section];
        NSArray *imageCollection = [images objectForKey:@"images"];
        NSString *imageSelect = [[imageCollection objectAtIndex:indexPathOfImage.row]objectForKey:@"isSelect"];
        NSString *strPhotoName = nil;
        strPhotoName = [[imageCollection objectAtIndex:[indexPathOfImage row]] objectForKey:@"name"];
        NSLog(@"strPhotoName:%@",strPhotoName);
        if ([imageSelect isEqualToString:@"YES"]) {
            [[imageCollection objectAtIndex:[indexPathOfImage row]] setObject:@"NO" forKey:@"isSelect"];
            //del dic
            [_dicImageDel removeObjectForKey:strPhotoName];
        }else{
            [[imageCollection objectAtIndex:[indexPathOfImage row]] setObject:@"YES" forKey:@"isSelect"];
            //add dic
            [_dicImageDel setObject:strPhotoName forKey:strPhotoName];
        }
        [_tableImage reloadData];
    }else{
        //赋值
        _galleryView.currentIndex = indexPathOfImage.row;
        _galleryView.currentSection = indexPathOfImage.section;
        [self presentViewController:_galleryView animated:YES completion:nil];
        //滚动到响应位置
        [_galleryView scrollToItemAtIndex:indexPathOfImage.row];
        /*
        NSDictionary *images = [self.images objectAtIndex:categoryRowIndex];
        NSArray *imageCollection = [images objectForKey:@"images"];
        NSString *imageTitle = [[imageCollection objectAtIndex:[indexPathOfImage row]]objectForKey:@"title"];
        NSString *categoryTitle = [[self.images objectAtIndex:categoryRowIndex] objectForKey:@"category"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat: @"Image %@",imageTitle]
                                                        message:[NSString stringWithFormat: @"in %@",categoryTitle]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
         */
    }
}

- (IBAction)buttonClicked:(id)sender {
    [self presentViewController:_galleryView animated:YES completion:nil];
}

- (CGFloat)numberOfItems {
    return totalImage;
}
#pragma mark -- 设置 名字 描述
- (SHMediaItem *)mediaItemIndex:(int)index andSection:(int)section{
    /*
     array:
     dic:{
        path，日期,名字，类型，
     }
     */
    // 获取Documents目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [NSString stringWithFormat:@"%@/Photo",[paths objectAtIndex:0]];
    /**
     *  问题
     */
    NSDictionary *dic = [self.images objectAtIndex:section];
    NSMutableArray *arr = [dic objectForKey:@"images"];
//    if ([arr count]==0) {
//        if ([self.images count]> section+1) {
//            dic = nil;
//            dic = [self.images objectAtIndex:section+1];
//            [arr removeAllObjects];
//            arr = [dic objectForKey:@"images"];
//            if (index >= [arr count]) {
//                return nil;
//            }
//        }
//    }else{
//        if ([arr count]<=1) {
//            if (section-1>=0) {
//                dic = nil;
//                dic = [self.images objectAtIndex:section-1];
//                [arr removeAllObjects];
//                arr = [dic objectForKey:@"images"];
//                if (index >= [arr count]) {
//                    return nil;
//                }
//            }else{
//                return nil;
//            }
//        }
//        
//    }
    if (index >= [arr count]) {
        return nil;
    }
    NSDictionary *imageDic = [arr objectAtIndex:index];
    docDir = [NSString stringWithFormat:@"%@/%@",docDir,[imageDic objectForKey:@"title"]];
    NSLog(@"index  = %d ",index);
    if([[imageDic objectForKey:@"isVideo"] boolValue]){        
        SHMediaItem *item = [[SHMediaItem alloc] init];
        item.mediaType = kMediaTypeVideo;
        item.captionTitle = @"视频播放";
        //视频路径
        NSString* path =[ NSString stringWithFormat:@"%@/Documents/Photo/%@/%@",NSHomeDirectory(),[imageDic objectForKey:@"title"],[imageDic objectForKey:@"name"]];//本地路径
        item.resourcePath = path;
        //缩略图
        item.mediaThumbnailImagePath = [[[NSBundle mainBundle] URLForResource:@"thumb" withExtension:@"jpg"] absoluteString];
        return item;
    } else {
        
        SHMediaItem *item = [[SHMediaItem alloc] init];
        item.mediaType = kMediaTypeImage;
        item.resourcePath = [NSString stringWithFormat:@"%@/%@",docDir,[imageDic objectForKey:@"name"]];
        item.captionTitle = @"图像描述";
        return item;
    }
}

- (void)galleryView:(SHGalleryViewController *)galleryView willDisplayItemAtIndex:(int)index {
    
}

- (void)galleryView:(SHGalleryViewController *)galleryView didDisplayItemAtIndex:(int)index {
    
}

- (void)doneClicked {
//    [self test];
    return;
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
