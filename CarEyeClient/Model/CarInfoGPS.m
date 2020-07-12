//
//  CarInfoGPS.m
//  CarEyeClient
//
//  Created by asd on 2019/11/4.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "CarInfoGPS.h"
#import "YQLocationTransform.h"

@implementation CarInfoGPS

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"typeName" : @"typename" };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [CarInfoGPS modelWithDictionary:dict];
}

/**
 * 获取汽车方向
 * @param direction    方向数值
 * @return 状态名称
 */
- (NSString *) parseDirection:(NSString *)direction {
    double direc;
    NSString *direcStr;
    NSString *flag = @"方向";
    
    if (direction != NULL) {
        direc = [direction doubleValue];
        
        if (direc == 0) {
            direcStr = [NSString stringWithFormat:@"正北%@", flag];
        } else if(direc < 90) {
            direcStr = [NSString stringWithFormat:@"东北%@", flag];
        } else if(direc == 90) {
            direcStr = [NSString stringWithFormat:@"正东%@", flag];
        } else if(direc < 180) {
            direcStr = [NSString stringWithFormat:@"东南%@", flag];
        } else if(direc == 180) {
            direcStr = [NSString stringWithFormat:@"正南%@", flag];
        } else if(direc < 270) {
            direcStr = [NSString stringWithFormat:@"西南%@", flag];
        } else if(direc == 270) {
            direcStr = [NSString stringWithFormat:@"正西%@", flag];
        } else if(direc < 360) {
            direcStr = [NSString stringWithFormat:@"西北%@", flag];
        } else if(direc == 360) {
            direcStr = [NSString stringWithFormat:@"正北%@", flag];
        } else {
            direcStr = [NSString stringWithFormat:@"%@数据错误！", direction];
        }
    } else {
        direcStr = direction;
    }
    
    if (!direcStr) {
        return @"";
    }
    
    return direcStr;
}

- (double) bLatitude {
    YQLocationTransform *loc = [[YQLocationTransform alloc] initWithLatitude:[self.lat doubleValue] andLongitude:[self.lng doubleValue]];
    YQLocationTransform *res = [[loc transformFromGPSToGD] transformFromGDToBD];
    
    return res.latitude;
}

- (double) bLongitude {
    YQLocationTransform *loc = [[YQLocationTransform alloc] initWithLatitude:[self.lat doubleValue] andLongitude:[self.lng doubleValue]];
    YQLocationTransform *res = [[loc transformFromGPSToGD] transformFromGDToBD];
    
    return res.longitude;
}

- (NSString *) gpstimeDesc {
    if (self.gpstime && self.gpstime.length == 12) {
        NSString *year = [self.gpstime substringWithRange:NSMakeRange(0, 2)];
        NSString *month = [self.gpstime substringWithRange:NSMakeRange(2, 2)];
        NSString *day = [self.gpstime substringWithRange:NSMakeRange(4, 2)];
        NSString *hour = [self.gpstime substringWithRange:NSMakeRange(6, 2)];
        NSString *minute = [self.gpstime substringWithRange:NSMakeRange(8, 2)];
        NSString *second = [self.gpstime substringWithRange:NSMakeRange(10, 2)];
        
        return [NSString stringWithFormat:@"20%@-%@-%@ %@:%@:%@", year, month, day, hour, minute, second];
    }
    
    return @"";
}

- (NSString *) address {
    if (!_address) {
        return @"";
    }
    
    return _address;
}

@end
