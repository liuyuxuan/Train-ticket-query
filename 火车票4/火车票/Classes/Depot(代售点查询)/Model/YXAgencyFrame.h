//
//  YXAgencyFrame.h
//  火车票
//
//  Created by 刘雨轩 on 15/10/13.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#define textFont [UIFont systemFontOfSize:14]

#import <UIKit/UIKit.h>
@class YXAgency;
@interface YXAgencyFrame : NSObject
@property (nonatomic,assign,readonly) CGRect addressF;  /**< 地址*/
@property (nonatomic,assign,readonly) CGRect agencyNameF;  /**< 代理店名称*/
@property (nonatomic,assign,readonly) CGRect phoneF;  /**< 电话*/
@property (nonatomic,assign,readonly) CGRect timeF;  /**< 上班时间*/
@property (nonatomic,assign,readonly) CGRect windowsNumberF;  /**< 窗口数量*/

@property (nonatomic,assign,readonly) CGFloat cellHeight;

@property(nonatomic,strong)YXAgency *agency;  /**< 属于自己的对应代理店*/

- (instancetype)initWithAgency:(YXAgency *)agency;
@end
