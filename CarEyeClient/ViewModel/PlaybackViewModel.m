//
//  PlaybackViewModel.m
//  CarEyeClient
//
//  Created by asd on 2019/11/5.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "PlaybackViewModel.h"
#import "TerminalFile.h"

@implementation PlaybackViewModel

- (instancetype) init {
    if (self = [super init]) {
        self.data = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) liveqing_initialize {
    [self.dataCommand.executionSignals.switchToLatest subscribeNext:^(NetDataReturnModel *model) {
        if (model.type == ReturnSuccess) {
            NSArray *res = [TerminalFile convertFromArray:model.result];
            [self.data addObjectsFromArray:res];
            
            if (self.param.channel == 0) {
                int max = self.param.car.channeltotals + 1;
                if (self.channelID < max) {
                    self.channelID++;
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.dataCommand execute:nil];
                    });
                }
            }
            
            [self.dataSubject sendNext:nil];
        } else if (model.type == ReturnFailure) {
            [self.dataSubject sendNext:model.error];
        } else {
            [self.dataSubject sendNext:@"no data"];
        }
    }];
}

// 查询设备历史录像列表
- (RACCommand *) dataCommand {
    if (!_dataCommand) {
        _dataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            NSString *ip = [[LoginInfoLocalData sharedInstance] gainIPAddress];
            NSString *url = [NSString stringWithFormat:@"%@/queryTerminalFileList", ip];
            
            NSString *name = [[LoginInfoLocalData sharedInstance] gainName];
            NSString *pwd = [[LoginInfoLocalData sharedInstance] gainPWD];
            NSString *tradeno = [DateUtil signDate];
            NSString *str = [NSString stringWithFormat:@"%@%@%@", name, pwd, tradeno];
            NSString *sign = [MD5Util md5:str];
            
            NSDictionary *param = @{ @"tradeno" : tradeno,
                                     @"username" : (name ? name : @""),
                                     @"sign" : sign,
                                     @"terminal" : self.param.car.terminal,
                                     @"startTime" : self.param.begTime,
                                     @"endTime" : self.param.endTime,
                                     @"id" : @(self.channelID),// 1 通道一 2 通道二 3 通道三 4 通道四
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
