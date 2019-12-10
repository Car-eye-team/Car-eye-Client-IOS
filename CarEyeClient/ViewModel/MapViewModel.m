//
//  MapViewModel.m
//  CarEyeClient
//
//  Created by liyy on 2019/11/4.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "MapViewModel.h"

@implementation MapViewModel

- (instancetype) init {
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void) liveqing_initialize {
    [self.dataCommand.executionSignals.switchToLatest subscribeNext:^(NetDataReturnModel *model) {
        
    }];
}

- (RACSubject *) dataSubject {
    if (!_dataSubject) {
        _dataSubject = [RACSubject subject];
    }
    
    return _dataSubject;
}

@end
