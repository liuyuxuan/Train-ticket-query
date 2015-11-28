//
//  YXGTrain.h
//  火车票
//
//  Created by 刘雨轩 on 15/10/10.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#import "YXTrain.h"

@interface YXGTrain : YXTrain

@property(nonatomic,strong)NSString *swSeat;  /**< 商务*/
@property(nonatomic,strong)NSString *ydSeat;  /**< 一等座*/
@property(nonatomic,strong)NSString *edSeat;  /**< 二等座*/
@property(nonatomic,strong)NSString *wzSeat;  /**< 无座*/

+ (instancetype)gTrainWithDict:(NSDictionary *)dict;
@end
