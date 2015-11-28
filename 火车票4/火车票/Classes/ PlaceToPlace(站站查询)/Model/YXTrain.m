//
//  YXTrain.m
//  火车票
//
//  Created by 刘雨轩 on 15/10/10.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#import "YXTrain.h"

@implementation YXTrain

+ (instancetype)trainWithDict:(NSDictionary *)dict
{
    YXTrain *train = [[self alloc]init];
    train.number = dict[@"station_train_code"];
    train.staPlace = dict[@"from_station_name"];
    train.endPlace = dict[@"to_station_name"];
    train.useTime = [NSString stringWithFormat:@"历时:%@",dict[@"lishi"]];
    train.staTime = dict[@"start_time"];
    train.endTime = dict[@"arrive_time"];
    return train;
}

@end
