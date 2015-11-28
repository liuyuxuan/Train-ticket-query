//
//  YXKTrain.m
//  火车票
//
//  Created by 刘雨轩 on 15/10/10.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#import "YXKTrain.h"

@implementation YXKTrain

+ (instancetype)kTrainWithDict:(NSDictionary *)dict
{
    
    YXKTrain *train = [self trainWithDict:dict];
    train.rwSeat = dict[@"rw_num"];
    train.ywSeat = dict[@"yw_num"];
    train.yzSeat = dict[@"yz_num"];
    train.wzSeat = dict[@"wz_num"];
    return train;
}
@end
