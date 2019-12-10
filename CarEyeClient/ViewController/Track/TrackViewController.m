//
//  TrackViewController.m
//  CarEyeClient
//
//  Created by liyy on 2019/10/23.
//  Copyright © 2019 CarEye. All rights reserved.
//

#import "TrackViewController.h"
#import "SearchTrackViewController.h"
#import "TrackViewModel.h"
#import "SearchParam.h"
#import "CarInfoGPS.h"
#import "YQLocationTransform.h"
#import "CustomPaopaoView.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BMKLocationKit/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface TrackViewController ()<BMKMapViewDelegate, BMKLocationAuthDelegate, BMKLocationManagerDelegate, BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) TrackViewModel *vm;

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISlider *speedSlider;// 快慢
@property (weak, nonatomic) IBOutlet UISlider *slider2; // 位置
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@property (nonatomic, strong) NSMutableArray *latLngS;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) BOOL isCanMove;
@property (nonatomic, assign) int timeSpeed;    // 播放的速度
@property (nonatomic, assign) int timeNew;      // 计数器
@property (nonatomic, strong) YQLocationTransform *model;

@property (nonatomic, strong) BMKLocationManager *locationManager;
@property (nonatomic, strong) BMKPointAnnotation *startAnno;
@property (nonatomic, strong) BMKPointAnnotation *endAnno;
@property (nonatomic, strong) BMKPointAnnotation *anno;
@property (nonatomic, strong) BMKPolyline *polyline;
@property(nonatomic , strong) BMKGeoCodeSearch *geoCodeSearch;

@property (nonatomic, assign) int currentIndex;

@end

@implementation TrackViewController

- (instancetype) initWithStoryborad {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TrackViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.latLngS = [[NSMutableArray alloc] init];
    self.timeSpeed = 1;
    [self.speedSlider setMinimumValue:0];
    [self.speedSlider setMaximumValue:10];
    [self.speedSlider setValue:5];
    
    [self.startBtn setImage:[UIImage imageNamed:@"ic_playing_bar_play_pressed"] forState:UIControlStateNormal];
    [self.startBtn setImage:[UIImage imageNamed:@"ic_playing_bar_pause_pressed"] forState:UIControlStateSelected];
    
    [self.speedSlider addTarget:self action:@selector(sliderSpeedDown:) forControlEvents:UIControlEventTouchDown];
    [self.speedSlider addTarget:self action:@selector(sliderSpeedUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.slider2 addTarget:self action:@selector(sliderPositionDown:) forControlEvents:UIControlEventTouchDown];
    [self.slider2 addTarget:self action:@selector(sliderPositionUp:) forControlEvents:UIControlEventTouchUpInside];
    
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
    self.parentViewController.navigationItem.title = @"轨迹回放";

    //当mapView即将被显示的时候调用，恢复之前存储的mapView状态
    [_mapView viewWillAppear];
    
    UIBarButtonItem *settingBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_action_setting"] style:UIBarButtonItemStyleDone target:self action:@selector(setting)];
    self.parentViewController.navigationItem.leftBarButtonItem = settingBtn;
    
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_search"] style:UIBarButtonItemStyleDone target:self action:@selector(search)];
    self.parentViewController.navigationItem.rightBarButtonItem = searchBtn;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    //当mapView即将被隐藏的时候调用，存储当前mapView的状态
    [_mapView viewWillDisappear];
    
    [self hideHub];
    [self stopTimer];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.locationManager stopUpdatingLocation];
}

- (void) setting {
    
}

- (void) search {
    SearchTrackViewController *vc = [[SearchTrackViewController alloc] initWithStoryborad];
    vc.param = self.vm.param;
    [vc.subject subscribeNext:^(SearchParam *p) {
        [self showHub];
        
        self.vm.param = p;
        [self.vm.dataCommand execute:nil];
    }];
    [self basePushViewController:vc];
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
        
        [_locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
            //获取经纬度和该定位点对应的位置信息
            
            if (error) {
                NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            }
            
            if (location) {//得到定位信息，添加annotation
                BMKUserLocation *userLocation = [[BMKUserLocation alloc] init];
                userLocation.location = location.location;
                [self.mapView updateLocationData:userLocation];
            }
        }];
    }
    
    return _locationManager;
}

#pragma mark - BMKLocationManagerDelegate

- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateLocation:(BMKLocation * _Nullable)location orError:(NSError * _Nullable)error {
    
}

#pragma mark - BMKMapViewDelegate

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithPolyline:overlay];
        //设置polylineView的画笔颜色
        polylineView.strokeColor = UIColorFromRGB(0xff0000);
        //设置polylineView的画笔宽度
        polylineView.lineWidth = 2;
        //圆点虚线，V5.0.0新增
//        polylineView.lineDashType = kBMKLineDashTypeDot;
        //方块虚线，V5.0.0新增
//       polylineView.lineDashType = kBMKLineDashTypeSquare;
        return polylineView;
    }
    return nil;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    BMKAnnotationView *av;
    
    if (annotation == self.startAnno) {
        static NSString *reuseIndetifier = @"startAnnotation";
        av = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (av == nil) {
            av = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        av.image = [UIImage imageNamed:@"start_x"];
    } else if (annotation == self.endAnno) {
        static NSString *reuseIndetifier = @"endAnnotation";
        av = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (av == nil) {
            av = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        av.image = [UIImage imageNamed:@"end_x"];
    } else if (annotation == self.anno) {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        BMKAnnotationView *av = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (av == nil) {
            av = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        
        if (self.timeNew < self.vm.data.count) {
            CarInfoGPS *gps = self.vm.data[self.timeNew];
            av.image = [UIImage imageNamed:[DepartmentCar imageResource:gps.carstatus]];
            av.canShowCallout = YES;
            
            CustomPaopaoView *pv = [[CustomPaopaoView alloc] init];
            pv.frame = CGRectMake(0, 0, 300, 180);
            pv.model = gps;
            
            BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc] initWithCustomView:pv];
            pView.backgroundColor = [UIColor clearColor];
            pView.frame = pv.frame;
            av.paopaoView = pView;
        }
        
        return av;
    }
    
    av.canShowCallout = YES;
    return av;
}

#pragma mark - LQViewControllerProtocol

- (void)bindViewModel {
    
}

- (TrackViewModel *) vm {
    if (!_vm) {
        _vm = [[TrackViewModel alloc] init];
    }
    
    return _vm;
}

// 添加点、线 纹理路径
- (void) addCustomElementsDemoTwo {
    [self.latLngS removeAllObjects];
    
    for (CarInfoGPS *gps in self.vm.data) {
//        LatLng *latLng = [[LatLng alloc] initWithLat:[gps.lat doubleValue] lng:[gps.lng doubleValue]];
        YQLocationTransform *loc = [[YQLocationTransform alloc] initWithLatitude:[gps.lat doubleValue] andLongitude:[gps.lng doubleValue]];
        YQLocationTransform *res = [[loc transformFromGPSToGD] transformFromGDToBD];
        [self.latLngS addObject:res];
    }
    
    [self drawStartAnno:self.latLngS.lastObject];
    [self drawEndAnno:self.latLngS.firstObject];
    [self drawPolyline];
}

- (void) drawStartAnno:(YQLocationTransform *)latLng {
    if (self.startAnno) {
        [_mapView removeAnnotation:self.startAnno];
    }
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latLng.latitude, latLng.longitude);
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;
    self.mapView.centerCoordinate = coordinate;
    [self.mapView setZoomLevel:21];
    
    self.startAnno = [[BMKPointAnnotation alloc]init];
    self.startAnno.coordinate = coordinate;
    [_mapView addAnnotation:self.startAnno];
    [_mapView selectAnnotation:self.startAnno animated:NO];
}

- (void) drawEndAnno:(YQLocationTransform *)latLng {
    if (self.endAnno) {
        [_mapView removeAnnotation:self.endAnno];
    }
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latLng.latitude, latLng.longitude);
    self.endAnno = [[BMKPointAnnotation alloc]init];
    self.endAnno.coordinate = coordinate;
    [_mapView addAnnotation:self.endAnno];
    [_mapView selectAnnotation:self.endAnno animated:NO];
}

- (void) drawPolyline {
    int count = (int)self.latLngS.count;
    CLLocationCoordinate2D coords[count];
    
    for (int i = 0; i < self.latLngS.count; i++) {
        YQLocationTransform *loc = self.latLngS[i];
        
        coords[i] = CLLocationCoordinate2DMake(loc.latitude, loc.longitude);
    }
    
    BMKPolyline *polyline = [BMKPolyline polylineWithCoordinates:coords count:count];
    [_mapView addOverlay:polyline];
}

#pragma mark - click

- (IBAction)play:(id)sender {
    if (self.latLngS.count == 0) {
        [self showTextHubWithContent:@"没有轨迹信息不能播放或暂停"];
        return;
    }
    
    self.startBtn.selected = !self.startBtn.selected;
    
    if (self.startBtn.selected) {
        [self startTimer];
    } else {
        [self stopTimer];
    }
}

- (void) sliderSpeedDown:(id)sender {
    [self stopTimer];
}

- (void) sliderSpeedUp:(id)sender {
    [self updateSpeed];
    [self startTimer];
}

- (void) sliderPositionDown:(id)sender {
    [self stopTimer];
}

- (void) sliderPositionUp:(id)sender {
    self.timeNew = (int)[self.slider2 value];
    [self startTimer];
}

// 控制快慢
- (void)updateSpeed {
    int v = (int)[self.speedSlider value];
    switch (v) {
        case 0:
            self.timeSpeed = 10;
            break;
        case 1:
            self.timeSpeed = 8;
            break;
        case 2:
            self.timeSpeed = 6;
            break;
        case 3:
            self.timeSpeed = 4;
            break;
        case 4:
            self.timeSpeed = 2;
            break;
        case 5:
            self.timeSpeed = 1;
            break;
        case 6:
            self.timeSpeed = 0.8;
            break;
        case 7:
            self.timeSpeed = 0.6;
            break;
        case 8:
            self.timeSpeed = 0.4;
            break;
        case 9:
            self.timeSpeed = 0.2;
            break;
        case 10:
            self.timeSpeed = 0.05;
            break;
        default:
            self.timeSpeed = 1;
            break;
    }
}

- (void) startTimer {
    self.startBtn.selected = YES;
    
    if (@available(iOS 10.0, *)) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeSpeed repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self.slider2 setValue:self.timeNew];
            
            [self setAnnotation:self.latLngS[self.latLngS.count - self.timeNew - 1]];
            
            self.timeNew++;
            
            if (self.timeNew >= self.latLngS.count) {
                self.timeNew = 0;
                [self stopTimer];
            }
        }];
    } else {
        // Fallback on earlier versions
    }
}

- (void) stopTimer {
    self.startBtn.selected = NO;
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void) setAnnotation:(YQLocationTransform *)loc {
    self.model = loc;
    
    if (self.anno) {
        [_mapView removeAnnotation:self.anno];
    }
    
    self.anno = [[BMKPointAnnotation alloc]init];
    self.anno.coordinate = CLLocationCoordinate2DMake(loc.latitude, loc.longitude);
    [_mapView addAnnotation:self.anno];
    [_mapView selectAnnotation:self.anno animated:NO];
}

- (void) startSearch {
    if (self.currentIndex >= self.vm.data.count) {
        return;
    }
    
    CarInfoGPS *gps = self.vm.data[self.currentIndex];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([gps bLatitude], [gps bLongitude]);
    [self geoCodeSearch:coordinate];
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
        
        CarInfoGPS *gps = self.vm.data[self.currentIndex];
        [gps setAddress:result.address];
        
        self.currentIndex++;
        [self startSearch];
    } else {
        NSLog(@"检索失败");
    }
}

@end
