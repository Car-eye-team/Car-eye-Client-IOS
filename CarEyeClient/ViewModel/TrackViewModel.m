//
//  PlaybackViewModel.m
//  CarEyeClient
//
//  Created by liyy on 2019/11/5.
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

- (RACSubject *) dataSubject {
    if (!_dataSubject) {
        _dataSubject = [RACSubject subject];
    }
    
    return _dataSubject;
}

@end
