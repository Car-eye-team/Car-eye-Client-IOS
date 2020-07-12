//
//  PlaybackViewModel.m
//  CarEyeClient
//
//  Created by asd on 2019/11/5.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "TrackViewModel.h"
#import "CarInfoGPS.h"

@implementation TrackViewModel

- (instancetype) init {
    if (self = [super init]) {
        self.data = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) liveqing_initialize {
    [self.dataCommand.executionSignals.switchToLatest subscribeNext:^(NetDataReturnModel *model) {
        if (model.type == ReturnSuccess) {
            NSArray *res = [CarInfoGPS convertFromArray:model.result];
            
            if (res.count > 9999) {
                [self.data addObjectsFromArray:[res subarrayWithRange:NSMakeRange(0, 9999)]];
            } else {
                [self.data addObjectsFromArray:res];
            }
            
            [self.dataSubject sendNext:nil];
        } else if (model.type == ReturnFailure) {
            [self.dataSubject sendNext:model.error];
        } else {
            [self.dataSubject sendNext:@"no data"];
        }
    }];
}

// 获取设备历史轨迹数据
- (RACCommand *) dataCommand {
    if (!_dataCommand) {
        _dataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            NSString *ip = [[LoginInfoLocalData sharedInstance] gainIPAddress];
            NSString *url = [NSString stringWithFormat:@"%@/getHistoryTrack", ip];
            
            NSString *name = [[LoginInfoLocalData sharedInstance] gainName];
            NSString *pwd = [[LoginInfoLocalData sharedInstance] gainPWD];
            NSString *tradeno = [DateUtil signDate];
            NSString *str = [NSString stringWithFormat:@"%@%@%@", name, pwd, tradeno];
            NSString *sign = [MD5Util md5:str];
            
            NSDictionary *param = @{ @"tradeno" : tradeno,
                                     @"username" : (name ? name : @""),
                                     @"sign" : sign,
                                     @"carnumber" : self.param.car.nodeName,
//                                     @"terminal" : self.param.car.terminal,
                                     @"terminal" : @"",
                                     @"startTime" : self.param.begTime,
                                     @"endTime" : self.param.endTime
                                     };
            
            return [self.request httpPostRequest:url params:param requestModel:nil];
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
