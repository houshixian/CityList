//
//  BRPositioningManager.h
//  BoRuoBoLuoMi
//
//  Created by ZhaoYan on 2017/5/7.
//  Copyright © 2017年 ZhaoYan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRPositioningManager : NSObject
/** 经度 */
@property (nonatomic, strong) NSString *longitudeStr;
/** 纬度 */
@property (nonatomic, strong) NSString *latitudeStr;

@property (nonatomic, copy, readonly) NSString *ddressString;

+ (instancetype)shareInstance;
/**
 *  开启定位
 */
- (void)startUpdatingLocation;

- (void)startUpdatingLocationResult:(void (^)(BOOL result))resultBlock;
/**
 * 获取当前的地址
 */
- (void)setupDdress:(void (^)(NSString * ddressString))ddressBlock;
/**
 * 地理反编码
 */
- (void)getAddressWithLongitude:(NSString *)longitude latitude:(NSString *)latitude Ddress:(void (^)(NSString * ddressString))ddressBlock;

@end
