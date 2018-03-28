//
//  JJTableViewIndexView.h
//  WDNewGraduate
//
//  Created by WDhsx on 2017/9/21.
//  Copyright © 2017年 Wendu Group. All rights reserved.
//

#import <UIKit/UIKit.h>

//索引label的tag值(防止冲突)
#define TAG 1024
//动画的半径
#define ANIMATION_RADIUS 80
//透明度变化率
#define ALPHA_RATE 1/80
typedef void (^MyBlock)(NSInteger);

@interface JJTableViewIndexView : UIView
#pragma mark - 属性
/**
 数据数组
 */
@property (nonatomic,strong) NSArray * IndexNameArray;

/**
 动画视图(可自定义)
 */
//@property (nonatomic,strong) UIImageView * centerImageShowView;


@property(nonatomic,strong)UILabel *CenterLabel;

@property(nonatomic,strong)UIImageView *BlistImage;



/**
 滑动回调block
 */
@property (nonatomic,copy) MyBlock selectedBlock;

#pragma mark - 方法
/**
 *  index滑动反馈
 */
-(void)selectIndexBlock:(MyBlock)block;

/**
 实例化方法
 */
- (instancetype)initWithFrame:(CGRect)frame IndexNameArray:(NSArray *)array;

@end
