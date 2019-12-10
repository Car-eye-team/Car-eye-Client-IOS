//
//  MainViewController.m
//  GBSClientiOS
//
//  Created by asd on 2019/7/19.
//  Copyright © 2019 iOS. All rights reserved.
//

#import "MainViewController.h"
#import <RTRootNavigationController/RTRootNavigationController.h>
#import "MapViewController.h"
#import "VideoViewController.h"
#import "TrackViewController.h"
#import "PlaybackViewController.h"
#import "WarnViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.barTintColor = [UIColor whiteColor];
    
    NSDictionary *normalDict = @{ NSForegroundColorAttributeName:UIColorFromRGB(0x999999) };
    NSDictionary *themeDict = @{ NSForegroundColorAttributeName:UIColorFromRGB(LQThemeColor) };
    
    MapViewController *vc = [[MapViewController alloc] initWithStoryborad];
    vc.tabBarItem.title = @"地图";
    vc.tabBarItem.image = [[UIImage imageNamed:@"ic_local"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_local_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [vc.tabBarItem setTitleTextAttributes:normalDict forState:UIControlStateNormal];
    [vc.tabBarItem setTitleTextAttributes:themeDict forState:UIControlStateSelected];
    
    VideoViewController *vc0 = [[VideoViewController alloc] initWithStoryborad];
    vc0.tabBarItem.title = @"视频";
    vc0.tabBarItem.image = [[UIImage imageNamed:@"ic_live"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc0.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_live_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [vc0.tabBarItem setTitleTextAttributes:normalDict forState:UIControlStateNormal];
    [vc0.tabBarItem setTitleTextAttributes:themeDict forState:UIControlStateSelected];
    
    TrackViewController *vc1 = [[TrackViewController alloc] initWithStoryborad];
    vc1.tabBarItem.title = @"轨迹";
    vc1.tabBarItem.image = [[UIImage imageNamed:@"ic_track"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc1.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_track_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [vc1.tabBarItem setTitleTextAttributes:normalDict forState:UIControlStateNormal];
    [vc1.tabBarItem setTitleTextAttributes:themeDict forState:UIControlStateSelected];
    
    PlaybackViewController *vc2 = [[PlaybackViewController alloc] init];
    vc2.tabBarItem.title = @"回放";
    vc2.tabBarItem.image = [[UIImage imageNamed:@"ic_replay"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc2.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_replay_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [vc2.tabBarItem setTitleTextAttributes:normalDict forState:UIControlStateNormal];
    [vc2.tabBarItem setTitleTextAttributes:themeDict forState:UIControlStateSelected];
    
    WarnViewController *vc3 = [[WarnViewController alloc] init];
    vc3.tabBarItem.title = @"报警";
    vc3.tabBarItem.image = [[UIImage imageNamed:@"ic_warn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc3.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_warn_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [vc3.tabBarItem setTitleTextAttributes:normalDict forState:UIControlStateNormal];
    [vc3.tabBarItem setTitleTextAttributes:themeDict forState:UIControlStateSelected];
    
    self.viewControllers = @[ vc, vc0, vc1, vc2, vc3 ];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - override

- (BOOL)prefersStatusBarHidden {
    return self.selectedViewController.prefersStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return self.selectedViewController.preferredStatusBarUpdateAnimation;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.selectedViewController.preferredStatusBarStyle;
}

@end
