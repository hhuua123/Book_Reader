//
//  NSDate+Utils.h
//
//  Created by hhuua on 2016/12/30.
//  Copyright © 2016年 hhuua. All rights reserved.
//

#import <Foundation/Foundation.h>

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926

@interface NSDate (Utils)

+ (NSCalendar *) currentCalendar;

// 计算时间间隔
+ (double)secondsFromDate:(NSDate*)dateFrom toDate:(NSDate*)dateTo; // 两个时间之间的秒数
+ (double)secondsToNowFromDate:(NSDate*)dateFrom;                   // 某个时间到现在的秒数

// 返回时间字符串
    //标准时间格式->yyyy-MM-dd HH:mm:ss 格式
+ (NSString*)formatDateyyyyMMddHHmmss:(NSDate*)date;
+ (NSString*)formatDateyyyyMMddHHmm:(NSDate*)date;
+ (NSString*)formatDateMMddHHmmss:(NSDate*)date;
+ (NSString*)formatDateMMddHHmm:(NSDate*)date;
+ (NSString*)formatDateyyyyMMdd:(NSDate*)date;
+ (NSString*)formatDateHHmm:(NSDate*)date;

    //字符串时间格式->yyyyMMddHHmmss 格式
+ (NSString*)strDateyyyyMMddHHmmss:(NSDate*)date;
+ (NSString*)strDateyyyyMMddHHmm:(NSDate*)date;
+ (NSString*)strDateMMddHHmm:(NSDate*)date;
+ (NSString*)strDateyyyyMMdd:(NSDate*)date;
+ (NSString*)strMMddHHmmss:(NSDate*)date;
+ (NSString*)stryyyyMMddHHmmssSSS:(NSDate*)date;
+ (NSString*)strHHmm:(NSDate*)date;
+ (NSString*)stryyyy:(NSDate*)date;
+ (NSString*)stryyyyMM:(NSDate*)date;

//字符串转时间
+ (NSDate*)dateWithStryyyyMMdd:(NSString*)str;
+ (NSDate*)dateWithStr:(NSString*)str dateFormat:(NSString*)format;
+ (NSDate*)dateWithStryyyyMMddHHmmss:(NSString*)str;
+ (NSDate*)dateWithStryyyyMMddHHmmssSSS:(NSString*)str;
+ (NSDate*)dateWithStrHHmmss:(NSString*)str;
+ (NSDate*)dateWithFormatStryyyyMMddHHmmss:(NSString*)str;
+ (NSDate*)dateWithFormatStrHHmm:(NSString*)str;
+ (NSDate*)dateWithFormatStryyyyMMdd:(NSString*)str;
+ (NSDate*)dateWithStrDayyyyyMMddHHmmss:(NSString*)str;

//特殊字符串截取
+ (NSString*)dateWithSubStryyyyMMddHHmmss:(NSString*)str;
+ (NSString*)dateWithSubStr:(NSString*)str;

//获取描述性字符串,例如:(刚刚,2分钟前等)
+ (NSString*)getDescriptionWith:(NSDate*)date;
+ (NSString*)DescriptionyyyyMMddHHmmWith:(NSDate*)date;
+ (NSString*)DescriptionMMddHHmmWith:(NSDate*)date;

//返回特殊的时间格式
// x月x日 星期几
+ (NSString*)formatDateMMddEEEE:(NSDate*)date;
// x月x日
+ (NSString*)formatDateMMdd:(NSDate*)date;

//获取月初与月末的时间(yyyyMMddHHmmss)
+ (NSString*)getEarlyMonthDateStr;
+ (NSString*)getEndOfTheMonthDateStr;

// UTC
+ (NSString *)getUTCFormateLocalDate:(NSDate *)localDate;


//获取特定时间
+ (NSDate*)beginDateOfToday;                        //获取今天凌晨0点整的时间
+ (NSDate*)beginDateBeforeDays:(NSInteger)days;     //获取days天之前的凌晨0点整的时间
+ (NSDate*)dateWithDaysBeforeNow:(NSInteger)days;   //获取days天之前的现在时刻的时间

//属性
@property (readonly) NSInteger nearestHour;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger week;
@property (readonly) NSInteger weekday;
@property (readonly) NSInteger year;


@end
