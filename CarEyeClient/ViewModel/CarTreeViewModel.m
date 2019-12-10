//
//  CarTreeViewModel.m
//  CarEyeClient
//
//  Created by liyy on 2019/10/27.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "CarTreeViewModel.h"
#import "AppDelegate.h"

@implementation CarTreeViewModel

- (instancetype) init {
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void) liveqing_initialize {
    [self.dataCommand.executionSignals.switchToLatest subscribeNext:^(NetDataReturnModel *model) {
        if (model.type == ReturnSuccess) {
            [AppDelegate sharedDelegate].allCars = [DepartmentCar convertFromArray:model.result];
            NSMutableArray *onlineCars = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < [AppDelegate sharedDelegate].allCars.count; i++) {
                DepartmentCar *car = [AppDelegate sharedDelegate].allCars[i];
                if (car.nodetype == 1 || (car.carstatus != 1 && car.carstatus != 2 && car.carstatus != 3)) {
                    [onlineCars addObject:car];
                }
            }
            
            [AppDelegate sharedDelegate].onlineCars = onlineCars;
            
            [self.dataSubject sendNext:nil];
        } else if (model.type == ReturnFailure) {
            [self.dataSubject sendNext:model.error];
        } else {
            [self.dataSubject sendNext:@"no data"];
        }
    }];
}

- (RACCommand *) dataCommand {
    if (!_dataCommand) {
        _dataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            NSString *ip = [[LoginInfoLocalData sharedInstance] gainIPAddress];
            NSString *url = [NSString stringWithFormat:@"%@/deptTree", ip];
            
            NSString *name = [[LoginInfoLocalData sharedInstance] gainName];
            NSString *pwd = [[LoginInfoLocalData sharedInstance] gainPWD];
            NSString *tradeno = [DateUtil signDate];
            NSString *str = [NSString stringWithFormat:@"%@%@%@", name, pwd, tradeno];
            NSString *sign = [MD5Util md5:str];
            
            NSDictionary *param = @{ @"username" : (name ? name : @""),
                                     @"tradeno" : tradeno,
                                     @"sign" : sign
                                     };
            
//            return [self.request httpPostRequest:url params:param requestModel:nil];
            return [self.request httpPostPriorUseCacheRequest:url params:param requestModel:nil];
        }];
    }
    
    return _dataCommand;
}

- (RACSubject *) dataSubject {
    if (!_dataSubject) {
        _dataSubject = [RACSubject subject];
    }
    
    return _dataSubject;
}

@end
