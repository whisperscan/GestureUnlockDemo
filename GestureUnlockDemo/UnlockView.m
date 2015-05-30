//
//  UnlockView.m
//  GestureUnlockDemo
//
//  Created by caramel on 5/25/15.
//  Copyright (c) 2015 caramel. All rights reserved.
//

#import "UnlockView.h"

@interface UnlockView ()

@property (strong, nonatomic) NSMutableArray *selectedButtonArr;
@property (assign, nonatomic) CGPoint currPoint;
@end

@implementation UnlockView

#pragma mark - 数组懒加载

- (NSMutableArray *)selectedButtonArr
{
    if(_selectedButtonArr == nil)
    {
        _selectedButtonArr = [NSMutableArray array];
    }
    
    return _selectedButtonArr;
}

#pragma mark - 添加view上的按钮

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        for(NSInteger i = 0;i < 9;++i)
        {
            UIButton *button = [[UIButton alloc]init];
            
            // 设置按键不能进行用户交互，让其父view处理触摸事件
            button.userInteractionEnabled = NO;
            
            [button setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];

            // 添加标记
            button.tag = i;
//            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
            
            [self addSubview:button];
        }
    }
    
    return self;
}

//- (void)buttonClick:(UIButton *)button
//{
//    button.selected = YES;
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat btnWH = 74;
    NSInteger totalCol = 3;
    CGFloat marginW = (self.bounds.size.width - (btnWH * totalCol)) / (totalCol + 1);
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = btnWH;
    CGFloat btnH = btnWH;
    
    CGFloat col = 0;
    CGFloat row = 0;
    
    for(NSInteger i = 0;i < self.subviews.count;++i)
    {
        col = i % totalCol;
        row = i / totalCol;
        btnX = marginW + (marginW + btnWH) * col;
        btnY = marginW + (marginW + btnWH) * row;
        
        UIButton * button = self.subviews[i];
        
        button.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}


#pragma mark - 添加触摸事件

- (void)selectedButtonWithTouch:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    
    CGPoint currPoint = [touch locationInView:self];
    
    // 缩小按钮触摸区域
    CGFloat deltaWH = 30;
    CGRect frame;
    CGFloat x = 0;
    CGFloat y = 0;
    
    for(UIButton *button in self.subviews)
    {
        x = button.center.x - deltaWH * 0.5;
        y = button.center.y - deltaWH * 0.5;
        
        frame = CGRectMake(x, y, deltaWH, deltaWH);
        
        if(CGRectContainsPoint(frame, currPoint) && (button.selected == NO))
        {
            // 所按的点在按键中，设置按键为选中
            button.selected = YES;
            
            // 添加选中按键到数组中
            [self.selectedButtonArr addObject:button];
        
        }
    }
    
    // 更新当前点
    self.currPoint = currPoint;
    
    // 添加刷新标记
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self selectedButtonWithTouch:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self selectedButtonWithTouch:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSMutableString *str = [NSMutableString string];
    
    for(UIButton *button in self.selectedButtonArr)
    {
        [str appendFormat:@"%ld",button.tag];
    }
    
    [self.selectedButtonArr makeObjectsPerformSelector:@selector(setSelected:) withObject:0];
    
    [self.selectedButtonArr removeAllObjects];
    
    [self setNeedsDisplay];
    
    // 打印用户路径
//    NSLog(@"%@",str);
    
    // 调用代理
    if([self.delegate respondsToSelector:@selector(unlockViewDidFinishWith:)])
    {
        [self.delegate unlockViewDidFinishWith:str];
    }
}

#pragma mark - 画线

- (void)drawRect:(CGRect)rect
{
    if(!self.selectedButtonArr.count)   return;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for(NSInteger i = 0;i < self.selectedButtonArr.count;++i)
    {
        UIButton *button = self.selectedButtonArr[i];
        if(i == 0)
        {
            [path moveToPoint:button.center];
        }
        else
        {
            [path addLineToPoint:button.center];
        }
    }
    
    // 添加手指当前的点
    [path addLineToPoint:self.currPoint];
    
    // 设置路径属性
    path.lineWidth = 10;
    path.lineJoinStyle = kCGLineJoinRound;
    [[UIColor greenColor] setStroke];
    
    [path stroke];
}

@end
