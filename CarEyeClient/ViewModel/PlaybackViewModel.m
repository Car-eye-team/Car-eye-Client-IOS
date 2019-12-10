//
//  PlaybackViewModel.m
//  CarEyeClient
//
//  Created by liyy on 2019/11/5.
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
            
            [self.dataSubject sendNext:nil];
        } else if (model.type == ReturnFailure) {
            [self.dataSubject sendNext:model.error];
        } else {
            [self.dataSubject sendNext:@"no data"];
        }
    }];
}

- (RACSubject *) dataSubject {
    if (!_dataSubject) {
        _dataSubject = [RACSubject subject];
    }
    
    return _dataSubject;
}

@end
