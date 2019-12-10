//
//  BaseView.h
//  SixDegreeRescue-iOS
//
//  Created by asd on 2018/5/10.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "YYKit.h"
#import "ViewModelProtocol.h"

@protocol LQViewProtocol <NSObject>

@optional

- (instancetype)initWithViewModel:(id <ViewModelProtocol>)viewModel;
- (void)view_bindViewModel;

@end

/**
 View的基类
 */
@interface BaseView : UIView<LQViewProtocol>

- (void) showHub;
- (void) showHubWithLoadText:(NSString *) text;
- (void) showTextHubWithContent:(NSString *) content;
- (void) hideHub;

@end
