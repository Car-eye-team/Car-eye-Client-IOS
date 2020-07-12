//
//  WarnDetailViewController.h
//  CarEyeClient
//
//  Created by asd on 2019/12/8.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "BaseViewController.h"
#import "Alarm.h"

NS_ASSUME_NONNULL_BEGIN

@interface WarnDetailViewController : BaseViewController

@property (nonatomic, strong) Alarm *alarm;
@property (nonatomic, copy) NSString *nodeName;     // 车牌号/机构名称

- (instancetype) initWithStoryborad;

@end

NS_ASSUME_NONNULL_END
