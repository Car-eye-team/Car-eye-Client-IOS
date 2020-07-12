//
//  PlaybackCell.m
//  CarEyeClient
//
//  Created by asd on 2019/11/6.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "PlaybackCell.h"
#import <YYKit/YYKit.h>
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
#import "UILabel+lineSpace.h"
#import "Masonry.h"

@implementation PlaybackCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"PlaybackCell";
    // 1.缓存中
    PlaybackCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[PlaybackCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/**
 *  构造方法(在初始化对象的时候会调用)
 *  一般在这个方法中添加需要显示的子控件
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *iv = [[UIImageView alloc] init];
        iv.image = [UIImage imageNamed:@"file_default"];
        iv.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:iv];
        [iv makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@8);
            make.centerY.equalTo(self);
            make.height.equalTo(@68);
            make.width.equalTo(@110);
        }];
        
        UIImageView *iv1 = [[UIImageView alloc] init];
        iv1.image = [UIImage imageNamed:@"ic_play"];
        iv1.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:iv1];
        [iv1 makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-8));
            make.centerY.equalTo(self);
            make.height.width.equalTo(@24);
        }];
        
        _startLabel = [[UILabel alloc] init];
        _startLabel.textColor = UIColorFromRGB(0xFF07F707);
        _startLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_startLabel];
        [_startLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iv.mas_right).offset(8);
            make.top.equalTo(@10);
        }];
        
        _endLabel = [[UILabel alloc] init];
        _endLabel.textColor = UIColorFromRGB(0xFF07F707);
        _endLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_endLabel];
        [_endLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iv.mas_right).offset(8);
            make.bottom.equalTo(@(-10));
        }];
        
        _channelLabel = [[UILabel alloc] init];
        _channelLabel.textColor = UIColorFromRGB(0x333333);
        _channelLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_channelLabel];
        [_channelLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(iv1.mas_left).offset(-4);
            make.centerY.equalTo(self);
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

- (void) setModel:(TerminalFile *)model {
    _startLabel.text = [model startTime2];
    _endLabel.text = [model endTime2];
    _channelLabel.text = [NSString stringWithFormat:@"通道%@", model.logicChannel];
}

@end
