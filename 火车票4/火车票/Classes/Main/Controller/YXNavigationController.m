//
//  YXNavigationController.m
//  火车票
//
//  Created by 刘雨轩 on 15/10/3.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#import "YXNavigationController.h"
#import "UIView+Frame.h"
#import "UIImage+YXImage.h"
@interface YXNavigationController ()<UINavigationControllerDelegate>
@property (nonatomic, strong) id popDelegate;
@end

@implementation YXNavigationController

#pragma mark   设置导航栏的背景和字体属性
#pragma ----------------------------

+ (void)initialize{
    if (self == [YXNavigationController class]) {
        //获取当前类下面的导航条
//    
        UINavigationBar *nBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
//        nBar.frame = CGRectMake(100, 100, 22, 100);
        //图片拉伸
        UIImage *image = [UIImage imageNamed:@"naviBar"];
        image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
        [nBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];

        //这是导航栏标题颜色
        NSMutableDictionary *attr = [NSMutableDictionary dictionary];
        attr[NSFontAttributeName] = [UIFont boldSystemFontOfSize:17];
        attr[NSForegroundColorAttributeName] = [UIColor whiteColor];
        nBar.titleTextAttributes = attr;
    }
}


#pragma mark - push的利用,设置返回按钮
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{

    [super pushViewController:viewController animated:animated];
    if (self.childViewControllers.count > 1) {     //非跟控制器
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageWithOriginalImageNamed:@"NavBack"] style:0 target:self action:@selector(back)];
    }
}
//pop
- (void)back
{
    [self popViewControllerAnimated:YES];
}
#pragma mark -UINavigationControllerDelegate  //假死处理
// 导航控制器显示一个控制器完成的时候就会调用
- (void)navigationController:(nonnull UINavigationController *)navigationController didShowViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self.childViewControllers[0]) {
        // 回到根控制器
        self.interactivePopGestureRecognizer.delegate = _popDelegate;
    }
    else{ // 不是根控制器
        self.interactivePopGestureRecognizer.delegate = nil;
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
       // 1.恢复滑动返回功能:清空滑动手势代理
    _popDelegate = self.interactivePopGestureRecognizer.delegate;
    
    // 设置导航控制器的代理,监听导航控制器什么时候回到根控制器
    self.delegate = self;
    
    
}
@end
