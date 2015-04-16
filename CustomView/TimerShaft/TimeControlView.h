//
//  TimeControlView.h
//  VideoMonitor
//
//  Created by Joblee on 14-9-22.
//  Copyright (c) 2014年 Andy. All rights reserved.
//
/**
 * 时间轴
 **/
#import <UIKit/UIKit.h>
@protocol timeChangeDelegate <NSObject>

-(void)changeTime:(NSString *)time andScrollOffet_x:(float)offet_x;

@end
@interface TimeControlView : UIView<UIScrollViewDelegate>
{
    NSInteger       currentPage;
    BOOL            calculateEnable;
    BOOL            willPlay;
    float           tempOffset_x;
    NSInteger             tempSencond;
    long long int   currentTime;//当前时间的秒数
    long long int   scrollStopSeconds;//停止滚动时的秒数
    long long int   prifx;
    float           currentPoint;
    NSDate          *currentDate;
    NSInteger       secondsCount;
    UIView          *timeControlView;
    UIView          *imageVIew;
    NSTimeInterval  _timeLength;
    NSDate          *earlyDate;
    NSDate          *lateDate;
    float           startOffet_x;
    
}
@property (nonatomic,retain) UIScrollView        *timeLine;
@property (nonatomic,retain) UIImageView         *pointLine;
@property (nonatomic,retain) UIView              *lastView;
@property (nonatomic,retain) UIView              *midView;
@property (nonatomic,retain) UIView              *nextView;

@property (nonatomic,retain) NSString            *year;
@property (nonatomic,retain) NSString            *mon;
@property (nonatomic,retain) NSString            *day;
@property (nonatomic,retain) NSString            *hour;
@property (nonatomic,retain) NSString            *minute;
@property (nonatomic,retain) NSString            *second;
//是否需要回调
@property (nonatomic,assign) BOOL                shuldCallBack;
//查询时间
@property (nonatomic,retain) NSDate              *sDateStart;
@property (nonatomic,retain) NSDate              *sDateEnd;
//存放时间字典的数组
@property (nonatomic,retain) NSMutableArray      *TimeArr;
//存放时间段的字典
@property (nonatomic,retain) NSMutableDictionary *TimeDic;

@property (nonatomic,assign) id <timeChangeDelegate>delegate;



@end
