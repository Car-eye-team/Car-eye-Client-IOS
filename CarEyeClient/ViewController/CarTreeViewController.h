//
//  CarTreeViewController.h
//  CarEyeClient
//
//  Created by asd on 2019/10/24.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CarTreeViewController : BaseViewController

@property (nonatomic, strong) RACSubject *subject;

- (instancetype) initWithStoryborad;

@end

NS_ASSUME_NONNULL_END
