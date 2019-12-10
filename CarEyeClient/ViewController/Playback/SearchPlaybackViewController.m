//
//  SearchPlaybackViewController.m
//  CarEyeClient
//
//  Created by liyy on 2019/10/24.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "SearchPlaybackViewController.h"
#import "CarTreeViewController.h"
#import "SelectView.h"
#import "DateUtil.h"
#import "AppDelegate.h"
#import "CXDatePickerView.h"
#import "UIExPickerView.h"

@interface SearchPlaybackViewController ()<pickerDelegate>

@property (weak, nonatomic) IBOutlet SelectView *selectCarView;
@property (weak, nonatomic) IBOutlet UILabel *carNoLabel;
@property (weak, nonatomic) IBOutlet SelectView *fileView;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet SelectView *channelView;
@property (weak, nonatomic) IBOutlet UILabel *channelNameLabel;
@property (weak, nonatomic) IBOutlet SelectView *dateView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet SelectView *startTimeView;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet SelectView *endTimeView;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (nonatomic, strong) DepartmentCar *car;
@property (nonatomic, strong) NSMutableArray *channel;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;

@property (nonatomic, strong) NSArray *files;

@property (nonatomic, assign) int mChannel;
@property (nonatomic, assign) int mLocation;

@end

@implementation SearchPlaybackViewController

- (instancetype) initWithStoryborad {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchPlaybackViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _files = @[ @"终端磁盘", @"服务器" ];
    
    _mChannel = -1;
    _mLocation = -1;
    
    self.navigationItem.title = @"录像查找";
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    _carNoLabel.text = @"";
    _fileNameLabel.text = @"";
    _channelNameLabel.text = @"";
    _dateLabel.text = [DateUtil dateYYYY_MM_DD:[NSDate date]];
    
    [self setClickListener];
    
    
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
    
    [_fileView setClickListener:^(id result) {
        [self showFile];
    }];
    
    [_channelView setClickListener:^(id result) {
        if (!self.car) {
            [self showTextHubWithContent:@"请选择终端"];
        } else {
            [self showChannel];
        }
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

- (void) showFile {
    
}

- (void) showChannel {
    [self updateChannles];
    
    UIExPickerView *pView = [[UIExPickerView alloc] initWithArr:self.channel];
    pView.delegate = self;
    [pView show];
}

- (void) updateChannles {
    [self.channel removeAllObjects];
    
    [self.channel addObject:@"所有"];
    for (int i = 1 ; i < _car.channeltotals + 1; i++) {
        [self.channel addObject:[NSString stringWithFormat:@"CH%d", i]];
    }
}

- (NSMutableArray *) channel {
    if (!_channel) {
        _channel = [[NSMutableArray alloc] init];
    }
    
    return _channel;
}

#pragma mark - pickerDelegate

- (void)selectIndex:(NSInteger)index {
    _mChannel = (int) index;
    _channelNameLabel.text = _channel[index];
}

#pragma mark - LQViewControllerProtocol

- (void)bindViewModel {
    
}

- (IBAction)search:(id)sender {
    if (!self.car) {
        [self showTextHubWithContent:@"请选择终端"];
        return;
    }
    
    if (_mLocation == -1) {
        [self showTextHubWithContent:@"请选择文件位置"];
        return;
    }
    
    if (_mChannel == -1) {
        [self showTextHubWithContent:@"请选择通道"];
        return;
    }
    
    NSString *begTime = [NSString stringWithFormat:@"%@ %@", _dateLabel.text, _startTimeLabel.text];
    NSString *endTime = [NSString stringWithFormat:@"%@ %@", _dateLabel.text, _endTimeLabel.text];
    
    if (!self.param) {
        self.param = [[SearchParam alloc] init];
    }
    
    self.param.car = self.car;
    self.param.begTime = begTime;
    self.param.endTime = endTime;
    self.param.channel = self.mChannel;
    self.param.location = self.mLocation;
    
    [self.subject sendNext:self.param];
    [self.navigationController popViewControllerAnimated:YES];
}

- (RACSubject *) subject {
    if (!_subject) {
        _subject = [RACSubject subject];
    }
    
    return _subject;
}

@end
