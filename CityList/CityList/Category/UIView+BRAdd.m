//
//  UIView+BRAdd.m
//  BoRuoBoLuoMi
//
//  Created by ZhaoYan on 2017/5/3.
//  Copyright © 2017年 ZhaoYan. All rights reserved.
//

#import "UIView+BRAdd.h"

@implementation UIView (BRAdd)

- (UIViewController *)viewController
{
    UIResponder *next = self.nextResponder;
    
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        
        next = next.nextResponder;
    } while (next);
    
    return nil;
}

- (UINavigationController *)navigationController
{
    UIResponder *next = self.nextResponder;
    
    do {
        if ([next isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)next;
        }
        
        next = next.nextResponder;
    } while (next);
    
    return nil;
}

- (UITabBarController *)tabBarController
{
    UIResponder *next = self.nextResponder;
    
    do {
        if ([next isKindOfClass:[UITabBarController class]]) {
            return (UITabBarController *)next;
        }
        
        next = next.nextResponder;
    } while (next);
    
    return nil;
}

@end
