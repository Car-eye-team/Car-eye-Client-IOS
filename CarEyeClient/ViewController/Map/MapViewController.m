//
//  MapViewController.m
//  CarEyeClient
//
//  Created by liyy on 2019/10/20.
//  Copyright © 2019年 CarEye. All rights reserved.
//

#import "MapViewController.h"
#import "CarTreeViewController.h"
#import "CarTreeViewModel.h"
#import "SelectView.h"
#import "CarLocalData.h"
#import "MapViewModel.h"
#import "DateUtil.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BMKLocationKit/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "UIExPickerView.h"
#import "CustomPaopaoView.h"

@interface MapViewController ()<BMKMapViewDelegate, BMKLocationAuthDelegate, BMKLocationManagerDelegate, pickerDelegate, BMKGeoCodeSearchDelegate>

@property (weak, nonatomic) IBOutlet UILabel *carNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet SelectView *rateView;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;

//当前界面的mapView
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationManager *locationManager;
@property (nonatomic, strong) BMKPointAnnotation *annotation;

@property (nonatomic, strong) CarTreeViewModel *vm;
@property (nonatomic, strong) MapViewModel *viewModel;
@property (nonatomic, copy) NSString *terminal;

@property (nonatomic, assign) int rateSecond;
@property (nonatomic, strong) NSTimer *timer;

@property(nonatomic , strong) BMKGeoCodeSearch *geoCodeSearch;

@end

@implementation MapViewController

- (instancetype) initWithStoryborad {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MapViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _carNoLabel.text = @"";
    _timeLabel.text = @"";
    _rateLabel.text = @"0秒";
    
    [_topView setBackgroundColor:UIColorFromRGB(0xF79733)];
    [_rateView setDefaultColor:0xF79733];
    [_rateView setSelectColor:0xF79733];
    [_rateView setClickListener:^(id result) {
        NSArray *arr = @[ @"10秒", @"20秒", @"1分钟", @"2分钟", @"3分钟" ];
        
        UIExPickerView *pView = [[UIExPickerView alloc] initWithArr:arr];
        pView.delegate = self;
        [pView show];
    }];
    
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:BAIDU_KEY authDelegate:self];
    
    [self.locationManager setLocatingWithReGeocode:YES];
    [self.locationManager startUpdatingLocation];
    
    _mapView.delegate = self;//设置mapView的代理
    [_mapView setZoomLevel:17];//将当前地图显示缩放等级设置为17级
    _mapView.showMapScaleBar = YES;//显示比例尺
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //当mapView即将被显示的时候调用，恢复之前存储的mapView状态
    [_mapView viewWillAppear];
    
    self.parentViewController.navigationController.navigationBar.barTintColor = UIColorFromRGB(LQThemeColor);// 导航栏背景颜色
    self.parentViewController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.parentViewController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.parentViewController.navigationItem.title = NSLocalizedString(@"mapTitle", @"");
    
    UIBarButtonItem *settingBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_action_setting"] style:UIBarButtonItemStyleDone target:self action:@selector(setting)];
    self.parentViewController.navigationItem.leftBarButtonItem = settingBtn;
    
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_search"] style:UIBarButtonItemStyleDone target:self action:@selector(search)];
    self.parentViewController.navigationItem.rightBarButtonItem = searchBtn;
    
    self.terminal = [[CarLocalData sharedInstance] gainTerminal];
    if (self.terminal && ![self.terminal isEqualToString:@""]) {
        self.viewModel.terminal = self.terminal;
        [self.viewModel.dataCommand execute:nil];
        
        // 启动定时器
        self.rateSecond = [[CarLocalData sharedInstance] gainRate];
        if (@available(iOS 10.0, *)) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
                self.rateLabel.text = [NSString stringWithFormat:@"%d秒", self.rateSecond];
                self.rateSecond--;
                
                if (self.rateSecond == 0) {
                    self.rateSecond = [[CarLocalData sharedInstance] gainRate];
                    
                    [self.viewModel.dataCommand execute:nil];
                }
            }];
        } else {
            // Fallback on earlier versions
        }
    } else {
        [self showTextHubWithContent:@"当前没有选定车"];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    //当mapView即将被隐藏的时候调用，存储当前mapView的状态
    [_mapView viewWillDisappear];
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.locationManager stopUpdatingLocation];
}

- (void) setting {
    
}

- (void) search {
    CarTreeViewController *vc = [[CarTreeViewController alloc] initWithStoryborad];
    [self basePushViewController:vc];
}

#pragma mark - LQViewControllerProtocol

- (void)bindViewModel {
    
}

- (MapViewModel *) viewModel {
    if (!_viewModel) {
        _viewModel = [[MapViewModel alloc] init];
    }
    
    return _viewModel;
}

- (void) setCarStatus {
    if (self.annotation) {
        [_mapView removeAnnotation:self.annotation];
    }
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.viewModel.model bLatitude], [self.viewModel.model bLongitude]);
    
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;
    self.mapView.centerCoordinate = coordinate;
    
    self.annotation = [[BMKPointAnnotation alloc]init];
    self.annotation.coordinate = coordinate;
    self.annotation.title = self.viewModel.model.terminal;
    self.annotation.subtitle = self.viewModel.model.typeName;
    [_mapView addAnnotation:self.annotation];
    [_mapView selectAnnotation:self.annotation animated:NO];
}

#pragma mark - getter/setter

- (BMKLocationManager *) locationManager {
    if (!_locationManager) {
        _locationManager = [[BMKLocationManager alloc] init];
        //设置delegate
        _locationManager.delegate = self;
        //设置返回位置的坐标系类型
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设置距离过滤参数
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        //设置预期精度参数
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设置应用位置类型
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        //设置是否自动停止位置更新
        _locationManager.pausesLocationUpdatesAutomatically = YES;
        //设置是否允许后台定位
        _locationManager.allowsBackgroundLocationUpdates = NO;
        //设置位置获取超时时间
        _locationManager.locationTimeout = 10;
        //设置获取地址信息超时时间
        _locationManager.reGeocodeTimeout = 10;
    }
    
    return _locationManager;
}

#pragma mark - BMKLocationManagerDelegate

- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateLocation:(BMKLocation * _Nullable)location orError:(NSError * _Nullable)error {
    
}

#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        BMKAnnotationView *av = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (av == nil) {
            av = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        
        av.image = [UIImage imageNamed:[DepartmentCar imageResource:self.viewModel.model.carstatus]];
        av.canShowCallout = YES;
        
        CustomPaopaoView *pv = [[CustomPaopaoView alloc] init];
        pv.frame = CGRectMake(0, 0, 300, 160);
        pv.model = self.viewModel.model;
        
        BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc] initWithCustomView:pv];
        pView.backgroundColor = [UIColor clearColor];
        pView.frame = pv.frame;
        av.paopaoView = pView;
        
        return av;
    }

    return nil;
}

#pragma mark - pickerDelegate

- (void)selectIndex:(NSInteger)index {
    switch (index) {
        case 0:
            self.rateSecond = 10;
            break;
        case 1:
            self.rateSecond = 30;
            break;
        case 2:
            self.rateSecond = 60;
            break;
        case 3:
            self.rateSecond = 120;
            break;
        case 4:
            self.rateSecond = 180;
            break;
        default:
            break;
    }
    
    self.rateLabel.text = [NSString stringWithFormat:@"%d秒", self.rateSecond];
    [[CarLocalData sharedInstance] saveRate:self.rateSecond];
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
        //在此处理正常结果
        BMKPoiInfo *POIInfo = result.poiList[0];
        BMKSearchRGCRegionInfo *regionInfo = [[BMKSearchRGCRegionInfo alloc] init];
        if (result.poiRegions.count > 0) {
            regionInfo = result.poiRegions[0];
        }
        
        self.viewModel.model.address = [NSString stringWithFormat:@"%@%@", result.address, result.sematicDescription];
        [self setCarStatus];
        
        NSString *message = [NSString stringWithFormat:@"经度：%f\n纬度：%f\n地址名称：%@\n商圈名称：%@\n可信度：%ld\n国家名称：%@\n省份名称：%@\n城市名称：%@\n区县名称：%@\n乡镇：%@\n街道名称：%@\n街道号码：%@\n行政区域编码：%@\n国家代码：%@\n方向：%@\n距离：%@\nPOI名称：%@\nPOI经纬坐标：%f\nPOI纬度坐标：%f\nPOI地址信息：%@\nPOI电话号码：%@\nPOI的唯一标识符：%@\nPOI所在省份：%@\nPOI所在城市：%@\nPOI所在行政区域：%@\n街景ID：%@\n是否有详情信息：%d\nPOI方向：%@\nPOI距离：%ld\nPOI邮编：%ld\n相对位置关系：%@\n归属区域面名称：%@\n归属区域面类型：%@\n语义化结果描述：%@",
                             result.location.longitude,
                             result.location.latitude,
                             result.address,
                             result.businessCircle,
                             (long)result.confidence,
                             result.addressDetail.country,
                             result.addressDetail.province,
                             result.addressDetail.city,
                             result.addressDetail.district,
                             result.addressDetail.town,
                             result.addressDetail.streetName,
                             result.addressDetail.streetNumber,
                             result.addressDetail.adCode,
                             result.addressDetail.countryCode,
                             result.addressDetail.direction,
                             result.addressDetail.distance,
                             POIInfo.name,
                             POIInfo.pt.longitude,
                             POIInfo.pt.latitude,
                             POIInfo.address,
                             POIInfo.phone,
                             POIInfo.UID,
                             POIInfo.province,
                             POIInfo.city,
                             POIInfo.area,
                             POIInfo.streetID, POIInfo.hasDetailInfo, POIInfo.direction, (long)POIInfo.distance, (long)POIInfo.zipCode, regionInfo.regionDescription, regionInfo.regionName, regionInfo.regionTag, result.sematicDescription];
        
        NSLog(@"--->%@",message);
    } else {
        NSLog(@"检索失败");
    }
}

@end
