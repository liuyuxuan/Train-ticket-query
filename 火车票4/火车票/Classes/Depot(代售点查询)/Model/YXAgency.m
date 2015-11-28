//
//  YXAgency.m
//  火车票
//
//  Created by 刘雨轩 on 15/10/13.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#import "YXAgency.h"

@implementation YXAgency

+ (instancetype)agencyWithDict:(NSDictionary *)dict
{
    YXAgency *agency = [[self alloc]init];
    agency.address = [NSString stringWithFormat:@"%@",dict[@"address"]];
    agency.agencyName = [NSString stringWithFormat:@"代售点名称: %@",dict[@"agency_name"]];
    agency.phone = [NSString stringWithFormat:@"联系电话: %@",dict[@"phone_no"]];
    agency.windowsNumber = [NSString stringWithFormat:@"窗口数量:   %@",dict[@"windows_quantity"]];
    //时间格式转换
    NSMutableString *am = [NSMutableString stringWithString:dict[@"start_time_am"]];
 
    [am insertString:@":" atIndex:2];
    NSMutableString *pm = [NSMutableString stringWithString:dict[@"stop_time_pm"]];
    [pm insertString:@":" atIndex:2];
    agency.time = [NSString stringWithFormat:@"营业时间: %@ - %@",am,pm];
    return agency;
}
@end
