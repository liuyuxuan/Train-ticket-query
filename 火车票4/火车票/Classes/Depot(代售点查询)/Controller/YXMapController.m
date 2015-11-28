//
//  YXMapController.m
//  火车票
//
//  Created by 刘雨轩 on 15/10/17.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#import "YXMapController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "YXAnnotation.h"
#import "MBProgressHUD+XMG.h"
@interface YXMapController ()<CLLocationManagerDelegate,MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property(nonatomic,strong)CLLocationManager *manager;  /**< 位置管理者*/
@property(nonatomic,strong)YXAnnotation *annotation;  /**< 从代售点进入的位置*/
@property(nonatomic,strong)YXAnnotation *addAnnotation;  /**< 地图保存的位置*/
@property (nonatomic, strong) CLGeocoder *geoC;//位置管理器
@property (nonatomic,strong)NSDictionary *dict;
@end

@implementation YXMapController
#pragma mark   懒加载
#pragma ----------------------------
- (CLGeocoder *)geoC
{
    if (!_geoC) {
        _geoC = [[CLGeocoder alloc] init];
    }
    return _geoC;
}

- (CLLocationManager *)manager
{
    if (!_manager) {
        _manager = [[CLLocationManager alloc]init];
        _manager.delegate = self;
        
        //适配.请求授权
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            [_manager requestWhenInUseAuthorization];
            if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
                [_manager requestAlwaysAuthorization];
            }
        }
    }
    return _manager;
}
#pragma mark   按键处理
#pragma ----------------------------
- (IBAction)back:(id)sender {
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
}

- (IBAction)returnPop:(UIButton *)sender {
    //  确定按钮
    if (sender.tag) {
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"map" object:nil userInfo:self.dict];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self judgeStatus];
}

- (void)viewDidLoad
{
    self.navigationItem.title = @"地图定位";
    [super viewDidLoad];
    [self.manager requestLocation];
    [self setUpMap];
}

- (void)judgeStatus
{
    if (self.address.length > 0) {      //用户点击地址进入的
        [self.geoC geocodeAddressString:self.address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            CLPlacemark *pl = [placemarks firstObject];
            
            YXAnnotation *annotation = [[YXAnnotation alloc]init];
            annotation.coordinate = pl.location.coordinate;
            annotation.title = pl.locality;
            annotation.subtitle = pl.name;
            [self.mapView addAnnotation:annotation];
            self.annotation = annotation;
        }];
    }else
    {
        self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    }
}

- (void)setUpMap
{
    
    self.mapView.mapType = MKMapTypeStandard;
    // 设置地图的显示项
    // 指南针
    self.mapView.delegate = self;
    self.mapView.showsCompass = YES;
    // 比例尺
    self.mapView.showsScale = YES;
    // 显示交通
    self.mapView.showsTraffic = YES;
    // 兴趣点
    self.mapView.showsPointsOfInterest = YES;
    // 建筑物
    self.mapView.showsBuildings = YES;
    
    [self.mapView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addAn:) ]];
}

- (void)addAn:(UIGestureRecognizer *)gest
{
    //获取位置
    CGPoint point = [gest locationInView:self.mapView];
    //转换坐标
    CLLocationCoordinate2D center = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:center.latitude longitude:center.longitude];
    if (self.addAnnotation) {
     [self.mapView removeAnnotation:self.addAnnotation];
    }
    YXAnnotation *annotation = [[YXAnnotation alloc]init];
    self.addAnnotation  = annotation;
    [self.mapView addAnnotation:annotation];
    [self.geoC reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error == nil) {
            
            annotation.coordinate = center;
            CLPlacemark *pl = [placemarks firstObject];
            annotation.title = pl.locality;
            annotation.subtitle = pl.name;
            self.dict = pl.addressDictionary;
        }
        
    }];
    
}

#pragma mark - MKMapViewDelegate
// 自定义方法, 系统的加载大头针视图的实现方案
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    // 模拟当这个方法, 返回nil, 系统加载系统自带的打头针视图的流程 MKPinAnnotationView
    // 大头针也有重复利用机制
    static NSString *pinID = @"pinID";
    MKPinAnnotationView  *pinView = (MKPinAnnotationView  *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinID];
    if (pinView == nil) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinID];
    }
    // 重新设置一次, 大头针数据模型, 防止重复利用时, 数据出错
    pinView.annotation = annotation;
    // 设置大头针可以弹框
    pinView.canShowCallout = YES;
    if ([annotation isEqual:self.annotation])
    {
        pinView.pinTintColor = [UIColor blackColor];
        // 不会自动放大地图比例
        CLLocationCoordinate2D centerCoordinate = annotation.coordinate;
        MKCoordinateSpan span = MKCoordinateSpanMake(0.027023, 0.018108);
        MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate,span);
        // 设置地图显示区域
        [self.mapView setRegion:region animated:YES];

    }

    return pinView;
}
/**
 *  当地图获取到用户位置时调用
 *
 *  @param mapView      地图
 *  @param userLocation 大头针数据模型
 */
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    // 显示当前地图的中心, 在哪个具体的经纬度坐标
    // 不会自动放大地图比例
    [self.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    //将用户的地址转换地址
    [self.geoC reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error == nil) {
            
            CLPlacemark *pl = [placemarks firstObject];
            userLocation.title = pl.locality;
            userLocation.subtitle = pl.name;
            self.dict = pl.addressDictionary;
            
        }
        
    }];
    
    CLLocationCoordinate2D centerCoordinate = userLocation.location.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.027023, 0.018108);
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate,span);
    // 设置地图显示区域
    [self.mapView setRegion:region animated:YES];
    
    
}




#pragma mark - CLLocationManagerDelegate

// 定位失败时调用
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [MBProgressHUD showError:@"定位失败!"];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
//    NSLog(@"定位到了");
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusDenied:
        {
            
            // 判断当前设备是否支持定位, 定位服务是否开启
            if([CLLocationManager locationServicesEnabled])
            {
                [MBProgressHUD showError:@"请授权,以获取位置!"];
                
                // 提醒给APP 授权
                // iOS8.0- , 截图
                // iOS8.0+ , 通过调用一个方法, 来直接到达设置界面
                // 跳转核心代码
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL: url];
                }
                
            }
            else
            {
                [MBProgressHUD showError:@"请打开GPS服务!"];
                
            }
            break;
        }
    }
}
#pragma mark   创建的方法
#pragma ----------------------------
- (instancetype)init
{
    return [[NSBundle mainBundle] loadNibNamed:@"YXMapController" owner:nil options:nil].lastObject;
}

@end
