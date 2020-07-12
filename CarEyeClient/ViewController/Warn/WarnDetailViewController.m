//
//  WarnDetailViewController.m
//  CarEyeClient
//
//  Created by asd on 2019/12/8.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "WarnDetailViewController.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "Masonry.h"

@interface WarnDetailViewController ()<BMKGeoCodeSearchDelegate>

@property (weak, nonatomic) IBOutlet UILabel *carNumberTv;
@property (weak, nonatomic) IBOutlet UILabel *alarmDescTv;
@property (weak, nonatomic) IBOutlet UILabel *warnHandleTv;
@property (weak, nonatomic) IBOutlet UILabel *warnHandleByTv;
@property (weak, nonatomic) IBOutlet UILabel *warnHandleTimeTv;
@property (weak, nonatomic) IBOutlet UIView *warnHandleByView;
@property (weak, nonatomic) IBOutlet UIView *warnHandleTimeView;

@property (weak, nonatomic) IBOutlet UILabel *startTimeTv;
@property (weak, nonatomic) IBOutlet UILabel *startSpeedTv;
@property (weak, nonatomic) IBOutlet UILabel *startLatLonTv;
@property (weak, nonatomic) IBOutlet UILabel *startLocationTv;
@property (weak, nonatomic) IBOutlet UILabel *endTimeTv;
@property (weak, nonatomic) IBOutlet UILabel *endSpeedTv;
@property (weak, nonatomic) IBOutlet UILabel *endLatLonTv;
@property (weak, nonatomic) IBOutlet UILabel *endLocationTv;

@property(nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;

@property(nonatomic, copy) NSString *lat;
@property(nonatomic, copy) NSString *lng;

@end

@implementation WarnDetailViewController

- (instancetype) initWithStoryborad {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WarnDetailViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"报警详情";
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
//    [self.terminalTv setText:[self.alarm terminalId]];
    [self.carNumberTv setText:self.nodeName];
//    [self.alarmNumberTv setText:[self.alarm alarmNumber]];
    [self.alarmDescTv setText:[self.alarm alarmDesc]];
    
    if ([self.alarm.isHandle isEqualToString:@"0"]) {
        [self.warnHandleTv setText:@"否"];
        [self.warnHandleByView setHidden:YES];
        [self.warnHandleTimeView setHidden:YES];
        
        [self.warnHandleByView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [self.warnHandleTimeView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    } else {
        [self.warnHandleTv setText:@"是"];
        [self.warnHandleByTv setText:self.alarm.handleBy];
        [self.warnHandleTimeTv setText:self.alarm.handleTime];
    }
    
    [self.startTimeTv setText:[self.alarm startTime]];
    [self.startSpeedTv setText:[NSString stringWithFormat:@"%@km/h", [self.alarm startSpeed]]];
    [self.startLatLonTv setText:[NSString stringWithFormat:@"%@, %@", [self.alarm startLon], [self.alarm startLat]]];
    [self.startLocationTv setText:[self.alarm startLocation]];
    
    [self.endTimeTv setText:[self.alarm endTime]];
    [self.endSpeedTv setText:[NSString stringWithFormat:@"%@km/h", [self.alarm endSpeed]]];
    [self.endLatLonTv setText:[NSString stringWithFormat:@"%@, %@", [self.alarm endLon], [self.alarm endLat]]];
    [self.endLocationTv setText:[self.alarm endLocation]];
    
    if (![self.alarm.startLat isEqualToString:@"--"] && ![self.alarm.startLon isEqualToString:@"--"]) {
        self.lat = self.alarm.startLat;
        self.lng = self.alarm.startLon;
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.lat doubleValue], [self.lng doubleValue]);
        [self geoCodeSearch:coordinate];
    } else if (![self.alarm.endLat isEqualToString:@"--"] && ![self.alarm.endLon isEqualToString:@"--"]) {
        self.lat = self.alarm.endLat;
        self.lng = self.alarm.endLon;
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.lat doubleValue], [self.lng doubleValue]);
        [self geoCodeSearch:coordinate];
    }
}

- (void) geoCodeSearch:(CLLocationCoordinate2D)coordinate {
    //构造逆地理编码检索参数
    BMKReverseGeoCodeSearchOption *reverseGeoCodeOption = [[BMKReverseGeoCodeSearchOption alloc]init];
    reverseGeoCodeOption.location = coordinate;
    // 是否访问最新版行政区划数据（仅对中国数据生效）
    reverseGeoCodeOption.isLatestAdmin = YES;
    //发起逆地理编码检索请求
    BOOL flag = [self.geoCodeSearch reverseGeoCode: reverseGeoCodeOption];
    if (flag) {
        NSLog(@"逆geo检索发送成功");
    } else {
        NSLog(@"逆geo检索发送失败");
    }
}

- (BMKGeoCodeSearch *)geoCodeSearch {
    if (!_geoCodeSearch) {
        _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
        _geoCodeSearch.delegate = self;
    }
    
    return _geoCodeSearch;
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        
        if ([self.lat isEqualToString:self.alarm.startLat]
            && [self.lng isEqualToString:self.alarm.startLon]) {
            
            [self.alarm setStartLocation:result.address];
            [self.startLocationTv setText:[self.alarm startLocation]];
            
            if (![self.alarm.endLat isEqualToString:@"--"] && ![self.alarm.endLon isEqualToString:@"--"]) {
                self.lat = self.alarm.endLat;
                self.lng = self.alarm.endLon;
                
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.lat doubleValue], [self.lng doubleValue]);
                [self geoCodeSearch:coordinate];
            }
        } else {
            [self.alarm setEndLocation:result.address];
            [self.endLocationTv setText:[self.alarm endLocation]];
        }
        
    } else {
        NSLog(@"检索失败");
    }
}

#pragma mark - LQViewControllerProtocol

- (void)bindViewModel {
    
}

@end
