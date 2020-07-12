
//
//  LoginViewController.m
//  GBSClientiOS
//
//  Created by asd on 2018/7/12.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewModel.h"
#import "LoginInfoLocalData.h"

@interface LoginViewController()

@property (weak, nonatomic) IBOutlet UIView *ipView;
@property (weak, nonatomic) IBOutlet UIView *portView;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *pwdView;

@property (weak, nonatomic) IBOutlet UITextField *ipTv;
@property (weak, nonatomic) IBOutlet UITextField *portTv;
@property (weak, nonatomic) IBOutlet UITextField *nameTv;
@property (weak, nonatomic) IBOutlet UITextField *pwdTv;
@property (weak, nonatomic) IBOutlet UIButton *nickLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic, strong) LoginViewModel *viewModel;

@end

@implementation LoginViewController

- (instancetype) initWithStoryborad {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
}

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    LQViewBorderRadius(self.nickLoginBtn, 4, 0, [UIColor clearColor]);
    LQViewBorderRadius(self.loginBtn, 4, 0, [UIColor clearColor]);
    LQViewBorderRadius(self.ipView, 6.0, 1, UIColorFromRGB(LQThemeColor));
    LQViewBorderRadius(self.portView, 6.0, 1, UIColorFromRGB(LQThemeColor));
    LQViewBorderRadius(self.nameView, 6.0, 1, UIColorFromRGB(LQThemeColor));
    LQViewBorderRadius(self.pwdView, 6.0, 1, UIColorFromRGB(LQThemeColor));
    
    NSString *name = [[LoginInfoLocalData sharedInstance] gainName];
    NSString *pwd = [[LoginInfoLocalData sharedInstance] gainPWD];
    NSString *ip = [[LoginInfoLocalData sharedInstance] gainIP];
    NSString *port = [[LoginInfoLocalData sharedInstance] gainPort];
    
    if (name && ![name isEqualToString:@""]) {
        self.nameTv.text = name;
    } else {
        self.nameTv.text = @"admin";
    }
    
    if (pwd && ![pwd isEqualToString:@""]) {
        self.pwdTv.text = pwd;
    } else {
        self.pwdTv.text = @"careyeadmin";
    }
    
    if (ip && ![ip isEqualToString:@""]) {
        self.ipTv.text = ip;
    } else {
        self.ipTv.text = @"www.liveoss.com";
//        self.ipTv.text = @"39.108.229.40";
    }
    
    if (port && ![port isEqualToString:@""]) {
        self.portTv.text = port;
    } else {
        self.portTv.text = @"8088";
//        self.portTv.text = @"8902";
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - StatusBar

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - LQViewControllerProtocol

- (void)bindViewModel {
    RAC(self.viewModel.account, ip) = self.ipTv.rac_textSignal;
    RAC(self.viewModel.account, name) = self.nameTv.rac_textSignal;
    RAC(self.viewModel.account, pwd) = self.pwdTv.rac_textSignal;
    RAC(self.viewModel.account, port) = self.portTv.rac_textSignal;
    
    [self.viewModel.loginResultSubject subscribeNext:^(id x) {
        [self hideHub];
        
        if (x) {
            // 登录失败
            [self showTextHubWithContent:x];
        } else {
            [self.loginSuccessSubject sendNext:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
            
            if (self.isPresent) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}

#pragma mark - click listener

// 登录
- (IBAction)login:(id)sender {
    [self resign];
    
    NSString *res = [self.viewModel checkUser];
    if (res) {
        [self showTextHubWithContent:res];
        return;
    }
    
    [self showHubWithLoadText:@"登录中"];
    [self.viewModel.loginCommand execute:nil];
}

- (void) resign {
    [self.ipTv resignFirstResponder];
    [self.nameTv resignFirstResponder];
    [self.pwdTv resignFirstResponder];
}

#pragma mark - getter

- (RACSubject *) loginSuccessSubject {
    if (!_loginSuccessSubject) {
        _loginSuccessSubject = [[RACSubject alloc] init];
    }
    
    return _loginSuccessSubject;
}

- (LoginViewModel *) viewModel {
    if (!_viewModel) {
        _viewModel = [[LoginViewModel alloc] init];
    }
    
    return _viewModel;
}

@end
