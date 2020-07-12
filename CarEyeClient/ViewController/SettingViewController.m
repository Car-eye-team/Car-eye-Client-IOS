//
//  SettingViewController.m
//  CarEyeClient
//
//  Created by asd on 2019/10/24.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginInfoLocalData.h"
#import "LoginViewController.h"
#import "LoginInfoLocalData.h"

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UISwitch *codecSwitch;

@end

@implementation SettingViewController

- (instancetype) initWithStoryborad {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.nameLabel.text = [[LoginInfoLocalData sharedInstance] gainName];
}

#pragma mark - LQViewControllerProtocol

- (void)bindViewModel {
    
}

#pragma mark - click

- (IBAction)quit:(id)sender {
    LoginViewController *vc = [[LoginViewController alloc] initWithStoryborad];
    vc.isPresent = YES;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)hwCodec:(id)sender {
    
}

@end
