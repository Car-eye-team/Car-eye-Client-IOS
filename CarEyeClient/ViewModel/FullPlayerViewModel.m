//
//  FullPlayerViewModel.m
//  CarEyeClient
//
//  Created by liyy on 2019/11/7.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "FullPlayerViewModel.h"

@implementation FullPlayerViewModel

- (instancetype) init {
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void) liveqing_initialize {
    [self.dataCommand.executionSignals.switchToLatest subscribeNext:^(NetDataReturnModel *model) {
        if (model.type == ReturnSuccess) {
            self.playUrl = model.result[@"url"];
            NSLog(@"%@", model.result);
            
            [self.dataSubject sendNext:nil];
        } else if (model.type == ReturnFailure) {
            [self.dataSubject sendNext:model.error];
        } else {
            [self.dataSubject sendNext:@"no data"];
        }
    }];
}

// 远程录像回放
- (RACCommand *) dataCommand {
    if (!_dataCommand) {
        _dataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            NSString *ip = [[LoginInfoLocalData sharedInstance] gainIPAddress];
            NSString *url = [NSString stringWithFormat:@"%@/playbackAppoint", ip];
            
            NSString *name = [[LoginInfoLocalData sharedInstance] gainName];
            NSString *pwd = [[LoginInfoLocalData sharedInstance] gainPWD];
            NSString *tradeno = [DateUtil signDate];
            NSString *str = [NSString stringWithFormat:@"%@%@%@", name, pwd, tradeno];
            NSString *sign = [MD5Util md5:str];
            
            NSDictionary *param = @{ @"tradeno" : tradeno,
                                     @"username" : (name ? name : @""),
                                     @"sign" : sign,
                                     @"terminal" : self.terminal,
                                     @"startTime" : [self.file startTime2],
                                     @"endTime" : [self.file endTime2],
                                     @"id" : self.file.logicChannel,
                                     @"streamType" : @"0",  //0:主码流 1：子码流
                                     @"vedioType" : @"0",   // 0：音视频 1视频 2 双向对讲 3 监听 4 中心广播 5 透传
                                     @"memoryType" : @"0",  // 0：所有存储器 1：主存储器 2：灾备服务器
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
