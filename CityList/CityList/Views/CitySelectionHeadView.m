//
//  CitySelectionHeadView.m
//  WDNewGraduate
//
//  Created by WDhsx on 2017/9/22.
//  Copyright © 2017年 Wendu Group. All rights reserved.
//

#import "CitySelectionHeadView.h"
#import "BRPositioningManager.h"
@implementation CitySelectionHeadView

-(void)awakeFromNib{
    [super awakeFromNib];
    __weak typeof(self) weakSelf = self;
    
    [[BRPositioningManager shareInstance] setupDdress:^(NSString *ddressString) {
        [weakSelf.LocatCityBtn setTitle:ddressString forState:UIControlStateNormal];
    }];
    
    
}

- (IBAction)LocatCityAction:(id)sender {
    
    UIButton *button = sender;
    NSLog(@"%@",button.titleLabel.text);
    if (self.LocatCityBlock) {
        self.LocatCityBlock(button.titleLabel.text);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
