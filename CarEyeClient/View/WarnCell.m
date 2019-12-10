//
//  WarnCell.m
//  CarEyeClient
//
//  Created by liyy on 2019/12/1.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "WarnCell.h"
#import <YYKit/YYKit.h>
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
#import "UILabel+lineSpace.h"
#import "Masonry.h"

@implementation WarnCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"WarnCell";
    // 1.缓存中
    WarnCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[WarnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/**
 *  构造方法(在初始化对象的时候会调用)
 *  一般在这个方法中添加需要显示的子控件
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _carNumLabel = [[UILabel alloc] init];
        _carNumLabel.textColor = UIColorFromRGB(0x333333);
        _carNumLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_carNumLabel];
        [_carNumLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.right.equalTo(@(-12));
            make.top.equalTo(@12);
        }];
        
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = UIColorFromRGB(0xff0000);
        _descLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:_descLabel];
        [_descLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.carNumLabel);
            make.right.equalTo(self.carNumLabel);
            make.top.equalTo(self.carNumLabel.mas_bottom).offset(12);
        }];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = UIColorFromRGB(0x666666);
        _timeLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_timeLabel];
        [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.carNumLabel);
            make.top.equalTo(self.descLabel.mas_bottom).offset(12);
        }];
        
        UIView *line2 = [[UIView alloc] init];
        line2.backgroundColor = UIColorFromRGB(0xECF0F6);
        [self addSubview:line2];
        [line2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.height.equalTo(@5);
        }];
    }
    
    return self;
}

- (void) setModel:(Alarm *)model carNumber:(NSString *)carNumber {
    _carNumLabel.text = carNumber;
    _descLabel.text = model.alarmDesc;
    _timeLabel.text = model.startTime;
}

- (CGFloat)heightForModel:(Alarm *)model {
    return 110;
}

@end
