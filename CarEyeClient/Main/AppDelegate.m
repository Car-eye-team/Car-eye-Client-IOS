//
//  AppDelegate.m
//  SixDegreeRescue-iOS
//
//  Created by asd on 2018/7/12.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "AppDelegate.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <Bugly/Bugly.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <CoreTelephony/CTCellularData.h>
#import <AFNetworking.h>

#import "LoginViewController.h"
#import "MainViewController.h"
#import "LoginInfoLocalData.h"
#import "NetWorkUtil.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (instancetype) sharedDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    //1.获取网络权限 根绝权限进行人机交互
//    if (__IPHONE_10_0) {
//        [self networkStatus:application didFinishLaunchingWithOptions:launchOptions];
//    } else {
//        //2.2已经开启网络权限 监听网络状态
//        [self addReachabilityManager:application didFinishLaunchingWithOptions:launchOptions];
//    }
    
    // 要使用百度地图，请先启动BaiduMapManager
    BMKMapManager *mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [mapManager start:BAIDU_KEY  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    // Bugly
    [Bugly startWithAppId:@"38fd960a00"];
    
    // IQKeyboardManager
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES; // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    keyboardManager.toolbarDoneBarButtonItemText = @"完成";
    keyboardManager.shouldShowToolbarPlaceholder = YES; // 是否显示占位文字
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
    
    // 1.获取网络权限 根绝权限进行人机交互
    [NetWorkUtil checkNetWork];
    
    // UI逻辑
    CGRect frame = CGRectMake(0, 0, LQScreenWidth, LQScreenHeight);
    self.window = [[UIWindow alloc] initWithFrame:frame];
    self.window.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.window makeKeyAndVisible];
    
    // 设置UI
    self.rootVC = [[RTRootNavigationController alloc] init];
    
    NSString *name = [[LoginInfoLocalData sharedInstance] gainName];
    name = (name == nil ? @"" : name);
    NSString *pwd = [[LoginInfoLocalData sharedInstance] gainPWD];
    pwd = (pwd == nil ? @"" : pwd);
    
    MainViewController *vc = [[MainViewController alloc] init];
    
    if (![name isEqualToString:@""] && ![pwd isEqualToString:@""]) {
        [self.rootVC setViewControllers:@[ vc ]];
    } else {
        LoginViewController *loginVC = [[LoginViewController alloc] initWithStoryborad];
        [self.rootVC setViewControllers:@[ vc, loginVC ]];
    }
    
    self.window.rootViewController = self.rootVC;
    
    return YES;
}

/*
 CTCellularData在iOS9之前是私有类，权限设置是iOS10开始的，所以App Store审核没有问题
 获取网络权限状态
 */
- (void)networkStatus:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //2.根据权限执行相应的交互
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    
    /*
     此函数会在网络权限改变时再次调用
     */
    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
        switch (state) {
            case kCTCellularDataRestricted:
                
                NSLog(@"Restricted");
                //2.1权限关闭的情况下 再次请求网络数据会弹出设置网络提示
//                [self getAppInfo];
                break;
            case kCTCellularDataNotRestricted:
                
                NSLog(@"NotRestricted");
                //2.2已经开启网络权限 监听网络状态
                [self addReachabilityManager:application didFinishLaunchingWithOptions:launchOptions];
                //                [self getInfo_application:application didFinishLaunchingWithOptions:launchOptions];
                break;
            case kCTCellularDataRestrictedStateUnknown:
                
                NSLog(@"Unknown");
                //2.3未知情况 （还没有遇到推测是有网络但是连接不正常的情况下）
//                [self getAppInfo];
                break;
                
            default:
                break;
        }
    };
}

/**
 实时检查当前网络状态
 */
- (void)addReachabilityManager:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    
    //这个可以放在需要侦听的页面
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(afNetworkStatusChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"网络不通：%@",@(status) );
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                NSLog(@"网络通过WIFI连接：%@",@(status));
//                if (self.mallConfigModel == nil) {
//                    [self getInfo_application:application didFinishLaunchingWithOptions:launchOptions];
//                }
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                NSLog(@"网络通过无线连接：%@",@(status) );
//                if (self.mallConfigModel == nil) {
//                    [self getInfo_application:application didFinishLaunchingWithOptions:launchOptions];
//                }
                break;
            }
            default:
                break;
        }
    }];
    
    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
}

@end
