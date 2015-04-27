//
//  TimeControlView.m
//  VideoMonitor
//
//  Created by Joblee on 14-9-22.
//  Copyright (c) 2014年 Andy. All rights reserved.
//

#import "TimeControlView.h"
#import "Additions.h"
#import <QuartzCore/QuartzCore.h>
#define View1_Tag 555
#define View2_Tag 556
#define View3_Tag 557
#define TIME_LABEL_TAG 233223
#define GetView(tag)    [self.timeLine viewWithTag:tag]
#define Self_Width      CGRectGetWidth(self.frame)
#define Self_Height     CGRectGetHeight(self.frame)
#define ScrollView_H    CGRectGetHeight(self.frame)

@implementation TimeControlView
@synthesize timeLine            = _timeLine;
@synthesize pointLine           = _pointLine;
@synthesize lastView            = _lastView;
@synthesize midView             = _midView;
@synthesize nextView            = _nextView;
@synthesize year                = _year;
@synthesize mon                 = _mon;
@synthesize day                 = _day;
@synthesize hour                = _hour;
@synthesize minute              = _minute;
@synthesize second              = _second;
@synthesize sDateStart          = _sDateStart;
@synthesize sDateEnd            = _sDateEnd;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.shuldCallBack = YES;
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        timeControlView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Self_Width, Self_Height)];
        [self addSubview:timeControlView];
//        [timeControlView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        //设置一个开始和结束时间
        _sDateStart = [NSDate getDateFromString:@"2014-10-14 17:00:00"];
        _sDateEnd   = [NSDate getDateFromString:@"2014-10-16 18:05:12"];
        //每个像素包含的毫秒数
        prifx  = 3600/(Self_Width/4);
        _TimeArr = [[NSMutableArray alloc]init];
        _TimeDic = [[NSMutableDictionary alloc]init];
        //测试时间
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:2];
        [dic setObject:@"2014-10-16 13:30:00" forKey:@"start"];
        [dic setObject:@"2014-10-16 14:00:00" forKey:@"end"];
        [self.TimeArr addObject:dic];

        dic = [[NSMutableDictionary alloc]initWithCapacity:2];
        [dic setObject:@"2014-10-15 05:00:00" forKey:@"start"];
        [dic setObject:@"2014-10-15 13:00:08" forKey:@"end"];
        [self.TimeArr addObject:dic];
        
        dic = [[NSMutableDictionary alloc]initWithCapacity:2];
        [dic setObject:@"2014-10-16 08:00:00" forKey:@"start"];
        [dic setObject:@"2014-10-16 11:00:00" forKey:@"end"];
        [self.TimeArr addObject:dic];
        
        dic = [[NSMutableDictionary alloc]initWithCapacity:2];
        [dic setObject:@"2014-10-15 23:00:00" forKey:@"start"];
        [dic setObject:@"2014-10-16 00:30:45" forKey:@"end"];
        [self.TimeArr addObject:dic];
        
        dic = [[NSMutableDictionary alloc]initWithCapacity:2];
        [dic setObject:@"2014-10-16 05:00:00" forKey:@"start"];
        [dic setObject:@"2014-10-16 06:30:45" forKey:@"end"];
        [self.TimeArr addObject:dic];
        
        dic = [[NSMutableDictionary alloc]initWithCapacity:2];
        [dic setObject:@"2014-10-15 17:00:00" forKey:@"start"];
        [dic setObject:@"2014-10-15 19:30:45" forKey:@"end"];
        [self.TimeArr addObject:dic];
        //开始时间和结束时间之间的时间长度
        _timeLength = [self.sDateEnd timeIntervalSinceDate:self.sDateStart];
        //初始化时间轴滚动视图
        [self initTimeLine];
        //给每个时间段画图
        for (NSMutableDictionary *dic in self.TimeArr) {
            [self dealDataWithDic:dic];
        }
        
    }
    return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return nil;
    
}

-(void)initTimeLine
{
    //日期圆弧

    NSTimeInterval time = [self.sDateEnd timeIntervalSince1970];
    currentTime = [[NSNumber numberWithDouble:time] longLongValue];
    currentDate = self.sDateEnd;
    //计算当前所在页数
    currentPage = _timeLength/(prifx*Self_Width);
    NSInteger seconds = [NSDate getDate:@"second" andDate:self.sDateEnd]+[NSDate getDate:@"minute"andDate:self.sDateEnd]*60;
    self.timeLine = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Self_Width, ScrollView_H)];
    [self.timeLine setDelegate:self];
    [self.timeLine setContentSize:CGSizeMake(Self_Width*(currentPage+2)+Self_Width/8+seconds/(3600*4/Self_Width), ScrollView_H)];
    [self.timeLine setContentOffset:CGPointMake(Self_Width*(currentPage+1)+Self_Width/8+seconds/(3600*4/Self_Width), 0)];
    startOffet_x = self.timeLine.contentOffset.x;
    [self.timeLine setBounces:NO];
    [self.timeLine setShowsHorizontalScrollIndicator:NO];
    [timeControlView addSubview:self.timeLine];
    //添加刻度视图及刻度下的时间
    [self addScaleView];
    //固定刻度针
    _pointLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 13, ScrollView_H)];
    self.pointLine.image = [UIImage imageNamed:@"RR_kedu.png"];
    self.pointLine.center = CGPointMake(Self_Width/2, ScrollView_H/2);
    [timeControlView addSubview:self.pointLine];
    calculateEnable = YES;

}

/**
 *  @brief 模拟播放视频，时间轴自动滚动
 */
-(void)playVideo
{
    if (willPlay) {
        [self performSelector:@selector(playVideo) withObject:nil afterDelay:1.0f];
        //转换格式
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:++scrollStopSeconds];
        //转换时区
        date = [NSDate getNowDateFromatAnDate:date];
        //显示时间
#warning 时间
//         NSString *time  = [[NSString stringWithFormat:@"%@",date]substringToIndex:19];
//        self.timeLabel.text = [[NSString stringWithFormat:@"%@",date]substringToIndex:19];
        secondsCount++;
        //每45秒向前移动一个像素
//        if (secondsCount==45) {
//            [self.timeLine setContentOffset:CGPointMake(self.timeLine.contentOffset.x+1.0f, 0)];
//            secondsCount = 0;
//        }
    }
    
}
/**
 *  @brief 画具有回放视频的时间段
 *
 *  @param distance 滚动的距离
 *  @param length   视频长度
 */
-(void)addDistanceViewWithDistance:(NSTimeInterval)distance andVideoLength:(NSTimeInterval)length
{
    //时间转换成像素点
    float prifixs   = distance/prifx;
    float lengthPri = length/prifx;
    UIView *lenView = [[UIView alloc]initWithFrame:CGRectMake(startOffet_x+Self_Width/2-prifixs, ScrollView_H/4, lengthPri, ScrollView_H/2)];
    lenView.backgroundColor = [UIColor cyanColor];
    lenView.alpha = 0.6;
    [self.timeLine addSubview:lenView];
}

/**
 *  @brief 计算时间段的秒数并画图
 *
 *  @param dic 包含开始时间和结束时间的字典
 */
-(void)dealDataWithDic:(NSMutableDictionary*)dic
{
    
    NSString *startTimeStr = [dic objectForKey:@"start"];
//
    NSString *endTimeStr = [dic objectForKey:@"end"];
    
    NSDate *dateStart = [NSDate getDateFromString:startTimeStr];
    NSDate *dateEnd = [NSDate getDateFromString:endTimeStr];
    //开始时间与当前当前时间的间隔
    NSTimeInterval distance = [NSDate getDistanceBetweenDate:dateStart Date:currentDate];
    //视频长度
    NSTimeInterval videoLength = [NSDate getDistanceBetweenDate:dateStart Date:dateEnd];
    //添加时间段
    [self addDistanceViewWithDistance:distance andVideoLength:videoLength];
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    willPlay = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (calculateEnable) {
        long long int tempOff = (startOffet_x-scrollView.contentOffset.x)*prifx;
        long long int tempTime = currentTime - tempOff;
        scrollStopSeconds = tempTime;
        //转换格式
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:tempTime];
        //转换时区
        date = [NSDate getNowDateFromatAnDate:date];
        //显示时间
        NSString *time = [[NSString stringWithFormat:@"%@",date]substringToIndex:19];
        if (self.shuldCallBack) {
            if ([self.delegate respondsToSelector:@selector(changeTime:andScrollOffet_x:)]) {
                [self.delegate changeTime:time andScrollOffet_x:startOffet_x-scrollView.contentOffset.x];
            }
            
        }
        
        
        NSInteger nextPage = scrollView.contentOffset.x/Self_Width;
        if (nextPage >=0) {
            //复用视图
            if (nextPage>currentPage) {//左滚
                if (scrollView.contentOffset.x>scrollView.contentSize.width-Self_Width) {
                    return;
                }
                //最后一个刻度
                UILabel *label = (UILabel*)[self.nextView viewWithTag:TIME_LABEL_TAG+3];
                int tempOck = [[[label.text componentsSeparatedByString:@":"]firstObject]intValue];
                //时间刻度
                for (int i=0; i<4; i++) {
                    UILabel *label = (UILabel*)[self.lastView viewWithTag:TIME_LABEL_TAG+i];
                    int tempTwo = tempOck+(1+i);
                    if (tempTwo>=24) {
                        tempTwo = tempTwo-24;
                    }
                    label.text = [NSString stringWithFormat:@"%d:00",tempTwo];
                    if (tempTwo<10) {
                        label.text = [NSString stringWithFormat:@"0%d:00",tempTwo];
                    }
                }
                //视图复用
                CGRect rect = self.lastView.frame;
                rect.origin.x = self.nextView.frame.origin.x+Self_Width;
                self.lastView.frame = rect;
                
                UIView *temp = self.lastView;
                self.lastView = self.midView;
                self.midView = self.nextView;
                self.nextView = temp;
                currentPage = nextPage;
                
            }else if(nextPage<currentPage){//右滚
                CGRect rect = self.lastView.frame;
                
                UILabel *label = (UILabel*)[self.lastView viewWithTag:TIME_LABEL_TAG];
                int tempOck = [[[label.text componentsSeparatedByString:@":"]firstObject]intValue];
                //时间刻度
                for (int i=0; i<4; i++) {
                    UILabel *label = (UILabel*)[self.nextView viewWithTag:TIME_LABEL_TAG+i];
                    
                    int tempTwo = tempOck-(4-i);
                    if (tempTwo<0) {
                        tempTwo = 24+tempTwo;
                    }
                    label.text = [NSString stringWithFormat:@"%d:00",tempTwo];
                    if (tempTwo<10) {
                        label.text = [NSString stringWithFormat:@"0%d:00",tempTwo];
                    }
                }
                
                rect.origin.x = self.lastView.frame.origin.x-Self_Width;
                self.nextView.frame = rect;
                
                
                UIView *temp = self.midView;
                self.midView = self.lastView;
                self.lastView = self.nextView;
                self.nextView = temp;
                currentPage = nextPage;
                
            }
        }
        //计算contentsize大小
        if (self.lastView.frame.origin.x<=Self_Width)
        {
//            scrollView.contentSize = CGSizeMake(scrollView.contentSize.width+Self_Width, CGRectGetHeight(scrollView.frame));
//            [scrollView setContentOffset:CGPointMake(Self_Width*2, 0)];
//            CGRect rect = self.lastView.frame;
//            rect.origin.x = self.nextView.frame.origin.x+Self_Width;
//            self.nextView.frame = rect;
//            self.lastView.frame = self.midView.frame;
//            self.midView.frame = self.nextView.frame;
//            currentPage++;
        }
        else if (CGRectGetMaxX(self.nextView.frame)>scrollView.contentSize.width-Self_Width)
        {
//            scrollView.contentSize = CGSizeMake(scrollView.contentSize.width+Self_Width, CGRectGetHeight(scrollView.frame));
//            [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width-Self_Width*4, 0)];
//            self.nextView.frame = self.midView.frame;
//            self.midView.frame = self.lastView.frame;
//            CGRect rect = self.lastView.frame;
//            rect.origin.x = self.lastView.frame.origin.x-Self_Width;
//            self.lastView.frame = rect;
//            currentPage--;
        }
    }
    
}
//减速停止
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    willPlay = YES;
    [self playVideo];
}

/**
 *  @brief 添加刻度视图及刻度下的时间
 */
-(void)addScaleView
{
    NSInteger curOclock = [NSDate getDate:@"hour" andDate:self.sDateEnd]-6;
    
    for (int i=0; i<3; i++) {
        UIView *scaleView = [[UIView alloc]initWithFrame:CGRectMake(Self_Width*(currentPage+i), 0, Self_Width, ScrollView_H)];
        
        UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Self_Width, ScrollView_H)];
        backgroundView.alpha = 0.9;
        backgroundView.image = [UIImage imageNamed:@"RR_timeShalf.png"];
        [scaleView addSubview:backgroundView];
        
        for (int j=0; j<4; j++) {
            int height = 12;
            //刻度下的时间
            UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, ScrollView_H-height, 40, height)];
            timeLabel.text = [NSString stringWithFormat:@"%d:00",curOclock+i*4+j];
            timeLabel.font = [UIFont systemFontOfSize:11.0];
            timeLabel.tag = TIME_LABEL_TAG+j;
            timeLabel.textColor = [UIColor whiteColor];
            timeLabel.center = CGPointMake(Self_Width/8+j*Self_Width/4, timeLabel.center.y);
            timeLabel.textAlignment = NSTextAlignmentCenter;
            [scaleView addSubview:timeLabel];
        }
        if (i==0) {
            _lastView = scaleView;
            _lastView.backgroundColor = [UIColor clearColor];
            [self.timeLine addSubview:self.lastView];
        }else if (i==1){
            _midView = scaleView;
            _midView.backgroundColor = [UIColor clearColor];
            [self.timeLine addSubview:self.midView];
        }else if (i==2){
            _nextView = scaleView;
            _nextView.backgroundColor = [UIColor clearColor];
            [self.timeLine addSubview:self.nextView];
        }
        
    }
    
}




/**
 *  @brief 获取指定月份的天数
 *
 *  @param mon 指定的月份
 *
 *  @return 天数
 */
-(int)getMonthTotalDays:(NSInteger)mon
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    comps = [calendar components:(NSMonthCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[[NSDate alloc] init]];
    [comps setMonth:mon];//mon表示获取当前月份的后mon个月的date，-mon表示当前月份的前mon个月的date；
    [comps setTimeZone: [NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    NSDate *today = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:today];
    return range.length;
}
/**
 *  @brief 获取当前的时间
 *
 *  @return 返回拼接后的时间
 */
-(NSString *)getCurrentTime
{
    NSDate *date = self.sDateEnd;
    self.year = [NSString stringWithFormat:@"%d",[NSDate getDate:@"year" andDate:date]];
    self.mon = [NSString stringWithFormat:@"%d",[NSDate getDate:@"month" andDate:date]];
    if ([NSDate getDate:@"month" andDate:date]<10) {
        self.mon = [NSString stringWithFormat:@"0%d",[NSDate getDate:@"month" andDate:date]];
    }
    self.day = [NSString stringWithFormat:@"%d",[NSDate getDate:@"day" andDate:date]];
    if ([NSDate getDate:@"day" andDate:date]<10) {
        self.day = [NSString stringWithFormat:@"0%d",[NSDate getDate:@"day" andDate:date]];
    }
    self.hour = [NSString stringWithFormat:@"%d",[NSDate getDate:@"hour" andDate:date]];
    if ([NSDate getDate:@"hour" andDate:date]<10) {
        self.hour = [NSString stringWithFormat:@"0%d",[NSDate getDate:@"hour" andDate:date]];
    }
    self.minute = [NSString stringWithFormat:@"%d",[NSDate getDate:@"minute" andDate:date]];
    if ([NSDate getDate:@"minute" andDate:date]<10) {
        self.minute = [NSString stringWithFormat:@"0%d",[NSDate getDate:@"minute" andDate:date]];
    }
    self.second = [NSString stringWithFormat:@"%d",[NSDate getDate:@"second" andDate:date]];
    tempSencond = [NSDate getDate:@"second" andDate:date];
    if ([NSDate getDate:@"second" andDate:date]<10) {
        self.second = [NSString stringWithFormat:@"0%d",[NSDate getDate:@"second" andDate:date]];
    }
    return [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",self.year,self.mon,self.day,self.hour,self.minute,self.second];
}


/**
 *  从数组中找出最早的开始时间和最晚的结束时间之间的时间长度
 *
 *  @param timeArr 包含时间字典的数组
 *
 *  @return 返回时间长度，以秒为单位
 */
-(NSTimeInterval)getTimeLength:(NSMutableArray*)timeArr
{
    for (NSMutableDictionary *dic in timeArr) {
        //时间转换
        NSDate *dateStart = [NSDate getDateFromString:[dic objectForKey:@"start"]];
        NSDate *dateEnd   = [NSDate getDateFromString:[dic objectForKey:@"end"]];
        //空指针处理
        if (!earlyDate) {
            earlyDate = dateStart;
        }
        if (!lateDate) {
            lateDate  = dateEnd;
        }
        //获取最早的时间
        earlyDate = [dateStart earlierDate:earlyDate];
        //获取最晚时间
        lateDate  = [dateEnd laterDate:lateDate];
        
    }
    
    //获取时间长度
    NSTimeInterval timeLength = [lateDate timeIntervalSinceDate:earlyDate];
    return timeLength;
}
@end
