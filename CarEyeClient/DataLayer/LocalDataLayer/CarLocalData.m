//
//  LoginInfoLocalData.m
//  GBSClientiOS
//
//  Created by asd on 2018/5/10.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "CarLocalData.h"

static NSString *rateKey = @"rateKey";
static NSString *termKey = @"termKey";

@implementation CarLocalData

#pragma mark - 单例模式

static CarLocalData *instance;

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

- (void) saveRate:(int)rate {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(rate) forKey:rateKey];
    [defaults synchronize];
}

- (int) gainRate {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int rate = [[defaults objectForKey:rateKey] intValue];
    if (rate == 0) {
        rate = 10;
    }
    
    return rate;
}

- (void) saveTerminal:(NSString *)term {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:term forKey:termKey];
    [defaults synchronize];
}

- (NSString *) gainTerminal {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *term = [defaults objectForKey:termKey];
    
    return term;
}

@end
