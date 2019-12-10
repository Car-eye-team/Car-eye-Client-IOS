//
//  NetDataReturnModel.m
//  GBSClientiOS
//
//  Created by asd on 2018/6/8.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "NetDataReturnModel.h"

@implementation NetDataReturnModel

- (NSString *) error {
    if (!_error) {
        return @"";
    }
    
    return _error;
}

@end
