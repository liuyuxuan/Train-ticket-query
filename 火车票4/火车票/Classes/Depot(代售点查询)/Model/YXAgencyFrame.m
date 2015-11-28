//
//  YXAgencyFrame.m
//  火车票
//
//  Created by 刘雨轩 on 15/10/13.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#define MainScreenH [UIScreen mainScreen].bounds.size.width
#define IntervalNumber 10
#define  TextNormalH 21
#import "YXAgencyFrame.h"
#import "YXAgency.h"
@implementation YXAgencyFrame

- (instancetype)initWithAgency:(YXAgency *)agency
{
    if (self = [super init]) {
        _agency = agency;
        [self setCellFrame];
    }
    return self;
}

- (void)setCellFrame
{
    
    //名称
    CGFloat agencyNameX = IntervalNumber * 3;
    CGFloat agencyNameY = IntervalNumber;
    CGFloat agencyNameW = MainScreenH - 6 * IntervalNumber;
    CGSize agencyNameSize = [_agency.agencyName sizeWithFont:textFont constrainedToSize:CGSizeMake(agencyNameW, MAXFLOAT)];
    
    
    _agencyNameF = CGRectMake(agencyNameX, agencyNameY, agencyNameSize.width, agencyNameSize.height);
    
    //上班时间
    CGFloat timeY = CGRectGetMaxY(_agencyNameF) + IntervalNumber;
    _timeF= CGRectMake(agencyNameX, timeY, agencyNameW, TextNormalH);
    
    //窗口数量
    CGFloat windowsNumberY = CGRectGetMaxY(_timeF) + IntervalNumber;
    _windowsNumberF = CGRectMake(agencyNameX, windowsNumberY, agencyNameW, TextNormalH);
    
    //电话
    if(![self.agency.phone isEqualToString:@"联系电话: --"])
    {
        CGFloat phoneY = CGRectGetMaxY(_windowsNumberF) + IntervalNumber;
        _phoneF = CGRectMake(agencyNameX, phoneY, agencyNameW, TextNormalH);
    }
    
    //地址
    CGFloat addressY = MAX(CGRectGetMaxY(_phoneF), CGRectGetMaxY(_windowsNumberF)) + IntervalNumber;
    NSString *address = [NSString stringWithFormat:@"地址: %@",_agency.address];
    CGSize addressSize = [address sizeWithFont:textFont constrainedToSize:CGSizeMake(agencyNameW, MAXFLOAT)];
    _addressF = CGRectMake(agencyNameX, addressY, addressSize.width, addressSize.height);

    _cellHeight =CGRectGetMaxY(_addressF) + IntervalNumber;
//    NSLog(@"%f",_cellHeight);
}

@end
