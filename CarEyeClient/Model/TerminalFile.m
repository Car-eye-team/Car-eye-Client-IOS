//
//  TerminalFile.m
//  CarEyeClient
//
//  Created by liyy on 2019/11/5.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "TerminalFile.h"

@implementation TerminalFile

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [TerminalFile modelWithDictionary:dict];
}

- (NSString *) startTime2 {
    if (!_startTime) {
        return @"";
    }
    
    if (_startTime.length == 12) {
        NSString *year = [_startTime substringWithRange:NSMakeRange(0, 2)];
        NSString *month = [_startTime substringWithRange:NSMakeRange(2, 2)];
        NSString *day = [_startTime substringWithRange:NSMakeRange(4, 2)];
        NSString *hour = [_startTime substringWithRange:NSMakeRange(6, 2)];
        NSString *minute = [_startTime substringWithRange:NSMakeRange(8, 2)];
        NSString *second = [_startTime substringWithRange:NSMakeRange(10, 2)];
        
        return [NSString stringWithFormat:@"20%@-%@-%@ %@:%@:%@", year, month, day, hour, minute, second];
    }
    
    return _startTime;
}

- (NSString *) endTime2 {
    if (!_endTime) {
        return @"";
    }
    
    if (_endTime.length == 12) {
        NSString *year = [_endTime substringWithRange:NSMakeRange(0, 2)];
        NSString *month = [_endTime substringWithRange:NSMakeRange(2, 2)];
        NSString *day = [_endTime substringWithRange:NSMakeRange(4, 2)];
        NSString *hour = [_endTime substringWithRange:NSMakeRange(6, 2)];
        NSString *minute = [_endTime substringWithRange:NSMakeRange(8, 2)];
        NSString *second = [_endTime substringWithRange:NSMakeRange(10, 2)];
        
        return [NSString stringWithFormat:@"20%@-%@-%@ %@:%@:%@", year, month, day, hour, minute, second];
    }
    
    return _endTime;
}

@end
