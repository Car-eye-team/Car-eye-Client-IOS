//
//  LoginViewModel.h
//  SixDegreeRescue-iOS
//
//  Created by asd on 2018/7/12.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "BaseViewModel.h"

@interface Account : NSObject

@property (nonatomic, copy) NSString *ip;
@property (nonatomic, copy) NSString *port;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pwd;

@end

@interface LoginViewModel : BaseViewModel

@property (nonatomic, strong) Account *account;

@property (nonatomic, strong) RACSubject *loginResultSubject;
@property (nonatomic, strong) RACCommand *loginCommand;

- (NSString *) checkIP;
- (NSString *) checkUser;

@end
