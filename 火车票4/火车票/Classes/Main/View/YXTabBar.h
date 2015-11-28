//
//  YXTabBar.h
//  彩票
//
//  Created by 刘雨轩 on 15/9/21.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YXTabBar;
@protocol YXTabBarDelegate <NSObject>

@optional
- (void)TabBar:(YXTabBar *)tabBar selectedButtonIndex:(NSInteger)index;
@end
@interface YXTabBar : UIView

@property(nonatomic,weak)id<YXTabBarDelegate> delegate;  /**< 代理*/
@end
