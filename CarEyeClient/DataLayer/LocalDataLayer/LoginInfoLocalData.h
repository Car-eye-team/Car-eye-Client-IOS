//
//  LoginInfoLocalData.h
//  GBSClientiOS
//
//  Created by asd on 2018/5/10.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "BaseLocalData.h"
#import <YYKit/YYKit.h>

/**
 登录信息数据
 */
@interface LoginInfoLocalData : BaseLocalData

@property (nonatomic, retain) YYCache *yyCache;

+ (instancetype) sharedInstance;

// 帐号密码 信息
- (void) saveName:(NSString *)name psw:(NSString *)psw;
- (NSString*) gainName;
- (NSString*) gainPWD;
- (void) clearInfo;// 清除登录信息

- (void) saveIP:(NSString *)v;
- (void) savePort:(NSString *)v;
- (NSString*) gainIP;
- (NSString*) gainPort;
- (NSString*) gainIPAddress;

@end
