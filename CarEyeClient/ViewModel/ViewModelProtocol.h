//
//  ViewModelProtocol.h
//  SixDegreeRescue-iOS
//
//  Created by asd on 2018/6/7.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseNetDataRequest.h"

@protocol ViewModelProtocol <NSObject>

@optional

- (instancetype)initWithModel:(id)model;

/**
 *  初始化
 */
- (void)liveqing_initialize;

@end
