//
//  JJTableViewIndexView.m
//  索引
//
//  Created by 欧家俊 on 16/12/21.
//  Copyright © 2016年 欧家俊. All rights reserved.
//

#import "JJTableViewIndexView.h"
//屏幕宽高
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation JJTableViewIndexView
#pragma mark - 实例化方法
- (instancetype)initWithFrame:(CGRect)frame imageNameArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        //通过实例化参数,赋值给类属性
        self.imageNameArray = [NSArray arrayWithArray:array];
        //通过数据的长度,获取image的高度
        CGFloat imageHeight = self.frame.size.height/self.imageNameArray.count;
        //遍历数组
        for (int i = 0; i < self.imageNameArray.count; i ++)
        {
            //生成图片视图
            UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.imageNameArray[i]]];
            //设置坐标大小
            imageView.frame =CGRectMake(0, i * imageHeight, self.frame.size.width, self.frame.size.width);
            //设置tag
            imageView.tag = TAG + i;
            //添加到视图
            [self addSubview:imageView];
            //允许交互
            imageView.userInteractionEnabled = YES;
        }
        
        
        [self addSubview:self.centerImageShowView];
    }
    
    return self;
}

#pragma mark - 懒加载 中心视图
- (UIImageView *)centerImageShowView{
    if (!_centerImageShowView)
    {
        //设置中心提示视图的坐标大小
        //        _animationLabel = [[UILabel alloc]initWithFrame:CGRectMake(-WIDTH/2 + self.frame.size.width/2, 100, 60, 60)];
        _centerImageShowView = [[UIImageView alloc]init];
        _centerImageShowView.frame = CGRectMake(-WIDTH/2 + self.frame.size.width/2, 100, 60, 60);
        //遮罩
        _centerImageShowView.layer.masksToBounds = YES;
        //圆角
        _centerImageShowView.layer.cornerRadius = 5.0f;
        //背景颜色
        _centerImageShowView.backgroundColor = [UIColor orangeColor];
        //将视图隐藏,刚开始本应该隐藏
        _centerImageShowView.alpha = 0;
      
    }
    
    return _centerImageShowView;
}

#pragma mark - 中心视图的数据源方法
-(void)centerImageShowViewWithSection:(NSInteger)section
{
    self.selectedBlock(section);
    
    _centerImageShowView.image = [UIImage imageNamed:self.imageNameArray[section]];
    _centerImageShowView.alpha = 1.0;
}

#pragma mark - 手势结束
-(void)panAnimationFinish
{
    CGFloat imageViewHeight = self.frame.size.height/self.imageNameArray.count;
    
    for (int i = 0; i < self.imageNameArray.count; i ++)
    {
        UIImageView * imageView = (UIImageView *)[self viewWithTag:TAG + i];
        
        [UIView animateWithDuration:0.2 animations:^{
            
            imageView.center = CGPointMake(self.frame.size.width/2, i * imageViewHeight + imageViewHeight/2);
            imageView.alpha = 1.0;
            imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, self.frame.size.width, self.frame.size.width);
            
        }];
    }
    
    [UIView animateWithDuration:1 animations:^{
        
        self.centerImageShowView.alpha = 0;
        
    }];
}

#pragma mark - 手势开始
-(void)panAnimationBeginWithToucher:(NSSet<UITouch *> *)touches
{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGFloat hh = self.frame.size.height/self.imageNameArray.count;
    
    for (int i = 0; i < self.imageNameArray.count; i ++)
    {
        UIImageView * imageView = (UIImageView *)[self viewWithTag:TAG + i];
        if (fabs(imageView.center.y - point.y) <= ANIMATION_RADIUS)
        {
            [UIView animateWithDuration:0.2 animations:^{
                
                imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, self.frame.size.width+10, self.frame.size.width+10);
                
                imageView.center = CGPointMake(imageView.bounds.size.width/2 - sqrt(fabs(ANIMATION_RADIUS * ANIMATION_RADIUS - fabs(imageView.center.y - point.y) * fabs(imageView.center.y - point.y))), imageView.center.y);
              
                
                if (fabs(imageView.center.y - point.y) * ALPHA_RATE <= 0.08)
                {
                    //                    label.textColor = MARK_COLOR;
                    imageView.alpha = 1.0;
                    
                    [self centerImageShowViewWithSection:i];
                    
                    for (int j = 0; j < self.imageNameArray.count; j ++)
                    {
                        UIImageView * imageView = (UIImageView *)[self viewWithTag:TAG + j];
                        if (i != j)
                        {
                            imageView.alpha = fabs(imageView.center.y - point.y) * ALPHA_RATE;
                        }
                    }
                }
            }];
            
        }else
        {
            [UIView animateWithDuration:0.2 animations:^
             {
                 imageView.center = CGPointMake(self.frame.size.width/2, i * hh + hh/2);
                 imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, self.frame.size.width, self.frame.size.width);
                 imageView.alpha = 1.0;
             }];
        }
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
