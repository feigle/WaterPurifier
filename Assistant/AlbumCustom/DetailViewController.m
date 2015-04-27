//
//  DetailViewController.m
//  AlbumDemo
//
//  Created by bjdz on 15-3-3.
//  Copyright (c) 2015年 joblee. All rights reserved.
//
#import "Macros.h"
#import "DetailViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIImage+Category.h"

#define ViewTag 5000
#define MainScrenSize_W CGRectGetWidth([UIScreen mainScreen].bounds)
#define MainScrenSize_H CGRectGetHeight([UIScreen mainScreen].bounds)
@interface DetailViewController ()
{
    UIView *bgView;
}
@end

@implementation DetailViewController
@synthesize scrollView      = _scrollView;
@synthesize imagesArr       = _imagesArr;
@synthesize scaleEnable;

- (void)viewDidDisappear:(BOOL)animated
{
//    [self.scrollView removeFromSuperview];
//    self.scrollView = nil;
//    [bgView removeFromSuperview];
//    bgView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scrollViewScrollEnable) name:@"scrollNoc" object:nil];
    self.tabBarController.tabBar.hidden = YES;
//    self.view.backgroundColor = [UIColor redColor];
    [self initPhotos];
    [self addCustomNavingationBar];

    // Do any additional setup after loading the view.
}
- (void)singleTap
{
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = bgView.frame;
        if (rect.origin.y == 0) {
            rect.origin.y = -bgView.frame.size.height;
            
        }else{
            rect.origin.y = 0;
        }
        bgView.frame = rect;
    }];
    
    
}
- (void)scrollViewScrollEnable
{
    self.scrollView.scrollEnabled = !self.scrollView.scrollEnabled;
}
/**
 *  @brief 初始化：每一个//图片或视频装载在一个scrollView中，
 利用scrollView来进行放大缩小操作
 */
-(void)initPhotos
{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.frame))];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.backgroundColor = [UIColor blackColor];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width*self.imgNumber, self.scrollView.frame.size.height)];
    //    self.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.scrollView];
    int cout = 0;
    for (int i = 0; i < [self.imagesArr count]; i++) {
        NSDictionary *dic =[self.imagesArr objectAtIndex:i];
        NSArray *images = [dic objectForKey:@"images"];
        for (int j=0; j<[images count]; j++) {
            NSDictionary *imageDic = [images objectAtIndex:j];
            CGRect frame = self.scrollView.frame;
            self.zoomScrollView = [[ZoomScrollView alloc]initWithFrame:CGRectMake(frame.size.width*cout, 0, frame.size.width, self.scrollView.contentSize.height)];
            self.zoomScrollView.imageDic = [imageDic mutableCopy];
            self.zoomScrollView.playDelegate = self;
            
            self.zoomScrollView.tag = ViewTag+cout;
            self.zoomScrollView.zoomEnable      = self.scaleEnable;
            [self.scrollView addSubview:self.zoomScrollView];
            [self.zoomScrollView initImgView];
            if (cout == 0) {
                [self.zoomScrollView setImage];
            }
            cout++;
        }
        
    }

    
    CGRect rect = CGRectMake(MRScreenWidth*self.curTag, 0, MRScreenWidth, MRScreenHeight);
    [self.scrollView scrollRectToVisible:rect animated:NO];
}
- (void)addCustomNavingationBar
{
    
    bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, 0, MRScreenWidth, 20+cellHeight);
    UIImage *img=[UIImage imageNamed:@"BGNavBar"];
    bgView.backgroundColor = [img mostColor];
    [self.view addSubview:bgView];

    //创建一个导航栏
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, MRScreenWidth, cellHeight)];
    navBar.barTintColor = [img mostColor];
    [navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:nil];
    //在这个集合Item中添加标题，按钮
    //style:设置按钮的风格，一共有三种选择
    //action：@selector:设置按钮的点击事件
    //创建一个左边按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftButton)];
    
//    [leftButton setImage:[UIImage imageNamed:@"backWhite"]];
//    //创建一个右边按钮
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftButton)];

    //设置导航栏的内容
    [navItem setTitle:@"图片浏览"];
    
    //把导航栏集合添加到导航栏中，设置动画关闭
    [navBar pushNavigationItem:navItem animated:NO];
    
    //把按钮添加到导航栏集合中去
    [navItem setLeftBarButtonItem:leftButton];
//    [navItem setRightBarButtonItem:rightButton];
    
    //将标题栏中的内容全部添加到主视图当中
    [bgView addSubview:navBar];

}
/**
 *  动态加载图片,只加载三张图片
 *
 *  @param scrollView
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //动态加载图片
    int index = scrollView.contentOffset.x/MRScreenWidth;
    
    //当前
    ZoomScrollView *current = (ZoomScrollView *)[scrollView viewWithTag:ViewTag+index];
    [current setImage];

    //上张
    ZoomScrollView *last = (ZoomScrollView *)[scrollView viewWithTag:current.tag-1];
    [last setImage];
    //上上张
    ZoomScrollView *lLast = (ZoomScrollView *)[scrollView viewWithTag:current.tag-2];
    lLast.imgView.image = nil;
    //下张
    ZoomScrollView *next = (ZoomScrollView *)[scrollView viewWithTag:current.tag+1];
    [next setImage];
    //下下张
    ZoomScrollView *nNext = (ZoomScrollView *)[scrollView viewWithTag:current.tag+2];
    nNext.imgView.image = nil;
}
/**
 *  滚动到下一页后，自动设置上下两页的图片倍数为正常
 *
 *  @param scrollView
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x/MRScreenWidth;
    ZoomScrollView *current = (ZoomScrollView *)[scrollView viewWithTag:ViewTag+index];
    ZoomScrollView *last = (ZoomScrollView *)[scrollView viewWithTag:current.tag-1];
    ZoomScrollView *next = (ZoomScrollView *)[scrollView viewWithTag:current.tag+1];
    if (last) {
        [last zoomToNomal];
    }
    if (next) {
        [next zoomToNomal];
    }
    
    
}

- (void)clickLeftButton
{
    [self changeScreen:UIInterfaceOrientationPortrait];
    [self dismissViewControllerAnimated:YES completion:^{}];
}
#pragma mark --播放视频
-(void)playWithPath:(NSString *)path
{
    NSURL*videoPathURL=[[NSURL alloc] initFileURLWithPath:path];
    
    MPMoviePlayerViewController*playViewController=[[MPMoviePlayerViewController alloc] initWithContentURL:videoPathURL];
    MPMoviePlayerController*player=[playViewController moviePlayer];
    player.scalingMode=MPMovieScalingModeFill;
    player.controlStyle=MPMovieControlStyleFullscreen;
    [player play];
    [self presentViewController:playViewController animated:YES completion:nil];
}


-(BOOL)shouldAutorotate

{
    [self changeScreen:UIInterfaceOrientationPortrait];
    return NO;
    
}
//-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    
//}
- (void)changeScreen:(int)val
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
