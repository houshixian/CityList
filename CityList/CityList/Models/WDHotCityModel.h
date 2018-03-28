//
//  WDHotCityModel.h
//  WDNewGraduate
//
//  Created by WDhsx on 2017/10/25.
//  Copyright © 2017年 Wendu Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDHotCityModel : NSObject
/*
 code = 120000;
 "first_char" = T;
 id = 429;
 name = "\U5929\U6d25\U5e02";
 pinyin = tianjinshi;
 region = 022;
 schoolnum = 0;
 */


@property(nonatomic,copy) NSString *code;
@property(nonatomic,copy)NSString *first_char;
@property(nonatomic,copy)NSString *WDID;

@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *region;
@property(nonatomic,copy) NSString *pinyin;
@property(nonatomic,copy) NSString *schoolnum;




@end
