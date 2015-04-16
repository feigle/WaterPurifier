//
//  AlbumViewController.m
//  AlbumDemo
//
//  Created by bjdz on 15-3-3.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import "AlbumViewController.h"
#import "DetailViewController.h"
#import "PRTween.h"
#import "UIImage+Category.h"
#define btnBaceTag 1000
#define imgBaceTag 10000
#define sectionBaceTag 500
#define conTag 1000000
#define selBaceTag 6666
#define countForCell 100000
//图片间隔
#define space_w 2
#define header_h 40
@interface AlbumViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL   isEdit;
    //生成滚动视图时用到
    int    totalImage;
    float  tableViewOrigin;
    //保存将要删除的图片信息
    NSMutableDictionary  *_dicImageDel;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *BarRight;
//相册表示图
@property (retain, nonatomic) UITableView *AlbumTablewView;
//所有图片
@property (strong, nonatomic) NSMutableArray *imagesArr;
//已经被选择的图片
@property (strong, nonatomic) NSMutableDictionary *hadSelImgsDic;
@property (nonatomic,retain) NSArray *docList;
//删除按钮
@property (weak, nonatomic)UIButton *deleteBtn;
//保存每一个section中的图片数量
@property (strong, nonatomic) NSMutableArray *imagesInSectionArr;
//保存cell指针
@property (strong, nonatomic) NSMutableDictionary *cellDic;
@end

@implementation AlbumViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    //判断图片库是否有更新
    BOOL isNeed = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hadImagesUpdate"] boolValue];
    if (isNeed) {
        [self readPhotos];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置标题为白字
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    
    //初始化部分变量
    _dicImageDel = [[NSMutableDictionary alloc]init];
    self.imagesInSectionArr = [[NSMutableArray alloc]init];
    self.hadSelImgsDic = [[NSMutableDictionary alloc]init];
    self.imagesArr = [[NSMutableArray alloc]init];
    self.docList = [[NSArray alloc]init];
    self.cellDic = [[NSMutableDictionary alloc]init];
    
    //读取数据
    [self readPhotos];

    
#pragma mark -- 删除按钮
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteBtn.frame = CGRectMake(0, MRScreenHeight, MRScreenWidth, cellHeight);
    [self.deleteBtn addTarget:self action:@selector(btnDelete:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    self.deleteBtn.backgroundColor = ColorFromRGB(0x004a80);
    [self.view addSubview:self.deleteBtn];
}
- (void)initTableView
{
    self.AlbumTablewView = [[UITableView alloc]init];
    self.AlbumTablewView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    //去掉tableView底部横线
    //    [CommonFunc setExtraCellLineHidden:self.AlbumTablewView];
    if (tableViewOrigin == 0) {
        self.AlbumTablewView.frame = CGRectMake(0, tableViewOrigin, MRScreenWidth, MRScreenHeight-tabBarh-tableViewOrigin);
        tableViewOrigin = stanavh;
    }else{
        self.AlbumTablewView.frame = CGRectMake(0, tableViewOrigin, MRScreenWidth, MRScreenHeight-tabBarh-tableViewOrigin);
    }
    
    self.AlbumTablewView.delegate = self;
    self.AlbumTablewView.dataSource = self;
    [self.view addSubview:self.AlbumTablewView];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.imagesArr count];
}
- (float)getCellHeight:(int)section
{
    NSDictionary *dic =[self.imagesArr objectAtIndex:section];
    NSArray *images = [dic objectForKey:@"images"];
    
    //行数
    int lines = 0;
    if ([images count]%4==0)
        lines = [images count]/4;
    else
        lines = [images count]/4+1;
    
    //每行4张图片
    float imgWidth = (MRScreenWidth-space_w*5)/4;
    //空格行数
    int spaceLines = lines+1;
    //cell高度
    CGFloat cell_h = imgWidth*lines+spaceLines*space_w;
    return cell_h;
}
/**
 *  行高
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [self getCellHeight:indexPath.section];
}
/**
 *  header 高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSDictionary *dic = [self.imagesArr objectAtIndex:section];
    NSArray *arr = [dic objectForKey:@"images"];
    if ([arr count]>0) {
        return header_h;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSString *CellIdentifier = [NSString stringWithFormat:@"%d",countForCell*indexPath.section+indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        NSDictionary *dic =[self.imagesArr objectAtIndex:indexPath.section];
        NSArray *images = [dic objectForKey:@"images"];
        [self addPhotos:images andCell:cell indexPath:indexPath];

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
/**
 *  header
 *
 *  @param tableView
 *  @param section
 *
 *  @return
 */
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *dic = [self.imagesArr objectAtIndex:section];
    NSArray *arr = [dic objectForKey:@"images"];

    if ([arr count]>0) {
        UIView *headView = [[UIView alloc]init];
        headView.frame = CGRectMake(0, 0, MRScreenWidth, header_h);
        headView.backgroundColor = [UIColor whiteColor];
        UILabel *dateLabel = [[UILabel alloc]init];
        dateLabel.frame = headView.bounds;
        dateLabel.text = [NSString stringWithFormat:@" %@",[_docList objectAtIndex:section]];
        dateLabel.font = [UIFont fontWithName:@"ArialMT" size:12];
        [headView addSubview:dateLabel];
        return headView;
    }
    
    return nil;
}
/**
 *  添加照片到cell
 *
 *  @param photos
 *  @param cell
 */
- (void)addPhotos:(NSArray*)photos andCell:(UITableViewCell*)cell indexPath:(NSIndexPath *)indexPath
{
    //找到cell中的contentview并移除
    UIView *contentView = nil;
    for (int i=0; i<1000; i++) {
       contentView = [cell viewWithTag:i+sectionBaceTag];
        if (contentView) {
//            [contentView removeFromSuperview];
            //找到后跳出循环
            break;
        }
    }
    if (!contentView) {
        //重新生成
        contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, [self getCellHeight:indexPath.section])];
        contentView.tag = indexPath.section+sectionBaceTag;
        [cell addSubview:contentView];
    }
    //每行4张图片
    float imgWidth = (MRScreenWidth-space_w*5)/4;
    for (int i=0; i<[photos count]/4+1; i++) {
        
        for (int j=0; j<4; j++) {
            if (i*4+j>=[photos count]) {
                break;
            }
            //用于装载图片，按钮，删除图标
            UIView *contentViewSmall = [[UIView alloc]initWithFrame:cell.bounds];
            contentViewSmall.frame = CGRectMake(space_w+(imgWidth+space_w)*j, space_w+(imgWidth+space_w)*i, imgWidth, imgWidth);
            contentViewSmall.tag = i*4+j+conTag;
            [contentView addSubview:contentViewSmall];
            //图片
            UIImageView *imgView = [[UIImageView alloc]init];
            imgView.backgroundColor = [UIColor lightGrayColor];
            imgView.frame =contentViewSmall.bounds;
            imgView.tag = i*4+j+imgBaceTag;
            NSDictionary *imageDic = [photos objectAtIndex:i*4+j];
            [self setPhotoDataWithImageView:imgView imageDic:imageDic];
            [contentViewSmall addSubview:imgView];
            //点击按钮
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i*4+j+btnBaceTag;
            btn.frame = imgView.frame;
            [btn addTarget:self action:@selector(didImgBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [contentViewSmall addSubview:btn];
            //判断是否视频
            if ([[imageDic objectForKey:@"isVideo"] boolValue]) {
                //视频截图
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{//子线程读取数据
                    UIImage *image = [UIImage getImage:[self getImageUrlWithImageDic:imageDic]];
                    
                    if (image) {//主线程更新UI
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [imgView setImage:image];
                        });
                    }
                });
                
                //添加播放图标
                UIImageView *playImg = [[UIImageView alloc]init];
                [playImg setImage:[UIImage imageNamed:@"playButton"]];
                playImg.frame = CGRectMake(0, 0, 40, 40);
                playImg.center = imgView.center;
                [contentViewSmall addSubview:playImg];
                [contentViewSmall bringSubviewToFront:btn];
            }
            //判断是否选中状态
             NSString *imageSelect  = [imageDic objectForKey:@"isSelect"];
            if ([imageSelect boolValue]) {
                //添加选中图片
                UIImageView *deleteImg = [[UIImageView alloc]init];
                deleteImg.frame = CGRectMake(0, 0, 20, 20);
                deleteImg.tag = imgView.tag+indexPath.section*10000;
                NSLog(@"tag----------->:%d", deleteImg.tag);
                deleteImg.image = [UIImage imageNamed:@"selectedImg"];
                [imgView addSubview:deleteImg];
                [self.hadSelImgsDic setObject:deleteImg forKey:[NSString stringWithFormat:@"%d",deleteImg.tag]];
            }
        }
    }
}
#pragma mark -- 点击图片
/**
 *  点击图片上的按钮
 *
 *  @param gesture 手势
 */
- (void)didImgBtnClicked:(UIButton*)btn
{
    int btnIndexInSection = btn.tag - btnBaceTag;
    //btn点击的按钮
    //btn.superview为装载图片，和按钮的view
    //btn.superview.superview 为contentView，带有section的tag
    int section = btn.superview.superview.tag-sectionBaceTag;
    UIImageView *img = (UIImageView *)[btn.superview viewWithTag:btnIndexInSection+imgBaceTag];
    if (isEdit) {
        //取出改section的所有图片信息
        NSDictionary *images = [self.imagesArr objectAtIndex:section];
        NSArray *imageInSection = [images objectForKey:@"images"];
        //取出点击的图片的信息
        NSMutableDictionary *picDic = [imageInSection objectAtIndex:btnIndexInSection];
        NSString *imageSelect  = [picDic objectForKey:@"isSelect"];
        NSString *strPhotoName = nil;
        strPhotoName = [picDic objectForKey:@"name"];
        
        CLog(@"strPhotoName:%@",strPhotoName);
        //判断是否已经选择
        if ([imageSelect isEqualToString:@"YES"]) {
            [picDic setObject:@"NO" forKey:@"isSelect"];
            //del dic
            [_dicImageDel removeObjectForKey:strPhotoName];
            //添加或移除选中图标
            [self addOrDeleteSelectedView:btn.superview isAdd:NO andTag:img.tag+section*10000 andImgView:img];
        }else{
            
            [picDic setObject:@"YES" forKey:@"isSelect"];
            //add dic
            [_dicImageDel setObject:strPhotoName forKey:strPhotoName];
            //添加或移除选中图标
            [self addOrDeleteSelectedView:btn.superview isAdd:YES andTag:img.tag+section*10000 andImgView:img];
            
        }
//        if ([_dicImageDel count]>0)
//            [self showDeleteBtn:YES];
//        else
//            [self showDeleteBtn:NO];
//        //动画
//        [PRTween performSelector:@selector(animationLikeAlertView:) withObject:img];
        //标题
        int imgSelCount = [[_dicImageDel allKeys]count];
        if (imgSelCount < 1)
            self.title = @"请选择项目";
        else
            self.title = [NSString stringWithFormat:@"已选择%d个项目",imgSelCount];
    }else{
        int indexBefore = 0;
        //计算出该图片前面的section有多少张图片
        for (int i=0;i<section;i++) {
            int num = [[self.imagesInSectionArr objectAtIndex:i] intValue];
            indexBefore = indexBefore + num;
        }
        DetailViewController *detVC = [[DetailViewController alloc]init];
        detVC.imgNumber = totalImage;
        detVC.curTag = indexBefore + btnIndexInSection;
        detVC.imagesArr = self.imagesArr;
        [self presentViewController:detVC animated:YES completion:^{}];
    }
    
}
- (void)addOrDeleteSelectedView:(UIView*)view isAdd:(BOOL)isAdd andTag:(int)tag andImgView:(UIImageView*)imgView
{
    if (isAdd) {
        UIImageView *deleteImg = [[UIImageView alloc]init];
        deleteImg.frame = CGRectMake(0, 0, 20, 20);
        deleteImg.tag = tag;
        deleteImg.image = [UIImage imageNamed:@"selectedImg"];
        [imgView addSubview:deleteImg];
        CLog(@"^^^^^tag----------->:%d", deleteImg.tag);
        //保存已选择的图片
        [self.hadSelImgsDic setObject:deleteImg forKey:[NSString stringWithFormat:@"%d",tag]];
    }else{
        //取消选择
        [self.hadSelImgsDic removeObjectForKey:[NSString stringWithFormat:@"%d",tag]];
        for (UIView *sView in imgView.subviews) {
            [sView removeFromSuperview];
        }
    }
    
}
/**
 *  设置图片的data
 *
 *  @param imgView
 *  @param imageDic
 */
-(void)setPhotoDataWithImageView:(UIImageView*)imgView imageDic:(NSDictionary*)imageDic
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{//子线程读取数据
        // 获取Documents目录路径
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *imageName =[imageDic objectForKey:@"name"];
        NSString *dateStr = [[imageName componentsSeparatedByString:@" "] firstObject];
        NSString *docDir = [NSString stringWithFormat:@"%@/Photo/%@/%@",[paths objectAtIndex:0],dateStr,imageName];
        NSData*data = [NSData dataWithContentsOfFile:docDir];
        float imgWidth = (MRScreenWidth-space_w*5)/4;
        //糊涂图片的缩略图
        UIImage *image = [UIImage thumbnailWithImage:[UIImage imageWithData:data] size:CGSizeMake(imgWidth, imgWidth)];
        if (image) {//主线程更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                [imgView setImage:image];
            });
        }
    });
}


#pragma mark--读取相片
-(void)readPhotos
{
    [self.imagesInSectionArr removeAllObjects];
    [self.imagesArr removeAllObjects];
    _docList = nil;
    totalImage = 0;
    //读取相片
    NSString *strPhoto = @"Photo";
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    
    // 获取Documents目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *docDir = [NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],strPhoto];
    
    NSFileManager *FM=[NSFileManager defaultManager];
    NSError *error = nil;
    _docList = [FM contentsOfDirectoryAtPath:docDir error:&error];
    int imgNum = 0;
    for (int i = 0; i< [_docList count]; i++) {
        NSString *docName = [_docList objectAtIndex:i];
        //返回文件夹路径
        NSString *pathCur = [NSString stringWithFormat:@"%@/%@",docDir,docName];
        
        NSError *error = nil;
        NSArray *fileList = [[NSArray alloc] init];
        //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
        fileList = [FM contentsOfDirectoryAtPath:pathCur error:&error];
        NSMutableDictionary *mDicRoot = [NSMutableDictionary dictionary];
        [mDicRoot setObject: [NSString stringWithFormat:@"%@",docName] forKey:@"category"];
        
        NSMutableArray *arrayImage = [NSMutableArray arrayWithCapacity:0];
        imgNum = 0;
        
        //设置图片图片信息
        for (int j = 0; j<fileList.count; j++) {
            totalImage++;
            imgNum++;
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
        //保存每一个section的图片数量
        [self.imagesInSectionArr addObject:[NSNumber numberWithInt:imgNum]];
        [mDicRoot setObject:arrayImage forKey:@"images"];
#pragma mark -- 所有图像数据
        [self.imagesArr addObject:mDicRoot];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"hadImagesUpdate"];
    if (self.AlbumTablewView) {
        [self.AlbumTablewView removeFromSuperview];
        self.AlbumTablewView = nil;
        [self.cellDic removeAllObjects];
    }
    [self initTableView];
//    [self.AlbumTablewView reloadData];
}
- (IBAction)menuButtonPressed:(id)sender
{
    XDKAirMenuController *menu = [XDKAirMenuController sharedMenu];
    
    if (menu.isMenuOpened)
        [menu closeMenuAnimated];
    else
        [menu openMenuAnimated];
}
#pragma mark --点击选择按钮
/**
 *  点击选择按钮
 *
 *  @param sender button
 */
- (IBAction)ImageEdit:(id)sender {
    if ([self.imagesArr count]<1) {
        [self showNotice:@"图片库没有图片!"];
        return;
    }
    if ([self.BarRight.title isEqualToString:@"取消"]) {//点击取消
        self.tabBarController.tabBar.hidden = NO;
        self.BarRight.title = @"选择";
        isEdit          = NO;
        [self showDeleteBtn:NO];
        //移除全部的选中图标
        for (NSString *key in self.hadSelImgsDic) {
            UIImageView *img = [self.hadSelImgsDic objectForKey:key];
            [img removeFromSuperview];
        }
        [self.hadSelImgsDic removeAllObjects];
        [_dicImageDel removeAllObjects];
        //异步处理数据
        dispatch_queue_t newThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); dispatch_async(newThread,^{
            [self toNormal];
        });
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//            });
//        });
        
    }else{//点击选择
        [_dicImageDel removeAllObjects];
        [self.hadSelImgsDic removeAllObjects];
        self.BarRight.title = @"取消";
        isEdit = YES;
        self.tabBarController.tabBar.hidden = YES;
        [self showDeleteBtn:YES];
    }
}
-(void)toNormal
{
    for (int i = 0; i < self.imagesArr.count; i++) {
        NSDictionary *images = [self.imagesArr objectAtIndex:i];
        NSArray *imgsInSection = [images objectForKey:@"images"];
        
        for (int j = 0; j<imgsInSection.count; j++) {
            NSString *imageSelect = [[imgsInSection objectAtIndex:j]objectForKey:@"isSelect"];
            if ([imageSelect isEqualToString:@"YES"]) {
                [[imgsInSection objectAtIndex:j] setObject:@"NO" forKey:@"isSelect"];
            }
        }
        
    }
}
-(void)showDeleteBtn:(BOOL)isShow
{
    float h = 0;
    if (isShow){
        self.title = @"请选择项目";
        h = cellHeight;
    }
    else{
        self.title = @"图像";
        h = 0;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.deleteBtn.frame = CGRectMake(0, MRScreenHeight-h, MRScreenWidth, cellHeight);
    }];
}

#pragma mark --删除按钮
- (void)btnDelete:(id)sender {
    if ([_dicImageDel count]<1) {
        [self showNotice:@"请选择图片!"];
        return;
    }
    //删除图片文件
    //遍历字典
    for (int index=0;index<[_dicImageDel count]; index++) {
        
        NSString *object=[_dicImageDel objectForKey:[[_dicImageDel allKeys] objectAtIndex:index]];
        
        NSString *strFileDate = [[object componentsSeparatedByString:@" "] firstObject];
        NSString *strFile     = [NSString stringWithFormat:@"%@/%@",strFileDate,object];
        
        NSString *strPhoto    = @"Photo";
        // 获取Documents目录路径
        NSArray *paths        = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *imagePath   = [NSString stringWithFormat:@"%@/%@/%@",[paths objectAtIndex:0],strPhoto,strFile];
        
        NSFileManager *defaultManager;
        defaultManager = [NSFileManager defaultManager];
        NSError *error;
        BOOL bRet = [defaultManager fileExistsAtPath:imagePath];
        if (bRet) {
            //删除相片文件
            if ([defaultManager removeItemAtPath:imagePath error:&error])
            {
                CLog(@"delete ok");
            }
        }
        //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
         NSString *docPath   = [NSString stringWithFormat:@"%@/%@/%@",[paths objectAtIndex:0],strPhoto,strFileDate];
        NSArray *fileList = [defaultManager contentsOfDirectoryAtPath:docPath error:&error];
        //检查文件夹是否为空，空则删除
        if ([fileList count]<1) {
            //删除文件夹
            if ([defaultManager removeItemAtPath:docPath error:&error])
            {
                CLog(@"delete ok");
            }
        }
        
    }
    
    //删除UI
    //移除全部的选中图标
    for (NSString *key in self.hadSelImgsDic) {
        UIImageView *img = [self.hadSelImgsDic objectForKey:key];
        CLog(@"------>tag:%d",img.tag);
        [img.superview.superview removeFromSuperview];
        CLog(@"------>tag1:%d",img.tag);
    }
    [self.hadSelImgsDic removeAllObjects];
    [_dicImageDel removeAllObjects];
    
    [self readPhotos];
    
    self.BarRight.title = @"选择";
    isEdit = NO;
    self.tabBarController.tabBar.hidden = NO;
    [self showDeleteBtn:NO];
}

-(void)showNotice:(NSString *)detail
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    alert.shouldDismissOnTapOutside = YES;
    
    [alert showInfo:self title:@"温馨提示" subTitle:detail  closeButtonTitle:@"确定" duration:3.0f];
 
    
}
-(NSString *)getImageUrlWithImageDic:(NSDictionary*)imageDic
{
    // 获取Documents目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *imageName =[imageDic objectForKey:@"name"];
    NSString *dateStr = [[imageName componentsSeparatedByString:@" "] firstObject];
    NSString *docDir = [NSString stringWithFormat:@"%@/Photo/%@/%@",[paths objectAtIndex:0],dateStr,imageName];
    return docDir;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
