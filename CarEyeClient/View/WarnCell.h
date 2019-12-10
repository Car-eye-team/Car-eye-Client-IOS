//
//  WarnCell.h
//  CarEyeClient
//
//  Created by liyy on 2019/12/1.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Alarm.h"

NS_ASSUME_NONNULL_BEGIN

@interface WarnCell : UITableViewCell

@property (nonatomic, strong) UILabel *carNumLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) Alarm *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (CGFloat)heightForModel:(Alarm *)model;
- (void) setModel:(Alarm *)model carNumber:(NSString *)carNumber;

@end

NS_ASSUME_NONNULL_END
