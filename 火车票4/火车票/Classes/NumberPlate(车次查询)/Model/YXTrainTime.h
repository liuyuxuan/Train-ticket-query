//
//  YXTrainTime.h
//  火车票
//
//  Created by 刘雨轩 on 15/10/16.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXTrainTime : NSObject

@property(nonatomic,strong)NSString *name;  /**< 站点名称*/
@property(nonatomic,strong)NSString *staTime;  /**< 开始时间*/
@property(nonatomic,strong)NSString *endTime;  /**< 结束时间*/
@property(nonatomic,strong)NSString *stopTime;  /**< 停车时间*/
@property(nonatomic,strong)NSString *useTime;  /**< 全程总耗时*/
@property(nonatomic,strong)NSString *mileage;  /**< 里程*/
@property(nonatomic,strong)NSString *day;  /**< 当前是第几天*/

+ (instancetype)trainTimeWithDict:(NSDictionary *)dict;
@end

