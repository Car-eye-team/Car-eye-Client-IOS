//
//  PlaybackViewModel.h
//  CarEyeClient
//
//  Created by asd on 2019/11/5.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "BaseViewModel.h"
#import "SearchParam.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrackViewModel : BaseViewModel

@property (nonatomic, strong) SearchParam *param;

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) RACSubject *dataSubject;
@property (nonatomic, strong) RACCommand *dataCommand;

@end

NS_ASSUME_NONNULL_END
