//
//  BRPositioningManager.m
//  BoRuoBoLuoMi
//
//  Created by ZhaoYan on 2017/5/7.
//  Copyright © 2017年 ZhaoYan. All rights reserved.
//

#import "BRPositioningManager.h"
#import <CoreLocation/CoreLocation.h>

@interface BRPositioningManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy)  void(^ddressBlock)(NSString *ddressString);
@property (nonatomic, copy) NSString *ddressString;

@property (nonatomic, copy)  void(^resultBlock)(BOOL result);

@end

@implementation BRPositioningManager

+ (instancetype)shareInstance
{
    __strong static BRPositioningManager *positioningManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        positioningManager = [[BRPositioningManager alloc] init];
    });
    return positioningManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self locationManager];
    }
    return self;
}

- (void)startUpdatingLocation
{
    [self.locationManager startUpdatingLocation];
}

- (void)startUpdatingLocationResult:(void (^)(BOOL result))resultBlock
{
    self.resultBlock = resultBlock;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        {
            if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [manager requestWhenInUseAuthorization];
            }
        }
            break;
        case kCLAuthorizationStatusDenied:
        {
            if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [manager requestWhenInUseAuthorization];
            }else{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"我们需要通过您的地理位置信息获取您周边的相关数据?" preferredStyle: UIAlertControllerStyleAlert];
                UIAlertAction *alertCancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }];
                [alertController addAction:alertCancelAction];
                [alertController addAction:sureAction];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];

            }
        }
            break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    NSLog(@"经度：%f，维度：%f",coordinate.longitude,coordinate.latitude);
    NSNumber *longitude = [NSNumber numberWithDouble:coordinate.longitude];
    NSNumber *latitude = [NSNumber numberWithDouble:coordinate.latitude];
    self.longitudeStr = [longitude stringValue];
    self.latitudeStr = [latitude stringValue];
     dispatch_async(dispatch_get_main_queue(), ^{
         if (self.resultBlock) self.resultBlock(YES);
        });
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        NSString *city = @"";
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //将获得的所有信息显示到label上
            //            self.location.text = placemark.name;
            //获取城市
            city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSLog(@"city = %@", city);
            NSString *thoroughfare=placemark.thoroughfare;
            
            if (thoroughfare == nil) {
                thoroughfare = @"";
            }
            self.ddressString = city;
            
            
//            [[WDUser sharedUser] changeWDLocationCityName:self.ddressString];
            
//            self.ddressString = [city stringByAppendingString: thoroughfare];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.ddressBlock) self.ddressBlock(self.ddressString);
            });
        }
        else if (error == nil && [array count] == 0){
            NSLog(@"No results were returned.");
            self.ddressString = @"未获取到位置信息";
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.ddressBlock) self.ddressBlock(self.ddressString);
            });
        }
        else if (error != nil){
            NSLog(@"An error occurred = %@", error);
            self.ddressString = @"未获取到位置信息";
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.ddressBlock) self.ddressBlock(self.ddressString);
                });
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error

{
    NSLog(@"error%@", error);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.resultBlock) self.resultBlock(NO);
    });


}

- (void)setupDdress:(void (^)(NSString * ddressString))ddressBlock
{
    if (ddressBlock) {
        self.ddressBlock = ddressBlock;
        if (!kStringIsEmpty(self.ddressString)) {
            self.ddressBlock(self.ddressString);
        }
    }
}

- (void)getAddressWithLongitude:(NSString *)longitude latitude:(NSString *)latitude Ddress:(void (^)(NSString * ddressString))ddressBlock
{
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:latitude.doubleValue longitude:longitude.doubleValue];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        NSString *city = @"";
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //将获得的所有信息显示到label上
            //            self.location.text = placemark.name;
            //获取城市
            city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSLog(@"city = %@", city);
//            NSString *thoroughfare=placemark.thoroughfare;
//            NSString *ddressString = [city stringByAppendingString: thoroughfare];
            NSString *ddressString  = city;
            
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (ddressBlock) ddressBlock(ddressString);
            });
        }
        else if (error == nil && [array count] == 0){
            NSLog(@"No results were returned.");
            NSString *ddressString = @"未获取到位置信息";
            dispatch_async(dispatch_get_main_queue(), ^{
                if (ddressBlock) ddressBlock(ddressString);
                });
        }
        else if (error != nil){
            NSLog(@"An error occurred = %@", error);
            NSString *ddressString = @"未获取到位置信息";
            dispatch_async(dispatch_get_main_queue(), ^{
                if (ddressBlock) ddressBlock(ddressString);
            });
        }
    }];
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager){
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
    }
    return _locationManager;
}

- (NSString *)longitudeStr
{
    if (!_longitudeStr) {
        _longitudeStr = @"";
    }
    return _longitudeStr;
}

- (NSString *)latitudeStr
{
    if (!_latitudeStr) {
        _latitudeStr = @"";
    }
    return _latitudeStr;
}

- (NSString *)ddressString
{
    if (!_ddressString) {
        _ddressString = @"";
    }
    return _ddressString;
}

@end
