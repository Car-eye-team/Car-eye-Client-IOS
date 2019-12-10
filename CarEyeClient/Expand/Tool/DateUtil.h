//
//  DateUtil.h
//  GBSClientiOS
//
//  Created by asd on 2018/9/1.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

+ (NSString *) dateHH_MM_SS:(NSDate *)date;
+ (NSString *) dateYYYY_MM_DD:(NSDate *)date;
+ (NSString *) dateYYYYMMDD:(NSDate *)date;
+ (NSString *) dateYYYYMMDDHHmmss:(NSDate *)date;
+ (NSString *) dateYYYYMM:(NSDate *)date;

+ (NSString *) signDate;

+ (NSDate *) dateFormatYYYYMMDD:(NSString *)str;

+ (NSString *)timestampToString:(NSString *)str;
@end
