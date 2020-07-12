//
//  VideoViewModel.m
//  CarEyeClient
//
//  Created by asd on 2019/11/9.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "VideoViewModel.h"

@implementation VideoViewModel

- (instancetype) init {
    if (self = [super init]) {
        self.dataCommands = @[self.dataCommand1, self.dataCommand2,
        self.dataCommand3, self.dataCommand4,
        self.dataCommand5, self.dataCommand6,
        self.dataCommand7, self.dataCommand8];
    }
    
    return self;
}

- (void) liveqing_initialize {
    [self.dataCommand1.executionSignals.switchToLatest subscribeNext:^(NetDataReturnModel *model) {
        if (model.type == ReturnSuccess) {
            NSString *url = model.result[@"url"];
//            url = @"rtmp://202.69.69.180:443/webcast/bshdlive-pc";
            
            [self.dataSubject1 sendNext:url];
        } else if (model.type == ReturnFailure) {
            [self.dataSubject1 sendNext:model.error];
        } else {
            [self.dataSubject1 sendNext:@"no data"];
        }
    }];
    
    [self.dataCommand2.executionSignals.switchToLatest subscribeNext:^(NetDataReturnModel *model) {
        if (model.type == ReturnSuccess) {
            NSString *url = model.result[@"url"];
            [self.dataSubject2 sendNext:url];
        } else if (model.type == ReturnFailure) {
            [self.dataSubject2 sendNext:model.error];
        } else {
            [self.dataSubject2 sendNext:@"no data"];
        }
    }];
    
    [self.dataCommand3.executionSignals.switchToLatest subscribeNext:^(NetDataReturnModel *model) {
        if (model.type == ReturnSuccess) {
            NSString *url = model.result[@"url"];
            [self.dataSubject3 sendNext:url];
        } else if (model.type == ReturnFailure) {
            [self.dataSubject3 sendNext:model.error];
        } else {
            [self.dataSubject3 sendNext:@"no data"];
        }
    }];
    
    [self.dataCommand4.executionSignals.switchToLatest subscribeNext:^(NetDataReturnModel *model) {
        if (model.type == ReturnSuccess) {
            NSString *url = model.result[@"url"];
            [self.dataSubject4 sendNext:url];
        } else if (model.type == ReturnFailure) {
            [self.dataSubject4 sendNext:model.error];
        } else {
            [self.dataSubject4 sendNext:@"no data"];
        }
    }];
    
    [self.dataCommand5.executionSignals.switchToLatest subscribeNext:^(NetDataReturnModel *model) {
        if (model.type == ReturnSuccess) {
            NSString *url = model.result[@"url"];
            [self.dataSubject5 sendNext:url];
        } else if (model.type == ReturnFailure) {
            [self.dataSubject5 sendNext:model.error];
        } else {
            [self.dataSubject5 sendNext:@"no data"];
        }
    }];
    
    [self.dataCommand6.executionSignals.switchToLatest subscribeNext:^(NetDataReturnModel *model) {
        if (model.type == ReturnSuccess) {
            NSString *url = model.result[@"url"];
            [self.dataSubject6 sendNext:url];
        } else if (model.type == ReturnFailure) {
            [self.dataSubject6 sendNext:model.error];
        } else {
            [self.dataSubject6 sendNext:@"no data"];
        }
    }];
    
    [self.dataCommand7.executionSignals.switchToLatest subscribeNext:^(NetDataReturnModel *model) {
        if (model.type == ReturnSuccess) {
            NSString *url = model.result[@"url"];
            [self.dataSubject7 sendNext:url];
        } else if (model.type == ReturnFailure) {
            [self.dataSubject7 sendNext:model.error];
        } else {
            [self.dataSubject7 sendNext:@"no data"];
        }
    }];
    
    [self.dataCommand8.executionSignals.switchToLatest subscribeNext:^(NetDataReturnModel *model) {
        if (model.type == ReturnSuccess) {
            NSString *url = model.result[@"url"];
            [self.dataSubject8 sendNext:url];
        } else if (model.type == ReturnFailure) {
            [self.dataSubject8 sendNext:model.error];
        } else {
            [self.dataSubject8 sendNext:@"no data"];
        }
    }];
    
}

// 播放和停止视频
- (NSString *) url {
    NSString *ip = [[LoginInfoLocalData sharedInstance] gainIPAddress];
    NSString *url = [NSString stringWithFormat:@"%@/playSend", ip];
    return url;
}

- (NSDictionary *)param:(int)channelID {
    NSString *name = [[LoginInfoLocalData sharedInstance] gainName];
    NSString *pwd = [[LoginInfoLocalData sharedInstance] gainPWD];
    NSString *tradeno = [DateUtil signDate];
    NSString *str = [NSString stringWithFormat:@"%@%@%@", name, pwd, tradeno];
    NSString *sign = [MD5Util md5:str];
    
    NSDictionary *param = @{ @"username" : (name ? name : @""),
                             @"tradeno" : tradeno,
                             @"sign" : sign,
                             @"terminal" : (self.terminal ? self.terminal : @""),
                             @"id" : @(channelID),  // 通道号 1至32
                             @"type" : self.type,   // 0开启 1关闭
                             @"protocol" : @"1",    // 0：RTSP 1: RTMP 2:RTP 3： 其他
                             @"vedioType" : @"0",   // 0：音视频 1视频 2 双向对讲 3 监听 4 中心广播5 透传
                             @"streamType" : @"1"   // 0:主码流 1：子码流
                             };
    return param;
}

- (RACCommand *) dataCommand1 {
    if (!_dataCommand1) {
        _dataCommand1 = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [self.request httpPostRequest:[self url] params:[self param:1] requestModel:nil];
        }];
    }
    
    return _dataCommand1;
}

- (RACCommand *) dataCommand2 {
    if (!_dataCommand2) {
        _dataCommand2 = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [self.request httpPostRequest:[self url] params:[self param:2] requestModel:nil];
        }];
    }
    
    return _dataCommand2;
}

- (RACCommand *) dataCommand3 {
    if (!_dataCommand3) {
        _dataCommand3 = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [self.request httpPostRequest:[self url] params:[self param:3] requestModel:nil];
        }];
    }
    
    return _dataCommand3;
}

- (RACCommand *) dataCommand4 {
    if (!_dataCommand4) {
        _dataCommand4 = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [self.request httpPostRequest:[self url] params:[self param:4] requestModel:nil];
        }];
    }
    
    return _dataCommand4;
}

- (RACCommand *) dataCommand5 {
    if (!_dataCommand5) {
        _dataCommand5 = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [self.request httpPostRequest:[self url] params:[self param:5] requestModel:nil];
        }];
    }
    
    return _dataCommand5;
}

- (RACCommand *) dataCommand6 {
    if (!_dataCommand6) {
        _dataCommand6 = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [self.request httpPostRequest:[self url] params:[self param:6] requestModel:nil];
        }];
    }
    
    return _dataCommand6;
}

- (RACCommand *) dataCommand7 {
    if (!_dataCommand7) {
        _dataCommand7 = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [self.request httpPostRequest:[self url] params:[self param:7] requestModel:nil];
        }];
    }
    
    return _dataCommand7;
}

- (RACCommand *) dataCommand8 {
    if (!_dataCommand8) {
        _dataCommand8 = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [self.request httpPostRequest:[self url] params:[self param:8] requestModel:nil];
        }];
    }
    
    return _dataCommand8;
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

- (RACSubject *) dataSubject5 {
    if (!_dataSubject5) {
        _dataSubject5 = [RACSubject subject];
    }
    
    return _dataSubject5;
}

- (RACSubject *) dataSubject6 {
    if (!_dataSubject6) {
        _dataSubject6 = [RACSubject subject];
    }
    
    return _dataSubject6;
}

- (RACSubject *) dataSubject7 {
    if (!_dataSubject7) {
        _dataSubject7 = [RACSubject subject];
    }
    
    return _dataSubject7;
}

- (RACSubject *) dataSubject8 {
    if (!_dataSubject8) {
        _dataSubject8 = [RACSubject subject];
    }
    
    return _dataSubject8;
}

- (void) setTotalChannels:(int) totalChannels {
    if (totalChannels > 8) {
        totalChannels = 8;
    }
    
    _totalChannels = totalChannels;
}

@end
