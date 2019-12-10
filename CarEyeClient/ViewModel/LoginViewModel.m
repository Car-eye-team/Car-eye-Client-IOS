//
//  LoginViewModel.m
//  SixDegreeRescue-iOS
//
//  Created by asd on 2018/7/12.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "LoginViewModel.h"

@implementation Account

@end

@implementation LoginViewModel

- (void) liveqing_initialize {
    [self.loginCommand.executionSignals.switchToLatest subscribeNext:^(NetDataReturnModel *model) {
        if (model.type == ReturnSuccess) {
            
            // 保存帐号信息
            [[LoginInfoLocalData sharedInstance] saveName:self.account.name psw:self.account.pwd];
            
            [self.loginResultSubject sendNext:nil];
        } else if (model.type == ReturnFailure) {
            [self.loginResultSubject sendNext:model.error];
        } else {
            [self.loginResultSubject sendNext:@"账户名或密码错误"];
        }
    }];
}

- (NSString *) checkIP {
    if ([self.account.ip isEqualToString:@""]) {
        return @"请输入ip";
    }
    
    if ([self.account.port isEqualToString:@""]) {
        return @"请输入端口";
    }
    
    [[LoginInfoLocalData sharedInstance] saveIP:self.account.ip];
    [[LoginInfoLocalData sharedInstance] savePort:self.account.port];
    
    return nil;
}

- (NSString *) checkUser {
    NSString *res = [self checkIP];
    if (res) {
        return res;
    }
    
    if ([self.account.name isEqualToString:@""]) {
        return @"请输入用户名";
    } else if ([self.account.pwd isEqualToString:@""]) {
        return @"请输入密码";
    }
    
    return nil;
}

#pragma mark - getter

- (RACSubject *) loginResultSubject {
    if (!_loginResultSubject) {
        _loginResultSubject = [[RACSubject alloc] init];
    }
    
    return _loginResultSubject;
}

- (Account *)account {
    if (_account == nil) {
        _account = [[Account alloc] init];
    }
    return _account;
}

- (RACCommand *) loginCommand {
    if (!_loginCommand) {
        _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            NSString *ip = [[LoginInfoLocalData sharedInstance] gainIPAddress];
            NSString *url = [NSString stringWithFormat:@"%@/userLogin", ip];
            
            NSString *tradeno = [DateUtil signDate];
            NSString *str = [NSString stringWithFormat:@"%@%@%@", self.account.name, self.account.pwd, tradeno];
            NSString *sign = [MD5Util md5:str];
            
            NSDictionary *param = @{ @"username" : self.account.name,
                                     @"password" : self.account.pwd,
                                     @"tradeno" : tradeno,
                                     @"sign" : sign
                                     };
            
            return [self.request httpPostRequest:url params:param requestModel:nil];
        }];
    }
    
    return _loginCommand;
}

@end
