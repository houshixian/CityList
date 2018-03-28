//
//  WDCityModel.h
//  WDNewGraduate
//
//  Created by WDhsx on 2017/10/23.
//  Copyright © 2017年 Wendu Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDCityModel : NSObject

/*
 
 area = 7;
 code = 530600;
 "first_char" = Z;
 id = 359;
 listorder = 0;
 name = "\U662d\U901a\U5e02";
 parentid = 30;
 pinyin = zhaotongshi;
 region = 0870;
 */

@property(nonatomic,copy) NSString *area;
@property(nonatomic,copy) NSString *code;
@property(nonatomic,copy)NSString *first_char;
@property(nonatomic,copy)NSString *WDID;
@property(nonatomic,copy) NSString *listorder;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *parentid;
@property(nonatomic,copy) NSString *pinyin;
@property(nonatomic,copy) NSString *region;
@end
