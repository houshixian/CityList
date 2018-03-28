//
//  CitySelectionViewCell.m
//  WDNewGraduate
//
//  Created by WDhsx on 2017/9/22.
//  Copyright © 2017年 Wendu Group. All rights reserved.
//

#import "CitySelectionViewCell.h"
#import "WDCityModel.h"
#import "WDHotCityModel.h"
@implementation CitySelectionViewCell




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)CreateCellViewDataSource:(NSArray *)Array{

    
    
    _hotCityArray = Array;
    //算法实例：
    int margin = 0;//间隙
    int width = WIDTH/3;//格子的宽
    int height = 47.75;//格子的高
    
    for (int i = 0; i <Array.count; i++) {
        WDHotCityModel *Model = Array[i];
        
        int row = i/3;
        int col = i%3;
        UIButton * Button = [UIButton  buttonWithType:UIButtonTypeCustom];
        Button.frame = CGRectMake(col*(width+margin), row*(height+margin), width, height);
        Button.backgroundColor = [UIColor whiteColor];
        Button.tag = 1000 + i;
        [Button setTitleColor:BRCOLOR(@"#333333") forState:UIControlStateNormal];
        [Button setTitle:Model.name forState:UIControlStateNormal];
        [Button addTarget:self action:@selector(ButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:Button];
    }
    
   
    
    for (int i = 0; i < (Array.count-1)/3; i++) {
        
        UIView *LineView = [[UIView alloc]initWithFrame:CGRectMake(15, 47.75 + (i * 47.75), WIDTH - 30, 0.5)];
        
        LineView.backgroundColor = BRCOLOR(@"#e5e5e5");
        
        
        [self.contentView addSubview:LineView];
        
    }



}


- (void)ButtonAction:(UIButton *)sender{
    WDHotCityModel *Model = _hotCityArray[sender.tag - 1000];
    if (self.hotCityNameBlock) {
        self.hotCityNameBlock(Model.region,Model.name);
    }
    
//    [self.navigationController popViewControllerAnimated:YES];

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
