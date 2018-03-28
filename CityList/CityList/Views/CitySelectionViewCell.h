//
//  CitySelectionViewCell.h
//  WDNewGraduate
//
//  Created by WDhsx on 2017/9/22.
//  Copyright © 2017年 Wendu Group. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^hotCityName)(NSString *CID, NSString *CityName);


@interface CitySelectionViewCell : UITableViewCell

@property(nonatomic,strong)NSArray *hotCityArray;

@property(copy,nonatomic)hotCityName hotCityNameBlock;


- (void)CreateCellViewDataSource:(NSArray *)Array;
@end
