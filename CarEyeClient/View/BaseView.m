//
//  BaseView.m
//  SixDegreeRescue-iOS
//
//  Created by asd on 2018/5/10.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "BaseView.h"
#import "MBProgressHUDTool.h"

@interface BaseView()

@property (nonatomic, retain) MBProgressHUDTool *progressHUD;

@end

@implementation BaseView

- (instancetype)initWithViewModel:(id <ViewModelProtocol>)viewModel {
    if (self = [self init]) {
        self.backgroundColor = UIColorFromRGB(LQBackGroundColor);
    }
    
    return self;
}

- (void) view_bindViewModel {
    
}

#pragma mark - MBProgressHUD

- (void) showHubWithLoadText:(NSString *) text {
    [self.progressHUD showHubWithLoadText:text superView:self];
}

- (void) showHub {
    [self.progressHUD showHubWithLoadText:@"查询中..." superView:self];
}

- (void) hideHub {
    [self.progressHUD hideHub];
}

- (void) showTextHubWithContent:(NSString *) content {
    [self.progressHUD showTextHubWithContent:content];
}

- (MBProgressHUDTool *)progressHUD {
    if (!_progressHUD) {
        _progressHUD = [[MBProgressHUDTool alloc] init];
    }
    
    return _progressHUD;
}

@end
