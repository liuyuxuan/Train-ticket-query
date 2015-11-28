//
//  YXTrain.h
//  火车票
//
//  Created by 刘雨轩 on 15/10/10.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXTrain : NSObject

@property(nonatomic,strong)NSString *number;  /**< 车次*/
@property(nonatomic,strong)NSString *staPlace;  /**< 起始车站*/
@property(nonatomic,strong)NSString *endPlace;  /**< 目的车站*/
@property(nonatomic,strong)NSString *useTime;  /**< 历时*/
@property(nonatomic,strong)NSString *staTime;  /**< 起始时间*/
@property(nonatomic,strong)NSString *endTime;  /**< 结束时间*/

+ (instancetype)trainWithDict:(NSDictionary *)dict;

@end
