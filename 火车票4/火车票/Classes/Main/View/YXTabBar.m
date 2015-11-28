//
//  YXTabBar.m
//  彩票
//
//  Created by 刘雨轩 on 15/9/21.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#define TabBarItemsNumber 3
#import "YXTabBar.h"
#import "YXButton.h"
#import "UIImage+YXImage.h"
@interface YXTabBar()
@property(nonatomic,strong)NSArray *array;
@property(nonatomic,strong)YXButton *btn;  /**< */
@end
@implementation YXTabBar
#pragma tabbar的文字
- (NSArray *)array
{
    if (!_array) {
        _array = [NSArray arrayWithObjects:@"站站查询",@"代售点查询",@"车次查询", nil];
    }
    return _array;
}

//创建的时候给自己添加子控件
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
      
    //创建按钮
    for (int i = 0;i<TabBarItemsNumber;i++) {
        YXButton *btn = [YXButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:self.array[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithWhite:0.6 alpha:1] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.tag = i;
        //添加监听事件
        [btn addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:btn];
    }
    }
    return self;
    
}

- (void)touchBtn:(YXButton *)btn
{
    //三部曲交换选中状态
    self.btn.selected = NO;
    btn.selected = YES;
    self.btn = btn;
    //通知代理切换界面
    if ([self.delegate respondsToSelector:@selector(TabBar:selectedButtonIndex:)]) {
        [self.delegate TabBar:self selectedButtonIndex:btn.tag];
    }
    
    
}
#pragma mark   给子控制器设置属性
#pragma ----------------------------
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = self.bounds.size.width / TabBarItemsNumber;
    CGFloat btnH = self.bounds.size.height;
    for (int i = 0;i < self.subviews.count; i ++) {
        YXButton *btn = self.subviews[i];
        btnX = i * btnW;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [btn setBackgroundImage:[self imageWithColor:[UIColor colorWithWhite:0.04 alpha:1] andSize:btn.frame] forState:UIControlStateNormal];
        [btn setBackgroundImage:[self imageWithColor:[UIColor colorWithWhite:0.14 alpha:1] andSize:btn.frame] forState:UIControlStateSelected];
        //默认选中第0个按钮
        if(i == 0)
        {
            [self touchBtn:btn];
            btn.selected = YES;
            self.btn = btn;
        }
    }
}

#pragma mark   根据颜色生成一张图片
#pragma ----------------------------
- (UIImage *)imageWithColor:(UIColor *)color andSize:(CGRect)frame
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = color;
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
   
    UIGraphicsEndImageContext();
    return image;
}

@end
