//
//  Alarm.m
//  CarEyeClient
//
//  Created by liyy on 2019/12/1.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "Alarm.h"
#import "DateUtil.h"

@implementation Alarm

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"alarmId" : @"id" };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [Alarm modelWithDictionary:dict];
}

- (NSString *) startTime {
    if (!_startTime) {
        return @"";
    }
    
    return [DateUtil timestampToString:_startTime];
}

- (NSString *) endTime {
    if (!_endTime) {
        return @"";
    }
    
    return [DateUtil timestampToString:_endTime];
}

- (NSString *) startSpeed {
    if (!_startSpeed) {
        return @"";
    }
    
    return _startSpeed;
}

- (NSString *) endSpeed {
    if (!_endSpeed) {
        return @"0";
    }
    
    return _endSpeed;
}

- (NSString *) endLat {
    if (!_endLat) {
        return @"--";
    }
    
    return _endLat;
}

- (NSString *) endLon {
    if (!_endLon) {
        return @"--";
    }
    
    return _endLon;
}

- (NSString *) startLat {
    if (!_startLat) {
        return @"--";
    }
    
    return _startLat;
}

- (NSString *) startLon {
    if (!_startLon) {
        return @"--";
    }
    
    return _startLon;
}

@end
