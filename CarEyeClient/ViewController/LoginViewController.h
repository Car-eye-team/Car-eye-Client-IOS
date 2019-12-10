//
//  LoginViewController.h
//  GBSClientiOS
//
//  Created by asd on 2018/7/12.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "BaseViewController.h"

/**
 登录页
 */
@interface LoginViewController : BaseViewController

@property (nonatomic, strong) RACSubject *loginSuccessSubject;
@property (nonatomic, assign) BOOL isPresent;

- (instancetype) initWithStoryborad;

@end
