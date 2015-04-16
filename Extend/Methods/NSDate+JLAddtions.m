//
//  NSDate+JLAddtions.m
//  VideoMonitor
//
//  Created by Joblee on 14-10-20.
//  Copyright (c) 2014年 Andy. All rights reserved.
//

#import "NSDate+JLAddtions.h"

@implementation NSDate(Additions)
/**
 *  @brief 时间格式转换 NSString 转换成NSDate
 *
 *  @param dateStr 需要转换的时间
 *
 *  @return 已经转换的时间
 */
+(NSDate*)getDateFromString:(NSString*)dateStr
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [outputFormatter dateFromString:dateStr];
}
/**
 *  @brief 获取时间间隔(秒)
 *
 *  @param date        开始时间
 *  @param anotherDate 结束时间
 *
 *  @return 时间长度
 */
+(NSTimeInterval)getDistanceBetweenDate:(NSDate*)date Date:(NSDate*)anotherDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitSecond fromDate:date toDate:anotherDate options:0];
    return components.second;
}
#pragma mark --时间处理
/**
 *  @brief 转换时区
 *
 *  @param anyDate 需要转换的时间
 *
 *  @return 转换后的时间
 */
+(NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

/**
 *  @brief 获取指定日期的时刻
 *
 *  @param dateStr 时间类型：年、月、日、时......
 *
 *  @return 返回相应的时间
 */
+(NSInteger)getDate:(NSString *)dateStr andDate:(NSDate*)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger dateNum = 0;
    if ([dateStr isEqualToString:@"year"]) {
        dateNum = [comps year];
    }else if ([dateStr isEqualToString:@"month"]){
        dateNum = [comps month];
    }else if ([dateStr isEqualToString:@"day"]){
        dateNum = [comps day];
    }else if ([dateStr isEqualToString:@"hour"]){
        dateNum = [comps hour];
    }else if ([dateStr isEqualToString:@"minute"]){
        dateNum = [comps minute];
    }else if ([dateStr isEqualToString:@"second"]){
        dateNum = [comps second];
    }else if ([dateStr isEqualToString:@"week"]){
        dateNum = [comps week];
    }
    return dateNum;
}


/**
 *  @brief 获取指定月份的天数
 *
 *  @param mon 指定的月份
 *
 *  @return 天数
 */
+(int)getMonthTotalDays:(NSInteger)mon
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
 *  @brief 获取指定时间的下一秒
 *
 *  @param startDate 指定时间
 *
 *  @return 指定时间的下一秒时间
 */
+(NSDate*)getNextSecondDateWithDate:(NSDate*)startDate
{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDateComponents *comps = [calendar components:NSSecondCalendarUnit fromDate:startDate];
    [comps setSecond:+1];
    //    [comps setTimeZone: [NSTimeZone timeZoneWithAbbreviation:@"UTC+8"]];
    
    NSDate *date = [calendar dateByAddingComponents:comps toDate:startDate options:0];
    return date;
}
@end
