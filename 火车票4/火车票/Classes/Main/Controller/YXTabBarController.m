//
//  YXTabBarController.m
//  火车票
//
//  Created by 刘雨轩 on 15/10/3.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#import "YXTabBarController.h"
#import "YXTabBar.h"
@interface YXTabBarController ()<YXTabBarDelegate>

@end

@implementation YXTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    //给状态栏添加一个背景颜色
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375, 20)];
    view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.view addSubview:view];
    //设置tabbar
    [self setTabBar];

}

#pragma mark - 自定义导航条
- (void)setTabBar
{
    self.tabBar.backgroundColor = [UIColor blackColor];
    //创建自定义tabbar
    YXTabBar *tabBar = [[YXTabBar alloc]initWithFrame:self.tabBar.bounds];
    tabBar.delegate = self;
 
    [self.tabBar addSubview:tabBar];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //删除系统的tabbar里面的系统子控件
    for (UIView *view in self.tabBar.subviews) {
        if (![view isKindOfClass:[YXTabBar class]]) {
            [view removeFromSuperview];
        }
    }
}

#pragma mark - 自定义tabbar的代理方法
- (void)TabBar:(YXTabBar *)tabBar selectedButtonIndex:(NSInteger)index
{
    self.selectedIndex = index;
}


@end
