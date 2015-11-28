//
//  YXTrainTime.m
//  火车票
//
//  Created by 刘雨轩 on 15/10/16.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#import "YXTrainTime.h"

@implementation YXTrainTime
+ (instancetype)trainTimeWithDict:(NSDictionary *)dict
{
    YXTrainTime *trainT = [[YXTrainTime alloc]init];
    trainT.name = dict[@"name"];
    trainT.staTime = dict[@"staTime"];
    trainT.endTime = dict[@"endTime"];
    trainT.useTime = dict[@"useTime"];
    trainT.day = dict[@"day"];
    trainT.mileage = dict[@"mileage"];
    trainT.stopTime = dict[@"stopTime"];
    return trainT;
}

@end
