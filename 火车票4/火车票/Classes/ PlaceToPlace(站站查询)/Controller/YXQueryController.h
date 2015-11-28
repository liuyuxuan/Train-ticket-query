//
//  YXQueryController.h
//  火车票
//
//  Created by 刘雨轩 on 15/10/5.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXQueryController : UIViewController
@property(nonatomic,strong)NSDictionary *staDict;  //第一个城市的字典
@property(nonatomic,strong)NSDictionary *endDict;  //第二个城市的字典
@property(nonatomic,assign)BOOL isStudents;  /**< 学生票*/
@property(nonatomic,assign)BOOL isSpeed;  /**< 高铁*/
@property(nonatomic,strong)NSDate *date;  /**< 当前日期*/
@end
