//
//  CarTreeCell.m
//  CarEyeClient
//
//  Created by asd on 2019/10/28.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "CarTreeCell.h"
#import <YYKit/YYKit.h>
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
#import "UILabel+lineSpace.h"
#import "Masonry.h"

@implementation CarTreeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CarTreeCell";
    // 1.缓存中
    CarTreeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CarTreeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        
        _iv = [[UIImageView alloc] init];
        _iv.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_iv];
        [_iv makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@40);
            make.centerY.equalTo(self);
            make.left.equalTo(@6);
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = UIColorFromRGB(0x333333);
        _nameLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_nameLabel];
        [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iv.mas_right).offset(6);
            make.centerY.equalTo(self);
        }];
        
        UIView *line2 = [[UIView alloc] init];
        line2.backgroundColor = UIColorFromRGB(0xECF0F6);
        [self addSubview:line2];
        [line2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.height.equalTo(@1);
        }];
    }
    
    return self;
}

- (void) setModel:(DepartmentCar *)model {
    _nameLabel.text = model.nodeName;
    
    if (model.nodetype == 2) {
        _iv.image = [UIImage imageNamed:[DepartmentCar imageResource:model.carstatus]];
    } else {
        if (model.isExpand) {
            _iv.image = [UIImage imageNamed:@"icon_expand_hover"];
        } else {
            _iv.image = [UIImage imageNamed:@"icon_coalesce_hover"];
        }
    }
    
    [_iv updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(6 + 40 * model.depth));
    }];
}

@end
