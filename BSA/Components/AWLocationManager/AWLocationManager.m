//
//  AWLocationManager.m
//  deyi
//
//  Created by tangwei1 on 16/9/5.
//  Copyright © 2016年 tangwei1. All rights reserved.
//

#import "AWLocationManager.h"

@interface AWLocationManager () <CLLocationManagerDelegate>

/** 返回当前最新的位置 */
@property (nonatomic, strong, readwrite) CLLocation *currentLocation;
@property (nonatomic, strong, readwrite) NSError    *locatedError;

@property (nonatomic, copy) void (^completionBlock)(CLLocation *location, NSError *error);

@property (nonatomic, assign, readwrite) BOOL locating;

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

NSString * const AWLocationManagerDidFinishLocatingNotification = @"AWLocationManagerDidFinishLocatingNotification";

@implementation AWLocationManager

#define kLocationFormat @"%.06f,%.06f"

+ (AWLocationManager *)sharedInstance
{
    static AWLocationManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ( !instance ) {
            instance = [[AWLocationManager alloc] init];
        }
    });
    return instance;
}

- (void)startUpdatingLocation:(void (^)(CLLocation *, NSError *))completionBlock
{
    if ( self.locating ) {
        [self log:@"正在定位中..."];
        return;
    }
    
    self.locating = YES;
    
    self.completionBlock = completionBlock;
    
    // 检查定位服务是否可用
    if ( [self isLocationServiceEnabled] == NO ) return;
    
    // 检查定位服务使用权限
    if ( [self isAllowedUseLocationService] == NO ) return;
    
    self.locationManager.delegate = self;
    
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    if ( authStatus == kCLAuthorizationStatusNotDetermined ) {
        if ( [self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] ) {
            [self.locationManager requestAlwaysAuthorization];
        } else {
            [self.locationManager startUpdatingLocation];
        }
    } else {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)stopUpdatingLocation
{
    self.locating = NO;
    
    self.locationManager.delegate = nil;
    
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
}

/** 返回当前位置的经纬度格式化字符串，格式为：经度,纬度 */
- (NSString *)formatedCurrentLocation_1
{
    if ( self.currentLocation == nil ) return nil;
    
    return [NSString stringWithFormat:kLocationFormat,
            self.currentLocation.coordinate.longitude,
            self.currentLocation.coordinate.latitude];
}

/** 返回当前位置的经纬度格式化字符串，格式为：纬度,经度 */
- (NSString *)formatedCurrentLocation_2
{
    if ( self.currentLocation == nil ) return nil;
    
    return [NSString stringWithFormat:kLocationFormat,
            self.currentLocation.coordinate.latitude,
            self.currentLocation.coordinate.longitude];
}

#pragma mark -----------------------------------------------------------
#pragma mark CLLocationManager delegate
#pragma mark -----------------------------------------------------------
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
    
    self.currentLocation = location;
    
    [self handleCompletion:location error:nil];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [self handleCompletion:nil error:[NSError errorWithDomain:@"定位失败"
                                                         code:error.code
                                                     userInfo:nil]];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if ( status == kCLAuthorizationStatusAuthorizedAlways ||
         status == kCLAuthorizationStatusAuthorizedWhenInUse ) {
        [self.locationManager startUpdatingLocation];
    }
}

- (CLLocationManager *)locationManager
{
    if ( !_locationManager ) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationManager;
}

- (BOOL)isLocationServiceEnabled
{
    BOOL enabled = [CLLocationManager locationServicesEnabled];
    if ( enabled == NO ) {
        NSError *error = [NSError errorWithDomain:@"定位服务不可用"
                                             code:AWLocationErrorNotEnabled
                                         userInfo:nil];
        [self handleCompletion:nil error: error];
        
        return NO;
    }
    
    return YES;
}

- (BOOL)isAllowedUseLocationService
{
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    
    if ( authStatus == kCLAuthorizationStatusRestricted ) {
        [self handleCompletion:nil error:[NSError errorWithDomain:@"定位服务限制使用"
                                                             code:AWLocationErrorDenied
                                                         userInfo:nil
                                          ]];
        
        return NO;
    }
    
    if ( authStatus == kCLAuthorizationStatusDenied ) {
        [self handleCompletion:nil error:[NSError errorWithDomain:@"用户拒绝使用定位"
                                                             code:AWLocationErrorDenied
                                                         userInfo:nil
                                          ]];
        
        return NO;
    }
    
    return YES;
}

- (void)handleCompletion:(CLLocation *)location error:(NSError *)error
{
    self.locatedError = error;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AWLocationManagerDidFinishLocatingNotification object:self];
    
    if ( self.completionBlock ) {
        self.completionBlock(location, error);
        self.completionBlock = nil;
    }
    
    self.locating = NO;
    
    [self.locationManager stopUpdatingLocation];
    
    if ( location ) {
        [self log:[NSString stringWithFormat:@"定位成功：%@", location]];
    } else {
        [self log:[NSString stringWithFormat:@"定位失败：%@", error.domain]];
    }
}

- (void)log:(NSString *)msg
{
#if DEBUG
    NSLog(@"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,msg);
#endif
}

@end
