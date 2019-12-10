//
//  DateUtil.m
//  GBSClientiOS
//
//  Created by asd on 2018/9/1.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

+ (NSString *) dateHH_MM_SS:(NSDate *)date {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    format.dateFormat = @"HH:mm:ss";
    return [format stringFromDate:date];
}

+ (NSString *) dateYYYY_MM_DD:(NSDate *)date {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    format.dateFormat = @"yyyy-MM-dd";
    return [format stringFromDate:date];
}

+ (NSString *) dateYYYYMMDD:(NSDate *)date {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    format.dateFormat = @"yyyyMMdd";
    return [format stringFromDate:date];
}

+ (NSString *) dateYYYYMMDDHHmmss:(NSDate *)date {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    format.dateFormat = @"yyyyMMddHHmmss";
    return [format stringFromDate:date];
}

+ (NSString *) dateYYYYMM:(NSDate *)date {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    format.dateFormat = @"yyyyMM";
    return [format stringFromDate:date];
}

+ (NSString *) signDate {
    NSDate *date = [NSDate date];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyyMMddHHmmss";
    return [format stringFromDate:date];
}

+ (NSDate *) dateFormatYYYYMMDD:(NSString *)str {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    format.dateFormat = @"yyyyMMdd";
    return [format dateFromString:str];
}

+ (NSString *)timestampToString:(NSString *)str {
    NSInteger timestamp = [str integerValue] / 1000;
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *string=[dateFormat stringFromDate:confromTimesp];
    
    return string;
}

@end
