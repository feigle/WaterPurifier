//
//  ZoomScrollview.m
//  VideoMonitor
//
//  Created by Joblee on 14-9-17.
//  Copyright (c) 2014年 Joblee. All rights reserved.
//

#import "ZoomScrollview.h"
#import "UIImage+Category.h"

@interface ZoomScrollView (Utility)

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;

@end

@implementation ZoomScrollView
@synthesize imgView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = self;
    }
    return self;

}
- (void)initImgView
{
    
    // 获取Documents目录路径
    photoPath = [self getImageUrlWithImageDic:self.imageDic];
    
    imgView = [[UIImageView alloc]init];
    imgView.frame = self.bounds;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imgView];
    isVideo = [[self.imageDic objectForKey:@"isVideo"] boolValue];
    //判断是否视频
    if (isVideo) {
        //覆盖一张视频截图
        [imgView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage getImage:photoPath] waitUntilDone:NO];
        //一个播放按钮
        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        playBtn.frame = CGRectMake(0, 0, 50, 50);
        [playBtn setImage:[UIImage imageNamed:@"playButton"] forState:UIControlStateNormal];
        [playBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
        playBtn.center = imgView.center;
        [self addSubview:playBtn];
        
    }
    else
    {
        //    双击手势
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [self addGestureRecognizer:doubleTap];

        //缩小的最大倍数
        [self setMinimumZoomScale:1];
        //放大的最大倍数
        [self setMaximumZoomScale:4];
        [self setZoomScale:1];
    }
    
}
//加载图片
- (void)setImage
{
    if (imgView.image) {
        return;
    }
    if (isVideo) {
        //视频截图
        [imgView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage getImage:photoPath] waitUntilDone:NO];
    }else{
        NSData*data = [NSData dataWithContentsOfFile:photoPath];
        UIImage *img = [UIImage imageWithData:data];
        [imgView setImage:img];
    }
   
   
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
/**
 *  播放视频
 */
- (void)playVideo
{
    [self.playDelegate playWithPath:photoPath];
}
#pragma mark - Zoom methods
/**
 *  @brief 手势响应方法
 *
 *  @param gesture 手势
 */
- (void)handleDoubleTap:(UITapGestureRecognizer *)gesture
{
    if (gesture.numberOfTapsRequired==1) {
        
        //单击
        //原始倍数
        if (self.zoomScale == 1) {
            [self.playDelegate singleTap];
        }
        [self zoomToNomal];
        
        
    }else if(gesture.numberOfTapsRequired == 2){
        //双击
        //放大1.2倍
#if 0
        float newScale = self.zoomScale * 1.2f;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:self]];
        [self zoomToRect:zoomRect animated:YES];
#endif
    }

    
}
#pragma mark --放大到正常倍数
- (void)zoomToNomal
{
    if (!isVideo) {
        float newScale = 1.0f;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:self.center];
        [self zoomToRect:zoomRect animated:YES];
    }
    
}
/**
 *  @brief 放大缩小时响应方法
 *
 *  @param scale  当前的倍数
 *  @param center 当前的中心位置
 *
 *  @return 计算后的frame
 */
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    
   return imgView;
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale animated:NO];
}


@end
