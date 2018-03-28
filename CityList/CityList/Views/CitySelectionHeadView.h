//
//  CitySelectionHeadView.h
//  WDNewGraduate
//
//  Created by WDhsx on 2017/9/22.
//  Copyright © 2017年 Wendu Group. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^LocatCity)(NSString *LocatCityName);


@interface CitySelectionHeadView : UIView

@property (weak, nonatomic) IBOutlet UIButton *LocatCityBtn;

@property(nonatomic,copy)LocatCity LocatCityBlock;



@end
