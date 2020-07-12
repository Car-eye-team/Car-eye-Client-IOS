//
//  MapViewModel.h
//  CarEyeClient
//
//  Created by asd on 2019/11/4.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "BaseViewModel.h"
#import "CarInfoGPS.h"

NS_ASSUME_NONNULL_BEGIN

@interface MapViewModel : BaseViewModel

@property (nonatomic, copy) NSString *terminal;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) CarInfoGPS *model;

@property (nonatomic, strong) RACSubject *dataSubject;
@property (nonatomic, strong) RACCommand *dataCommand;

@property (nonatomic, copy) NSString *versionURL;
@property (nonatomic, copy) NSString *appStoreURL;

@property (nonatomic, strong) RACCommand *versionCommand;
@property (nonatomic, strong) RACSubject *updateVersionSubject;

@end

NS_ASSUME_NONNULL_END
