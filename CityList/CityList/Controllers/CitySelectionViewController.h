//
//  CitySelectionViewController.h
//  WDNewGraduate
//
//  Created by WDhsx on 2017/9/21.
//  Copyright © 2017年 Wendu Group. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectedCity)(NSString *WDCityID,NSString *CityName);

@interface CitySelectionViewController : UIViewController


@property(copy,nonatomic)selectedCity selectedCityBlock;


@end
