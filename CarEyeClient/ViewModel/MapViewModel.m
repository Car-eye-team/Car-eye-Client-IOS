//
//  MapViewModel.m
//  CarEyeClient
//
//  Created by asd on 2019/11/4.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "MapViewModel.h"
#import "VersionTool.h"

@implementation MapViewModel

- (instancetype) init {
    if (self = [super init]) {
        self.versionURL = @"https://itunes.apple.com/lookup?id=1494270189";
        self.appStoreURL = @"https://itunes.apple.com/cn/app/id1494270189?mt=8";
    }
    
    return self;
}

- (void) liveqing_initialize {
    [self.dataCommand.executionSignals.switchToLatest subscribeNext:^(NetDataReturnModel *model) {
        if (model.type == ReturnSuccess) {
            self.data = [CarInfoGPS convertFromArray:model.result];
            self.model = self.data.firstObject;
            
            [self.dataSubject sendNext:nil];
        } else if (model.type == ReturnFailure) {
            [self.dataSubject sendNext:model.error];
        } else {
            [self.dataSubject sendNext:@"no data"];
        }
    }];
    
    // 检查版本的处理结果
    [self.versionCommand.executionSignals.switchToLatest subscribeNext:^(NetDataReturnModel *model) {
        if (model.type == ReturnSuccess) {
            NSArray *array = model.result[@"results"];
            NSDictionary *dict = [array lastObject];
            NSString *version = dict[@"version"];
            NSString *content = dict[@"releaseNotes"];
            
            // 比较版本
            if (![[VersionTool sharedInstance] isLastVersionWithNetVersion:version]) {
                [self.updateVersionSubject sendNext:content];
            }
        }
    }];
}

// 跟据设备号获取设备GPS状态
- (RACCommand *) dataCommand {
    if (!_dataCommand) {
        _dataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            NSString *ip = [[LoginInfoLocalData sharedInstance] gainIPAddress];
            NSString *url = [NSString stringWithFormat:@"%@/getTerminalGpsStatus", ip];
            
            NSString *name = [[LoginInfoLocalData sharedInstance] gainName];
            NSString *pwd = [[LoginInfoLocalData sharedInstance] gainPWD];
            NSString *tradeno = [DateUtil signDate];
            NSString *str = [NSString stringWithFormat:@"%@%@%@", name, pwd, tradeno];
            NSString *sign = [MD5Util md5:str];
            
            NSDictionary *param = @{ @"username" : (name ? name : @""),
                                     @"tradeno" : tradeno,
                                     @"sign" : sign,
                                     @"terminal" : (self.terminal ? self.terminal : @"")
                                     };
            
            return [self.request httpPostRequest:url params:param requestModel:nil];
        }];
    }
    
    return _dataCommand;
}

- (RACCommand *) versionCommand {
    if (!_versionCommand) {
        _versionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id x) {
            return [self.request httpGetRequest:self.versionURL params:nil requestModel:nil];
        }];
    }
    
    return _versionCommand;
}


- (RACSubject *) dataSubject {
    if (!_dataSubject) {
        _dataSubject = [RACSubject subject];
    }
    
    return _dataSubject;
}

- (RACSubject *) updateVersionSubject {
    if (!_updateVersionSubject) {
        _updateVersionSubject = [[RACSubject alloc] init];
    }
    
    return _updateVersionSubject;
}

@end
