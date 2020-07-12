//
//  CustomPaopaoView.m
//  CarEyeClient
//
//  Created by asd on 2019/11/8.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "CustomPaopaoView.h"
#import "Masonry.h"
#import "DateUtil.h"

@interface CustomPaopaoView ()

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UILabel *label;

@end

@implementation CustomPaopaoView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initSubViews];
    }
    
    return self;
}

- (void)initSubViews {
    UIImageView *iv = [[UIImageView alloc] init];
    iv.image = [UIImage imageNamed:@"jiantou"];
    [self addSubview:iv];
    [iv makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(@0);
    }];
    
    _view = [[UIView alloc] init];
    _view.backgroundColor = UIColorFromRGB(0x8a8a8a);
    LQViewBorderRadius(_view, 3, 0, [UIColor clearColor]);
    [self addSubview:_view];
    [_view makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(@0);
        make.bottom.equalTo(iv.mas_top).offset(2);
    }];
    
    _label = [[UILabel alloc] init];
    _label.numberOfLines = 0;
    _label.textColor = [UIColor whiteColor];
    _label.font = [UIFont systemFontOfSize:15];
    [_view addSubview:_label];
    [_label makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@5);
        make.right.bottom.equalTo(@(-5));
    }];
}

- (void) setModel:(CarInfoGPS *)model {
    NSString *text = [NSString stringWithFormat:@"%@\n经度：%.6f 纬度：%.6f\n方向：%@\n速度：%@千米/小时\n地址：%@\n更新时间：%@",
                      model.carnumber,
                      [model bLongitude],
                      [model bLatitude],
                      [model parseDirection:model.direction],
                      model.speed,
                      model.address,
                      [model gpstimeDesc]
                      ];
    
    _label.text = text;
}

@end
