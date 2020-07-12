//
//  VideoViewModel.h
//  CarEyeClient
//
//  Created by asd on 2019/11/9.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "BaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoViewModel : BaseViewModel

@property (nonatomic, copy) NSString *terminal;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, assign) int totalChannels;

@property (nonatomic, strong) NSArray *dataCommands;

@property (nonatomic, strong) RACSubject *dataSubject1;
@property (nonatomic, strong) RACCommand *dataCommand1;
@property (nonatomic, strong) RACSubject *dataSubject2;
@property (nonatomic, strong) RACCommand *dataCommand2;
@property (nonatomic, strong) RACSubject *dataSubject3;
@property (nonatomic, strong) RACCommand *dataCommand3;
@property (nonatomic, strong) RACSubject *dataSubject4;
@property (nonatomic, strong) RACCommand *dataCommand4;
@property (nonatomic, strong) RACSubject *dataSubject5;
@property (nonatomic, strong) RACCommand *dataCommand5;
@property (nonatomic, strong) RACSubject *dataSubject6;
@property (nonatomic, strong) RACCommand *dataCommand6;
@property (nonatomic, strong) RACSubject *dataSubject7;
@property (nonatomic, strong) RACCommand *dataCommand7;
@property (nonatomic, strong) RACSubject *dataSubject8;
@property (nonatomic, strong) RACCommand *dataCommand8;

@end

NS_ASSUME_NONNULL_END
