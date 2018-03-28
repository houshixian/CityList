//
//  JJTableViewIndexView.m
//  WDNewGraduate
//
//  Created by WDhsx on 2017/9/21.
//  Copyright © 2017年 Wendu Group. All rights reserved.
//


#import "JJTableViewIndexView.h"


@implementation JJTableViewIndexView
#pragma mark - 实例化方法
- (instancetype)initWithFrame:(CGRect)frame IndexNameArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        //通过实例化参数,赋值给类属性
        self.IndexNameArray = [NSArray arrayWithArray:array];
     
        CGFloat Height = 10 + 7;
        
        //遍历数组
        for (int i = 0; i < self.IndexNameArray.count; i ++)
        {
            
            
            UILabel *Label = [[UILabel alloc]init];
            
            if (i == 0) {
            Label.frame = CGRectMake(0,  i * Height, self.frame.size.width, 14);
            }else{
            
            Label.frame = CGRectMake((self.width - 14)/2,  i * Height, 14, 14);
            }
            
            
            Label.layer.masksToBounds = YES;
            //        //圆角
            Label.layer.cornerRadius = 7.0f;
            Label.text = self.IndexNameArray[i];
            Label.textColor = BRmainColor;
            Label.font = [UIFont systemFontOfSize:10];
            Label.textAlignment = NSTextAlignmentCenter;
            Label.tag = TAG + i;
            [self addSubview:Label];
            

        }
        [self addSubview:self.BlistImage];
        [self addSubview:self.CenterLabel];
       

    }
    
    return self;
}


- (UIImageView *)BlistImage{

    if (!_BlistImage) {
        
        UIImage *image = [UIImage imageNamed:@"search_slide"];
        
        _BlistImage = [[UIImageView alloc]initWithImage:image];
        
        _BlistImage.frame = CGRectMake(-image.size.width + 4 , 100, image.size.width ,image.size.height);
        _BlistImage.alpha = 0;
    }
    return _BlistImage;
}


- (UILabel *)CenterLabel{


    if (!_CenterLabel) {
        _CenterLabel = [[UILabel alloc]init];
        
        _CenterLabel.frame = CGRectMake(_BlistImage.orign.x + 16, 100, 60, 60);
        _CenterLabel.centerY = _BlistImage.centerY;
        _CenterLabel.textAlignment = NSTextAlignmentLeft;
        _CenterLabel.backgroundColor = [UIColor clearColor];
        _CenterLabel.font = [UIFont systemFontOfSize:30];
        _CenterLabel.textColor = [UIColor whiteColor];

        //将视图隐藏,刚开始本应该隐藏
        _CenterLabel.alpha = 0;

        
        
    }

return _CenterLabel;

}


#pragma mark - 中心视图的数据源方法
-(void)centerImageShowViewWithSection:(NSInteger)section
{
    self.selectedBlock(section);
    _CenterLabel.text = self.IndexNameArray[section];
    _CenterLabel.alpha = 1.0;
    _BlistImage.alpha = 1.0;

}

#pragma mark - 手势结束
-(void)panAnimationFinish
{

    
    [UIView animateWithDuration:1 animations:^{
        

        self.CenterLabel.alpha = 0;
        self.BlistImage.alpha = 0;
    }];
}

#pragma mark - 手势开始
-(void)panAnimationBeginWithToucher:(NSSet<UITouch *> *)touches
{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];

//    CGFloat hh = 10 + 7;
    for (int i = 0; i < self.IndexNameArray.count; i ++)
    {
        UILabel * NewLabel = (UILabel *)[self viewWithTag:TAG + i];

        if (fabs(NewLabel.center.y - point.y) <= ANIMATION_RADIUS)
        {
            [UIView animateWithDuration:0.2 animations:^{
                
       
                
                if (fabs(NewLabel.center.y - point.y) * ALPHA_RATE <= 0.08)
                {
               
                    
                    self.BlistImage.centerY = NewLabel.centerY;
                    self.CenterLabel.centerY = self.BlistImage.centerY;
                    NewLabel.alpha = 1.0;
                    if (i == 0) {
                        
                    }else{
                    [self centerImageShowViewWithSection:i];
                    }
                    
                    
                    for (int j = 0; j < self.IndexNameArray.count; j ++)
                    {
                        UILabel * MostNewLabel = (UILabel *)[self viewWithTag:TAG + j];
                        if (i == j)
                        {
                            if (i == 0) {
                                MostNewLabel.backgroundColor = [UIColor clearColor];
                                MostNewLabel.textColor = BRmainColor;
                            }else{
                                
                                MostNewLabel.backgroundColor = BRmainColor;
                                MostNewLabel.textColor = [UIColor whiteColor];
                            }
                           

                        }else{
                        
                            MostNewLabel.textColor = BRmainColor;
                            MostNewLabel.backgroundColor = [UIColor clearColor];
                        
                        }
                    }
                }
            }];
            
        }
//        else
//        {
//            [UIView animateWithDuration:0.2 animations:^
//             {
//                 imageView.center = CGPointMake(self.frame.size.width/2, i * hh + hh/2);
//                 imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, self.frame.size.width, self.frame.size.width);
//                 imageView.alpha = 1.0;
//             }];
//        }
    }
}


#pragma mark - 点击事件
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self panAnimationBeginWithToucher:touches];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self panAnimationBeginWithToucher:touches];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self panAnimationFinish];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self panAnimationFinish];
}


#pragma mark - 选中索引的回调
-(void)selectIndexBlock:(MyBlock)block
{
    self.selectedBlock = block;
}

@end
