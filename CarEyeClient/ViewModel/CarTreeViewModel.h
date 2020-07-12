//
//  CarTreeViewModel.h
//  CarEyeClient
//
//  Created by asd on 2019/10/27.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "BaseViewModel.h"
#import "DepartmentCar.h"

NS_ASSUME_NONNULL_BEGIN

@interface CarTreeViewModel : BaseViewModel

@property (nonatomic, strong) RACSubject *dataSubject;
@property (nonatomic, strong) RACCommand *dataCommand;

@end

NS_ASSUME_NONNULL_END
