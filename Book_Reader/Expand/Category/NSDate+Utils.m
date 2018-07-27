//
//  NSDate+Utils.m
//
//  Created by hhuua on 2016/12/30.
//  Copyright © 2016年 hhuua. All rights reserved.
//

#import "NSDate+Utils.h"

static const unsigned componentFlags = (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal);

@implementation NSDate (Utils)
+ (NSCalendar *) currentCalendar
{
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar)
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    return sharedCalendar;
}

#pragma mark - 计算时间间隔
+ (double)secondsFromDate:(NSDate*)dateFrom toDate:(NSDate*)dateTo
{
    return [dateTo timeIntervalSinceDate:dateFrom];
}

+ (double)secondsToNowFromDate:(NSDate*)dateFrom
{
    return [self secondsFromDate:dateFrom toDate:[NSDate date]];
}

+ (NSString*)formatDateWithString:(NSString*)str date:(NSDate*)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:str];
    return [formatter stringFromDate:date];
}

#pragma mark - 标准时间格式
+ (NSString*)formatDateyyyyMMddHHmmss:(NSDate*)date
{
    return [self formatDateWithString:@"yyyy-MM-dd HH:mm:ss" date:date];
}

+ (NSString*)formatDateyyyyMMddHHmm:(NSDate*)date
{
    return [self formatDateWithString:@"yyyy-MM-dd HH:mm" date:date];
}

+ (NSString*)formatDateMMddHHmmss:(NSDate*)date
{
    return [self formatDateWithString:@"MM-dd HH:mm:ss" date:date];
}

+ (NSString*)formatDateMMddHHmm:(NSDate*)date
{
    return [self formatDateWithString:@"MM-dd HH:mm" date:date];
}

+ (NSString*)formatDateyyyyMMdd:(NSDate*)date
{
    return [self formatDateWithString:@"yyyy-MM-dd" date:date];
}

+ (NSString*)formatDateHHmm:(NSDate*)date
{
    return [self formatDateWithString:@"HH:mm" date:date];
}

+ (NSString*)formatDateMMddEEEE:(NSDate*)date
{
    return [self formatDateWithString:@"MM月dd日 EEEE" date:date];
}

+ (NSString*)formatDateMMdd:(NSDate*)date
{
    return [self formatDateWithString:@"MM月dd日" date:date];
}

+ (NSString*)DescriptionMMddHHmmWith:(NSDate*)date
{
    if(date.month<10){
        return [self formatDateWithString:@"M月dd日 HH:mm" date:date];
    }
    return [self formatDateWithString:@"MM月dd日 HH:mm" date:date];
}

+ (NSString*)DescriptionyyyyMMddHHmmWith:(NSDate*)date
{
    if(date.month<10){
        return [self formatDateWithString:@"yyyy年M月dd日 HH:mm" date:date];
    }
    return [self formatDateWithString:@"yyyy年MM月dd日 HH:mm" date:date];
}

#pragma mark - 字符串时间格式
+ (NSString*)strDateyyyyMMddHHmmss:(NSDate*)date
{
    return [self formatDateWithString:@"yyyyMMddHHmmss" date:date];
}

+ (NSString*)strDateyyyyMMddHHmm:(NSDate*)date
{
    return [self formatDateWithString:@"yyyyMMddHHmm" date:date];
}

+ (NSString*)strMMddHHmmss:(NSDate*)date
{
    return [self formatDateWithString:@"MMddHHmmss" date:date];
}

+ (NSString*)strHHmm:(NSDate*)date
{
    return [self formatDateWithString:@"HH:mm" date:date];
}

+ (NSString*)stryyyyMMddHHmmssSSS:(NSDate*)date
{
    return [self formatDateWithString:@"yyyyMMddHHmmssSSS" date:date];
}

+ (NSString*)strDateMMddHHmm:(NSDate*)date
{
    return [self formatDateWithString:@"MMddHHmm" date:date];
}

+ (NSString*)strDateyyyyMMdd:(NSDate*)date
{
    return [self formatDateWithString:@"yyyyMMdd" date:date];
}

+ (NSString*)stryyyy:(NSDate*)date
{
    return [self formatDateWithString:@"yyyy" date:date];
}

+ (NSString*)stryyyyMM:(NSDate*)date
{
    return [self formatDateWithString:@"yyyyMM" date:date];
}

#pragma mark - 字符转时间
+ (NSDate*)dateWithStr:(NSString*)str dateFormat:(NSString*)format
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = format;
    
    NSDate* date = [formatter dateFromString:str];

    return date;
}

+ (NSDate*)dateWithStryyyyMMdd:(NSString*)str
{
    return [self dateWithStr:str dateFormat:@"yyyy-MM-dd"];
}

+ (NSDate*)dateWithStryyyyMMddHHmmss:(NSString*)str
{
    return [self dateWithStr:str dateFormat:@"yyyyMMddHHmmss"];
}

+ (NSDate*)dateWithFormatStryyyyMMddHHmmss:(NSString*)str
{
    return [self dateWithStr:str dateFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSDate*)dateWithFormatStryyyyMMdd:(NSString*)str
{
    return [self dateWithStr:str dateFormat:@"yyyy-MM-dd"];
}

+ (NSDate*)dateWithStryyyyMMddHHmmssSSS:(NSString*)str
{
    return [self dateWithStr:str dateFormat:@"yyyyMMddHHmmssSSS"];
}

+ (NSDate*)dateWithStrDayyyyyMMddHHmmss:(NSString*)str
{
    return [self dateWithStr:str dateFormat:@"yyyy-MM-dd HH:mm:ss.0"];
}

+ (NSDate*)dateWithStrHHmmss:(NSString*)str
{
    return [self dateWithStr:str dateFormat:@"HHmmss"];
}

+ (NSDate*)dateWithFormatStrHHmm:(NSString*)str
{
    return [self dateWithStr:str dateFormat:@"HH:mm"];
}

#pragma mark - 需要截取的字符串
+ (NSString*)dateWithSubStryyyyMMddHHmmss:(NSString*)str
{
    NSString* sub = [str substringToIndex:14];
    
//    NSString* year = [sub substringWithRange:NSMakeRange(0, 4)];
    
    NSString* month = [sub substringWithRange:NSMakeRange(4, 2)];
    
    NSString* day = [sub substringWithRange:NSMakeRange(6, 2)];
    
    NSString* hour = [sub substringWithRange:NSMakeRange(8, 2)];
    
    NSString* min = [sub substringWithRange:NSMakeRange(10, 2)];
    
//    NSString* sec = [sub substringWithRange:NSMakeRange(12, 2)];
    
    return [NSString stringWithFormat:@"%@-%@ %@:%@",month,day,hour,min];
}

+ (NSString*)dateWithSubStr:(NSString*)str
{
    NSString* sub = [str substringToIndex:14];
    
    NSString* year = [sub substringWithRange:NSMakeRange(0, 4)];
    
    NSString* month = [sub substringWithRange:NSMakeRange(4, 2)];
    
    NSString* day = [sub substringWithRange:NSMakeRange(6, 2)];
    
    NSString* hour = [sub substringWithRange:NSMakeRange(8, 2)];
    
    NSString* min = [sub substringWithRange:NSMakeRange(10, 2)];
    
    NSString* sec = [sub substringWithRange:NSMakeRange(12, 2)];
    
    return [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",year,month,day,hour,min,sec];
}

#pragma mark - 描述性字符串
+ (NSString*)getDescriptionWith:(NSDate*)date
{
    double seconds = fabs([self secondsFromDate:date toDate:[NSDate date]]);
    if(seconds<D_MINUTE*2)
    {
        return @"刚刚";
    }else if (seconds < D_MINUTE*D_MINUTE)
    {
        return [NSString stringWithFormat:@"%ld分钟前",(NSInteger)seconds/D_MINUTE];
    }else if (seconds < D_DAY)
    {
        return [self strHHmm:date];
    }else if (seconds < D_DAY*30)
    {
        return [NSString stringWithFormat:@"%ld天前",(NSInteger)seconds/D_DAY];
    }else
    {
        return [self formatDateMMddHHmm:date];
    }
    
    return nil;
}

#pragma mark - 获取月初与月末的时间(yyyyMMddHHmmss)
+ (NSString*)getEarlyMonthDateStr
{
    NSCalendar* calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents* components = [calender components:unitFlags fromDate:[NSDate date]];
    
    [components setDay:1];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    return [self strDateyyyyMMddHHmmss:[calender dateFromComponents:components]];
}

+ (NSString*)getEndOfTheMonthDateStr
{
    NSCalendar* calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents* components = [calender components:unitFlags fromDate:[NSDate date]];
    
    [components setDay:[self getDaysWithMonth:components.month year:components.year]];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    return [self strDateyyyyMMddHHmmss:[calender dateFromComponents:components]];
}

+ (NSString *)getUTCFormateLocalDate:(NSDate *)localDate
{
    return [self formatDateWithString:@"yyyy-MM-dd'T'HH:mm:ss'Z'" date:localDate];
}

+ (NSInteger)getDaysWithMonth:(NSInteger)month year:(NSInteger)year
{
    switch (month) {
        case 1:
            return 31;
        case 2:
        {
            if(!year%4)return 28;
            else return 29;
        }
        case 3:
            return 31;
        case 4:
            return 30;
        case 5:
            return 31;
        case 6:
            return 30;
        case 7:
            return 31;
        case 8:
            return 31;
        case 9:
            return 30;
        case 10:
            return 31;
        case 11:
            return 30;
        case 12:
            return 31;
            
        default:
            break;
    }
    return 31;
}

#pragma mark - 获取特定时间
+ (NSDate*)beginDateOfToday
{
    return [self beginDateBeforeDays:0];
}

+ (NSDate*)beginDateBeforeDays:(NSInteger)days
{
//     获取days天以前的那个时刻对应的components
    NSDate* daysBefore = [self dateWithDaysBeforeNow:0];
    
    NSCalendar* calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents* components = [calender components:unitFlags fromDate:daysBefore];
    // 将时分秒设置为0
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    // 返回新的时刻
    return [calender dateFromComponents:components];
}

+ (NSDate*)dateWithDaysBeforeNow:(NSInteger)days
{
    return [[NSDate date] dateByAddingTimeInterval:-days*24*3600];
}

#pragma mark - 属性
- (NSInteger) nearestHour
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    NSDateComponents *components = [[NSDate currentCalendar] components:NSCalendarUnitHour fromDate:newDate];
    return components.hour;
}

- (NSInteger) hour
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.hour;
}

- (NSInteger) minute
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.minute;
}

- (NSInteger) seconds
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.second;
}

- (NSInteger) day
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.day;
}

- (NSInteger) month
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.month;
}

- (NSInteger) week
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.weekOfMonth;
}

- (NSInteger) weekday
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.weekday;
}

- (NSInteger) year
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.year;
}

- (void)setYear:(NSInteger)year
{
    NSCalendar* calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    components.year = year;
    [calender dateFromComponents:components];
}

@end
