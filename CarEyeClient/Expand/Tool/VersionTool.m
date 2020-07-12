//
//  VersionTool.m
//  SHAREMEDICINE_SHOP_iOS
//
//  Created by asd on 2018/11/19.
//  Copyright © 2018 car. All rights reserved.
//

#import "VersionTool.h"

@implementation VersionTool

#pragma mark - 单例模式

static VersionTool *instance;

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

#pragma mark - public method

- (NSString *) getVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (BOOL) isLastVersionWithNetVersion:(NSString *)netVersion {
    NSString *version = [self getVersion];
    int result = [self isCurrentVersion:version largerThanVersion:netVersion];
    
    if (result == 2) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL) isLargeVersionWithLocalVersion:(NSString *)localVersion {
    NSString *version = [self getVersion];
    int result = [self isCurrentVersion:version largerThanVersion:localVersion];
    
    if (result == 1) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - private method

/**
 版本比较

 @param currentVersion 当前版本
 @param compareVersion 比较版本
 @return 0:相等
         1:大于
         2:小于
 */
- (int) isCurrentVersion:(NSString *)currentVersion largerThanVersion:(NSString *)compareVersion {
    NSMutableArray *currentArray = [NSMutableArray arrayWithArray:[currentVersion componentsSeparatedByString:@"."]];
    NSMutableArray *compareArray = [NSMutableArray arrayWithArray:[compareVersion componentsSeparatedByString:@"."]];
    
    // 当前版本为空
    if (!currentArray) {
        return NO;
    }
    
    // 比较版本为空
    if (!compareArray) {
        return YES;
    }
    
    if (currentArray.count > compareArray.count) {
        for (int i = 0; (currentArray.count-compareArray.count); i++) {
            [compareArray addObject:@"0"];
        }
    }
    
    if (currentArray.count < compareArray.count) {
        for (int i = 0; (compareArray.count-currentArray.count); i++) {
            [currentArray addObject:@"0"];
        }
    }
    
    int result = 0;
    for (int i = 0; i < currentArray.count; i++) {
        int current = [currentArray[i] intValue];
        int compare = [compareArray[i] intValue];
        
        // 只要当前版本号大,就不比较了
        if (current < compare) {
            result = 2;
            break;
        }
        
        // 只要当前版本号小,就不比较了
        if (current > compare) {
            result = 1;
            break;
        }
    }
    
    return result;
}

@end
