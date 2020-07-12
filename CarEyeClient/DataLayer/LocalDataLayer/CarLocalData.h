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
@interface CarLocalData : BaseLocalData

@property (nonatomic, retain) YYCache *yyCache;

+ (instancetype) sharedInstance;

- (void) saveRate:(int)rate;
- (int) gainRate;

- (void) saveTerminal:(NSString *)term;
- (NSString *) gainTerminal;

- (void) saveChannel:(int)num;
- (int) gainChannel;

@end
