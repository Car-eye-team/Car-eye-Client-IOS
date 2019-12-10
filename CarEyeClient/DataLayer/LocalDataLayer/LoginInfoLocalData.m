//
//  LoginInfoLocalData.m
//  GBSClientiOS
//
//  Created by asd on 2018/5/10.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "LoginInfoLocalData.h"

static NSString *ipKey = @"ipKey";
static NSString *portKey = @"portKey";
static NSString *accountKey = @"accountKey";
static NSString *passwordKey = @"passwordKey";

@implementation LoginInfoLocalData

#pragma mark - 单例模式

static LoginInfoLocalData *instance;

+ (id) allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

+ (instancetype) sharedInstance {
    static dispatch_once_t oncetToken;
    dispatch_once(&oncetToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (id) copyWithZone:(NSZone *)zone {
    return instance;
}

- (instancetype) init {
    if (self = [super init]) {
        _yyCache = [YYCache cacheWithName:LoginInfoDataCache];
    }
    return self;
}

#pragma mark - 帐号密码 信息

- (void) saveName:(NSString *)name psw:(NSString *)psw {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:name forKey:accountKey];
    [defaults setObject:psw forKey:passwordKey];
    
    [defaults synchronize];
}

- (NSString *) gainName {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *account = [defaults objectForKey:accountKey];
    
    return account;
}

- (NSString *) gainPWD {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *pwd = [defaults objectForKey:passwordKey];
    
    return pwd;
}

// 清除登录信息
- (void) clearInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:passwordKey];
    [defaults synchronize];
}

- (void) saveIP:(NSString *)v {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:v forKey:ipKey];
    
    [defaults synchronize];
}

- (void) savePort:(NSString *)v {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:v forKey:portKey];
    
    [defaults synchronize];
}

- (NSString*) gainIPAddress {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *ip = [defaults objectForKey:ipKey];
    NSString *port = [defaults objectForKey:portKey];
    
    if (ip == NULL || [ip isEqualToString:@""]) {
        return [NSString stringWithFormat:@"http://www.liveoss.com:%@/cmsapi", port];
    } else if ([ip hasSuffix:@"http"] || [ip hasSuffix:@"https"]) {
        return [NSString stringWithFormat:@"%@:%@/cmsapi", ip, port];
    } else {
        return [NSString stringWithFormat:@"http://%@:%@/cmsapi", ip, port];
    }
}

- (NSString *) gainIP {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *ip = [defaults objectForKey:ipKey];
    
    return ip;
}

- (NSString *) gainPort {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *port = [defaults objectForKey:portKey];
    
    return port;
}

@end
