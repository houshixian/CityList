//
//  SearchNoResultView.m
//  WDNewGraduate
//
//  Created by WDhsx on 2017/11/4.
//  Copyright © 2017年 Wendu Group. All rights reserved.
//

#import "SearchNoResultView.h"

@implementation SearchNoResultView


-(void)awakeFromNib{
    
    [super awakeFromNib];
    self.SearchNoBtn.layer.masksToBounds = YES;
    self.SearchNoBtn.layer.cornerRadius = 32/2;
    self.SearchNoBtn.layer.borderColor = BRmainColor.CGColor;
    self.SearchNoBtn.layer.borderWidth = 0.5f;
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
