//
//  PlaybackCell.h
//  CarEyeClient
//
//  Created by liyy on 2019/11/6.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TerminalFile.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlaybackCell : UITableViewCell

@property (nonatomic, strong) UILabel *startLabel;
@property (nonatomic, strong) UILabel *endLabel;

@property (nonatomic, strong) TerminalFile *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end

NS_ASSUME_NONNULL_END
