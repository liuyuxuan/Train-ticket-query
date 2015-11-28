//
//  YXAgency.h
//  火车票
//
//  Created by 刘雨轩 on 15/10/13.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXAgency : NSObject

@property(nonatomic,strong)NSString *address;  /**< 地址*/
@property(nonatomic,strong)NSString *agencyName;  /**< 代理店名称*/
@property(nonatomic,strong)NSString *phone;  /**< 电话*/
@property(nonatomic,strong)NSString *time;  /**< 上班时间*/
@property(nonatomic,strong)NSString *windowsNumber;  /**< 窗口数量*/

+ (instancetype)agencyWithDict:(NSDictionary *)dict;

@end
