//
//  YXGTrain.m
//  火车票
//
//  Created by 刘雨轩 on 15/10/10.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#import "YXGTrain.h"

@implementation YXGTrain

+ (instancetype)gTrainWithDict:(NSDictionary *)dict
{
    YXGTrain *train = [self trainWithDict:dict];
    train.swSeat = dict[@"swz_num"];
    train.ydSeat = dict[@"zy_num"];
    train.edSeat = dict[@"ze_num"];
    train.wzSeat = dict[@"wz_num"];

    
    return train;
}

@end
