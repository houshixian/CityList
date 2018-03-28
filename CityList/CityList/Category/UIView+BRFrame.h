//
//  UIView+BRFrame.h
//  BoRuoBoLuoMi
//
//  Created by ZhaoYan on 2017/4/21.
//  Copyright © 2017年 ZhaoYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BRFrame)

@property (nonatomic, assign) CGFloat left;

@property (nonatomic, assign) CGFloat top;

@property (nonatomic, assign) CGFloat right;

@property (nonatomic, assign) CGFloat bottom;

@property (nonatomic, assign) CGFloat x;

@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGFloat maxX;

@property (nonatomic, assign) CGFloat maxY;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat centerX;

@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGPoint orign;

@end
