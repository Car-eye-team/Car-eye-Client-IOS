//
//  CarTreeCell.h
//  CarEyeClient
//
//  Created by liyy on 2019/10/28.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DepartmentCar.h"

NS_ASSUME_NONNULL_BEGIN

@interface CarTreeCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iv;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) DepartmentCar *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
