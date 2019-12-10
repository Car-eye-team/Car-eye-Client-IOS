//
//  VideoViewModel.h
//  CarEyeClient
//
//  Created by liyy on 2019/11/9.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "BaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoViewModel : BaseViewModel

@property (nonatomic, copy) NSString *terminal;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) RACSubject *dataSubject1;
@property (nonatomic, strong) RACSubject *dataSubject2;
@property (nonatomic, strong) RACSubject *dataSubject3;
@property (nonatomic, strong) RACSubject *dataSubject4;
@property (nonatomic, strong) RACCommand *dataCommand1;
@property (nonatomic, strong) RACCommand *dataCommand2;
@property (nonatomic, strong) RACCommand *dataCommand3;
@property (nonatomic, strong) RACCommand *dataCommand4;

@end

NS_ASSUME_NONNULL_END
