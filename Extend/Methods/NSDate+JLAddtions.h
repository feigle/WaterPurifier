//
//  NSDate+JLAddtions.h
//  VideoMonitor
//
//  Created by Joblee on 14-10-20.
//  Copyright (c) 2014年 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(Additions)
/**
 *  @brief 时间格式转换 NSString 转换成NSDate
 *
 *  @param dateStr 需要转换的时间
 *
 *  @return 已经转换的时间
 */
+(NSDate*)getDateFromString:(NSString*)dateStr;
/**
 *  @brief 获取时间间隔(秒)
 *
 *  @param date        开始时间
 *  @param anotherDate 结束时间
 *
 *  @return 时间长度
 */
+(NSTimeInterval)getDistanceBetweenDate:(NSDate*)date Date:(NSDate*)anotherDate;
#pragma mark --时间处理
/**
 *  @brief 转换时区
 *
 *  @param anyDate 需要转换的时间
 *
 *  @return 转换后的时间
 */
+(NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;

/**
 *  @brief 获取指定日期的时刻
 *
 *  @param dateStr 时间类型：年、月、日、时......
 *
 *  @return 返回相应的时间
 */
+(NSInteger)getDate:(NSString *)dateStr andDate:(NSDate*)date;


/**
 *  @brief 获取指定月份的天数
 *
 *  @param mon 指定的月份
 *
 *  @return 天数
 */
+(int)getMonthTotalDays:(NSInteger)mon;
/**
 *  @brief 获取指定时间的下一秒
 *
 *  @param startDate 指定时间
 *
 *  @return 指定时间的下一秒时间
 */
+(NSDate*)getNextSecondDateWithDate:(NSDate*)startDate;
@end
