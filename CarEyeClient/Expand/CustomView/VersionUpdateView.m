//
//  VersionUpdateView.m
//  car
//
//  Created by asd on 2018/11/19.
//  Copyright © 2018 car. All rights reserved.
//

#import "VersionUpdateView.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
#import "Masonry.h"

@implementation VersionUpdateView

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.4);
        
        [self addItemView];
    }
    
    return self;
}

- (void) addItemView {
    UIImage * image = [UIImage imageNamed:@"update_bg"];
    
    CGFloat w = LQScreenWidth - 80;
    CGFloat h = w * 476 / 300;
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(w));
        make.height.equalTo(@(h));
    }];
    
    UIImageView *bgIV = [[UIImageView alloc] initWithImage:image];
    [_bgView addSubview:bgIV];
    [bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.width.equalTo(@50);
        make.height.equalTo(@56);
    }];
    
    UIButton *updateBtn = [[UIButton alloc] init];
    [updateBtn addTarget:self action:@selector(updateVersion) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:updateBtn];
    [updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-16));
        make.centerX.equalTo(self.bgView.mas_centerX);
        make.width.equalTo(@150);
        make.height.equalTo(@40);
    }];
    
    self.updateContentLabel = [[UILabel alloc] init];
    self.updateContentLabel.font = [UIFont systemFontOfSize:12.0f];
    self.updateContentLabel.textColor = UIColorFromRGB(0x555555);
    self.updateContentLabel.numberOfLines = 0;
    [self.bgView addSubview:self.updateContentLabel];
    [self.updateContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(w * (84.0 / 562.0)));
        make.right.equalTo(@(-(w * (84.0 / 562.0))));
        make.top.equalTo(@(h * (508.0 / 897.0)));
        make.bottom.equalTo(@(-(h * (170.0 / 897.0))));
    }];
}

- (void) updateVersion {
    if (self.updateVersionListener) {
        [self hideView];
        self.updateVersionListener();
    }
}

- (void) setContent:(NSString *) content {
    if (!content || [content isEqualToString:@""]) {
        content = @"1、更新app";
    }
    
    self.updateContentLabel.text = content;
    [UILabel changeLineSpaceForLabel:self.updateContentLabel WithSpace:2];
}

- (void) showView:(UIView *)view {
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    [self showAnimation:view];
}

- (void) hideView {
    [self hideAnimation];
}

#pragma mark - 动画

- (void) hideAnimation {
    if (self.bgView.isHidden) {
        return;
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画选项的设定
    animation.duration = 0.2; // 持续时间
    animation.delegate = self;
    
    // 起始帧和终了帧的设定
    animation.fromValue = [NSValue valueWithCGPoint:self.bgView.center];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bgView.center.x, self.bgView.center.y + LQScreenHeight)];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    // 添加动画
    [self.bgView.layer removeAllAnimations];
    [self.bgView.layer addAnimation:animation forKey:@"hide-layer"];
}

- (void) showAnimation:(UIView *)view {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画选项的设定
    animation.duration = 0.25;
    animation.delegate = self;
    
    // 起始帧和终了帧的设定
    CGPoint center = view.center;
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(center.x, center.y + LQScreenHeight / 2)];
    animation.toValue = [NSValue valueWithCGPoint:center];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    // 添加动画
    [self.bgView.layer removeAllAnimations];
    [self.bgView.layer addAnimation:animation forKey:@"show-layer"];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (anim.duration == 0.2) {
        [self removeFromSuperview];
    }
}

@end
