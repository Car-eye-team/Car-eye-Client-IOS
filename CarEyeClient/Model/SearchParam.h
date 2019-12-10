//
//  SearchParam.h
//  CarEyeClient
//
//  Created by liyy on 2019/11/5.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DepartmentCar.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchParam : NSObject

@property (nonatomic, strong) DepartmentCar *car;
@property (nonatomic, copy) NSString *begTime;
@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, assign) int location;
@property (nonatomic, assign) int channel;

@end

NS_ASSUME_NONNULL_END
