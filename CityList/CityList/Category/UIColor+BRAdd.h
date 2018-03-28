//
//  UIColor+BRAdd.h
//  BoRuoBoLuoMi
//
//  Created by ZhaoYan on 2017/4/21.
//  Copyright © 2017年 ZhaoYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (BRAdd)

/**
 *  将16进制字符串转换成UIColor  e.g. #ffffff
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)color;

@end
