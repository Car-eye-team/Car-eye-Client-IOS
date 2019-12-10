//
//  SearchTrackViewController.m
//  CarEyeClient
//
//  Created by liyy on 2019/10/24.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "SearchTrackViewController.h"
#import "CarTreeViewController.h"
#import "SelectView.h"
#import "DateUtil.h"
#import "AppDelegate.h"
#import "CXDatePickerView.h"
#import "UIExPickerView.h"

@interface SearchTrackViewController ()

@property (weak, nonatomic) IBOutlet SelectView *selectCarView;
@property (weak, nonatomic) IBOutlet UILabel *carNoLabel;
@property (weak, nonatomic) IBOutlet SelectView *dateView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet SelectView *startTimeView;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet SelectView *endTimeView;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (nonatomic, strong) DepartmentCar *car;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;

@end

@implementation SearchTrackViewController

- (instancetype) initWithStoryborad {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchTrackViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.title) {
        self.navigationItem.title = self.title;
    } else {
        self.navigationItem.title = @"轨迹搜索";
    }
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    _carNoLabel.text = @"";
    _dateLabel.text = [DateUtil dateYYYY_MM_DD:[NSDate date]];
    
    [self setClickListener];
    
    if (self.param) {
        _car = self.param.car;
        _carNoLabel.text = self.param.car.nodeName;
        
        self.dateLabel.text = [self.param.begTime componentsSeparatedByString:@" "][0];
        self.startTimeLabel.text = [self.param.begTime componentsSeparatedByString:@" "][1];
        self.endTimeLabel.text = [self.param.endTime componentsSeparatedByString:@" "][1];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([AppDelegate sharedDelegate].car) {
        self.car = [AppDelegate sharedDelegate].car;
        _carNoLabel.text = self.car.nodeName;
        [AppDelegate sharedDelegate].car = nil;
    }
}

- (void) setClickListener {
    [_selectCarView setClickListener:^(id result) {
        CarTreeViewController *vc = [[CarTreeViewController alloc] initWithStoryborad];
        [self basePushViewController:vc];
    }];
    
    [_dateView setClickListener:^(id result) {
        CXDatePickerView *dateView;
        if (self.date) {
            dateView = [[CXDatePickerView alloc] initWithDateStyle:CXDateStyleShowYearMonthDay scrollToDate:self.date CompleteBlock:^(NSDate *date) {
                [self dealDate:date];
            }];
        } else {
            dateView = [[CXDatePickerView alloc] initWithDateStyle:CXDateStyleShowYearMonthDay CompleteBlock:^(NSDate *date) {
                [self dealDate:date];
            }];
        }
        
        [dateView show];
    }];
    
    [_startTimeView setClickListener:^(id result) {
        CXDatePickerView *dateView;
        if (self.startTime) {
            dateView = [[CXDatePickerView alloc] initWithDateStyle:CXDateStyleShowHourMinute scrollToDate:self.startTime CompleteBlock:^(NSDate *date) {
                [self dealStartTime:date];
            }];
        } else {
            dateView = [[CXDatePickerView alloc] initWithDateStyle:CXDateStyleShowHourMinute CompleteBlock:^(NSDate *date) {
                [self dealStartTime:date];
            }];
        }
        
        [dateView show];
    }];
    
    [_endTimeView setClickListener:^(id result) {
        CXDatePickerView *dateView;
        if (self.endTime) {
            dateView = [[CXDatePickerView alloc] initWithDateStyle:CXDateStyleShowHourMinute scrollToDate:self.endTime CompleteBlock:^(NSDate *date) {
                [self dealEndTime:date];
            }];
        } else {
            dateView = [[CXDatePickerView alloc] initWithDateStyle:CXDateStyleShowHourMinute CompleteBlock:^(NSDate *date) {
                [self dealEndTime:date];
            }];
        }
        
        [dateView show];
    }];
}

- (void) dealDate:(NSDate *)date {
    self.date = date;
    self.dateLabel.text = [DateUtil dateYYYY_MM_DD:date];
}

- (void) dealStartTime:(NSDate *)date {
    self.startTime = date;
    self.startTimeLabel.text = [DateUtil dateHH_MM_SS:date];
}

- (void) dealEndTime:(NSDate *)date {
    self.endTime = date;
    NSString *str = [DateUtil dateHH_MM_SS:date];
    self.endTimeLabel.text = [NSString stringWithFormat:@"%@:59", [str substringToIndex:5]];
}

#pragma mark - LQViewControllerProtocol

- (void)bindViewModel {
    
}

- (IBAction)search:(id)sender {
    if (!self.car) {
        [self showTextHubWithContent:@"请选择终端"];
        return;
    }
    
    NSString *begTime = [NSString stringWithFormat:@"%@ %@", _dateLabel.text, _startTimeLabel.text];
    NSString *endTime = [NSString stringWithFormat:@"%@ %@", _dateLabel.text, _endTimeLabel.text];
    
    SearchParam *p = [[SearchParam alloc] init];
    p.car = self.car;
    p.begTime = begTime;
    p.endTime = endTime;
    
    [self.subject sendNext:p];
    [self.navigationController popViewControllerAnimated:YES];
}

- (RACSubject *) subject {
    if (!_subject) {
        _subject = [RACSubject subject];
    }
    
    return _subject;
}

@end
