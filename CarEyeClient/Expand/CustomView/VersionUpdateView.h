//
//  VersionUpdateView.h
//  car
//
//  Created by asd on 2018/11/19.
//  Copyright © 2018 car. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickListener)(void);

/**
 版本更新View
 */
@interface VersionUpdateView : UIView<CAAnimationDelegate>

@property (nonatomic, retain) UIView *bgView;
@property (nonatomic, retain) UILabel *updateContentLabel;

@property (nonatomic, strong) ClickListener updateVersionListener;

- (void) showView:(UIView *)view;
- (void) hideView;

- (void) setContent:(NSString *) content;

@end
