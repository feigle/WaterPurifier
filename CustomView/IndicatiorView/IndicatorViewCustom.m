//
//  IndicatorViewCustom.m
//  WaterPurifier
//
//  Created by bjdz on 15-3-6.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import "IndicatorViewCustom.h"
#import "RMDownloadIndicator.h"
@interface IndicatorViewCustom ()
//圆圈
@property (retain, nonatomic) RMDownloadIndicator *closedIndicator;

@end

@implementation IndicatorViewCustom



#pragma mark - Update Views
- (void)startAnimation:(float)dur
{
    //添加动画视图
    [self addDownloadIndicators];
    //一次完成
    [self updateViewOneTime:dur];
    //分多次加载
//    [self updateViewTimes];
}
- (void)addDownloadIndicators
{
    [_closedIndicator removeFromSuperview];
    _closedIndicator = nil;
//        [_filledIndicator removeFromSuperview];
    //    _filledIndicator = nil;
    //    [_mixedIndicator removeFromSuperview];
    //    _mixedIndicator = nil;
    
    
    RMDownloadIndicator *closedIndicator = [[RMDownloadIndicator alloc]initWithFrame:self.bounds type:kRMClosedIndicator];
    [closedIndicator setFillColor:[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
    [closedIndicator setStrokeColor:[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
    closedIndicator.radiusPercent = 0.45;
    [self addSubview:closedIndicator];
    
    [closedIndicator loadIndicator];
    _closedIndicator = closedIndicator;
    
    //    RMDownloadIndicator *filledIndicator = [[RMDownloadIndicator alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds) - 80)/2, CGRectGetMaxY(self.closedIndicator.frame) + 40.0f , 80, 80) type:kRMFilledIndicator];
    //    [filledIndicator setBackgroundColor:[UIColor whiteColor]];
    //    [filledIndicator setFillColor:[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
    //    [filledIndicator setStrokeColor:[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
    //    filledIndicator.radiusPercent = 0.45;
    //    [self.view addSubview:filledIndicator];
    //    [filledIndicator loadIndicator];
    //    _filledIndicator = filledIndicator;
    //
    //    RMDownloadIndicator *mixedIndicator = [[RMDownloadIndicator alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds) - 80)/2, CGRectGetMaxY(self.filledIndicator.frame) + 40.0f, 80, 80) type:kRMMixedIndictor];
    //    [mixedIndicator setBackgroundColor:[UIColor whiteColor]];
    //    [mixedIndicator setFillColor:[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
    //    [mixedIndicator setStrokeColor:[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
    //    mixedIndicator.radiusPercent = 0.45;
    //    [self.view addSubview:mixedIndicator];
    //    [mixedIndicator loadIndicator];
    //    _mixedIndicator = mixedIndicator;
}


- (void)updateView:(CGFloat)val
{
    self.downloadedBytes+=val;
    [_closedIndicator updateWithTotalBytes:100 downloadedBytes:self.downloadedBytes];
//    [_filledIndicator updateWithTotalBytes:100 downloadedBytes:self.downloadedBytes];
//    [_mixedIndicator updateWithTotalBytes:100 downloadedBytes:self.downloadedBytes];
}

- (void)updateViewOneTime:(float)dur
{
    [_closedIndicator setIndicatorAnimationDuration:dur];
    //    [_filledIndicator setIndicatorAnimationDuration:1.0];
    //    [_mixedIndicator setIndicatorAnimationDuration:1.0];
    
    [_closedIndicator updateWithTotalBytes:100 downloadedBytes:self.downloadedBytes];
    //    [_filledIndicator updateWithTotalBytes:100 downloadedBytes:self.downloadedBytes];
    //    [_mixedIndicator updateWithTotalBytes:100 downloadedBytes:self.downloadedBytes];
}
- (void)updateViewTimes
{
    self.downloadedBytes = 0;
    int delayInSeconds = 1;
    typeof(self) __weak weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds++ * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
        [weakself updateView:10.0f];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds++ * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
        [weakself updateView:10.0f];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds++ * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
        [weakself updateView:10.0f];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds++ * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
        [weakself updateView:20.0f];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds++ * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
        [weakself updateView:20.0f];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
        [weakself updateView:30.0f];
    });
}

@end


