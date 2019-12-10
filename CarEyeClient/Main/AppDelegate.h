//
//  AppDelegate.h
//  SixDegreeRescue-iOS
//
//  Created by asd on 2018/7/12.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RTRootNavigationController/RTRootNavigationController.h>
#import "DepartmentCar.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) NSMutableArray *allCars;
@property (nonatomic, strong) NSMutableArray *onlineCars;
@property (nonatomic, strong) DepartmentCar *car;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) RTRootNavigationController *rootVC;

+ (instancetype) sharedDelegate;

@end
