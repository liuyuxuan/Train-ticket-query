//
//  YXKTrain.h
//  火车票
//
//  Created by 刘雨轩 on 15/10/10.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#import "YXTrain.h"

@interface YXKTrain : YXTrain
@property(nonatomic,strong)NSString *rwSeat;  /**< 软卧*/
@property(nonatomic,strong)NSString *ywSeat;  /**< 硬卧*/
@property(nonatomic,strong)NSString *yzSeat;  /**< 硬座*/
@property(nonatomic,strong)NSString *wzSeat;  /**< 无座*/
+ (instancetype)kTrainWithDict:(NSDictionary *)dict;
@end
