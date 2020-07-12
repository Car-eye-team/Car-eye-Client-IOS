//
//  DepartmentCar.m
//  CarEyeClient
//
//  Created by asd on 2019/10/27.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "DepartmentCar.h"

@implementation DepartmentCar

//+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
//    return @{ @"ID" : @"id" };
//}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [DepartmentCar modelWithDictionary:dict];
}

+ (NSString *) imageResource:(int)carstatus {
    switch (carstatus) {
        case 1:
        case 2: {
            return @"device_offline";
        }
        case 6: {
            return @"device_alarm";
        }
        default: {
            return @"device_online";
        }
    }
}

@end
