//
//  WarnViewModel.m
//  CarEyeClient
//
//  Created by asd on 2019/12/1.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "WarnViewModel.h"
#import "Alarm.h"

@implementation WarnViewModel

- (instancetype) init {
    if (self = [super init]) {
        self.data = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) liveqing_initialize {
    [self.dataCommand.executionSignals.switchToLatest subscribeNext:^(NetDataReturnModel *model) {
        if (model.type == ReturnSuccess) {
            self.totalPage = [model.result[@"pages"] intValue];
            NSArray *arr = [Alarm convertFromArray:model.result[@"list"]];
            if (arr.count > 0) {
                [self.data addObjectsFromArray:arr];
            } else {
                self.page--;
            }
        } else {
            self.page--;
        }
        
        [self.msgSubject sendNext:nil];
    }];
}

#pragma mark - RACCommand

// 获取设备报警分页列表
- (RACCommand *) dataCommand {
    if (!_dataCommand) {
        _dataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id refresh) {
            if (!refresh || [refresh boolValue]) {
                self.page = 1;
                [self.data removeAllObjects];
            } else {
                self.page++;
            }
            
            NSString *ip = [[LoginInfoLocalData sharedInstance] gainIPAddress];
            NSString *url = [NSString stringWithFormat:@"%@/queryAlarmList", ip];
            
            NSString *name = [[LoginInfoLocalData sharedInstance] gainName];
            NSString *pwd = [[LoginInfoLocalData sharedInstance] gainPWD];
            NSString *tradeno = [DateUtil signDate];
            NSString *str = [NSString stringWithFormat:@"%@%@%@", name, pwd, tradeno];
            NSString *sign = [MD5Util md5:str];
            
            NSDictionary *param = @{ @"tradeno" : tradeno,
                                     @"username" : (name ? name : @""),
                                     @"sign" : sign,
//                                     @"terminal" : self.param.car.terminal,
                                     @"terminal" : @"",
                                     @"carnumber" : self.param.car.nodeName,
                                     @"startTime" : self.param.begTime,
                                     @"endTime" : self.param.endTime,
                                     @"everyPage" : @(10),
                                     @"currentPage" : @(self.page)
                                     };
            
            return [self.request httpPostRequest:url params:param requestModel:nil];
        }];
    }
    
    return _dataCommand;
}

#pragma mark - RACSubject

- (RACSubject *) msgSubject {
    if (!_msgSubject) {
        _msgSubject = [[RACSubject alloc] init];
    }
    
    return _msgSubject;
}

@end
