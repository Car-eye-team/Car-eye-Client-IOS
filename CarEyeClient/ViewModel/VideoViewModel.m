//
//  VideoViewModel.m
//  CarEyeClient
//
//  Created by liyy on 2019/11/9.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "VideoViewModel.h"

@implementation VideoViewModel

- (instancetype) init {
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void) liveqing_initialize {
    [self.dataCommand1.executionSignals.switchToLatest subscribeNext:^(NetDataReturnModel *model) {
        if (model.type == ReturnSuccess) {
            [self.dataSubject1 sendNext:model.result[@"url"]];
        } else if (model.type == ReturnFailure) {
            [self.dataSubject1 sendNext:model.error];
        } else {
            [self.dataSubject1 sendNext:@"no data"];
        }
    }];
    
    [self.dataCommand2.executionSignals.switchToLatest subscribeNext:^(NetDataReturnModel *model) {
        if (model.type == ReturnSuccess) {
            [self.dataSubject2 sendNext:model.result[@"url"]];
        } else if (model.type == ReturnFailure) {
            [self.dataSubject2 sendNext:model.error];
        } else {
            [self.dataSubject2 sendNext:@"no data"];
        }
    }];
    
    [self.dataCommand3.executionSignals.switchToLatest subscribeNext:^(NetDataReturnModel *model) {
        if (model.type == ReturnSuccess) {
            [self.dataSubject3 sendNext:model.result[@"url"]];
        } else if (model.type == ReturnFailure) {
            [self.dataSubject3 sendNext:model.error];
        } else {
            [self.dataSubject3 sendNext:@"no data"];
        }
    }];
    
    [self.dataCommand4.executionSignals.switchToLatest subscribeNext:^(NetDataReturnModel *model) {
        if (model.type == ReturnSuccess) {
            [self.dataSubject4 sendNext:model.result[@"url"]];
        } else if (model.type == ReturnFailure) {
            [self.dataSubject4 sendNext:model.error];
        } else {
            [self.dataSubject4 sendNext:@"no data"];
        }
    }];
}

- (RACCommand *) dataCommand1 {
    if (!_dataCommand1) {
        _dataCommand1 = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [self.request httpPostRequest:[self url] params:[self param:@"1"] requestModel:nil];
        }];
    }
    
    return _dataCommand1;
}

- (RACCommand *) dataCommand2 {
    if (!_dataCommand2) {
        _dataCommand2 = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [self.request httpPostRequest:[self url] params:[self param:@"2"] requestModel:nil];
        }];
    }
    
    return _dataCommand2;
}

- (RACCommand *) dataCommand3 {
    if (!_dataCommand3) {
        _dataCommand3 = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [self.request httpPostRequest:[self url] params:[self param:@"3"] requestModel:nil];
        }];
    }
    
    return _dataCommand3;
}

- (RACCommand *) dataCommand4 {
    if (!_dataCommand4) {
        _dataCommand4 = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [self.request httpPostRequest:[self url] params:[self param:@"4"] requestModel:nil];
        }];
    }
    
    return _dataCommand4;
}

// 播放和停止视频
- (NSString *) url {
    NSString *ip = [[LoginInfoLocalData sharedInstance] gainIPAddress];
    NSString *url = [NSString stringWithFormat:@"%@/playSend", ip];
    return url;
}

- (NSDictionary *)param:(NSString *)channelID {
    NSString *name = [[LoginInfoLocalData sharedInstance] gainName];
    NSString *pwd = [[LoginInfoLocalData sharedInstance] gainPWD];
    NSString *tradeno = [DateUtil signDate];
    NSString *str = [NSString stringWithFormat:@"%@%@%@", name, pwd, tradeno];
    NSString *sign = [MD5Util md5:str];
    
    NSDictionary *param = @{ @"username" : (name ? name : @""),
                             @"tradeno" : tradeno,
                             @"sign" : sign,
                             @"terminal" : (self.terminal ? self.terminal : @""),
                             @"id" : channelID,     // 通道号 1至32
                             @"type" : self.type,   // 0开启 1关闭
                             @"protocol" : @"1",    // 0：RTSP 1: RTMP 2:RTP 3： 其他
                             @"vedioType" : @"0",   // 0：音视频 1视频 2 双向对讲 3 监听 4 中心广播5 透传
                             @"streamType" : @"1"   // 0:主码流 1：子码流
                             };
    return param;
}

- (RACSubject *) dataSubject1 {
    if (!_dataSubject1) {
        _dataSubject1 = [RACSubject subject];
    }
    
    return _dataSubject1;
}

- (RACSubject *) dataSubject2 {
    if (!_dataSubject2) {
        _dataSubject2 = [RACSubject subject];
    }
    
    return _dataSubject2;
}

- (RACSubject *) dataSubject3 {
    if (!_dataSubject3) {
        _dataSubject3 = [RACSubject subject];
    }
    
    return _dataSubject3;
}

- (RACSubject *) dataSubject4 {
    if (!_dataSubject4) {
        _dataSubject4 = [RACSubject subject];
    }
    
    return _dataSubject4;
}

@end
