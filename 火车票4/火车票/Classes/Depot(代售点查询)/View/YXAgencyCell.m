//
//  YXAgencyCell.m
//  火车票
//
//  Created by 刘雨轩 on 15/10/13.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#import "YXAgencyCell.h"
#import "YXAgencyFrame.h"
#import "YXAgency.h"
@implementation YXAgencyCell
{
    UILabel *agencyNameLab;
    UILabel *addressLab;
    UILabel *timeLab;
    UILabel *phoneLab;
    UILabel *windowsNumberLab;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        agencyNameLab = [[UILabel alloc]init];
        [self.contentView addSubview:agencyNameLab];
        addressLab = [[UILabel alloc]init];
        [self.contentView addSubview:addressLab];
        timeLab = [[UILabel alloc]init];
        [self.contentView addSubview:timeLab];
        phoneLab = [[UILabel alloc]init];
        [self.contentView addSubview:phoneLab];
        windowsNumberLab = [[UILabel alloc]init];
        [self.contentView addSubview:windowsNumberLab];
        
        //取消选中状态
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setAgencyFrame:(YXAgencyFrame *)agencyFrame
{
    _agencyFrame = agencyFrame;
    [self setData];
    [self setCellFrame];
}

- (void)setData
{
    YXAgency *agency = self.agencyFrame.agency;
    
    agencyNameLab.text = agency.agencyName;
    agencyNameLab.font = textFont;
    agencyNameLab.numberOfLines = 0;
    
    NSString *address = [NSString stringWithFormat:@"地址: %@",agency.address];
    addressLab.text = address;
    addressLab.font = textFont;
    addressLab.numberOfLines = 0;
    
    phoneLab.text = agency.phone;
    phoneLab.font = textFont;
    
    windowsNumberLab.text = agency.windowsNumber;
    windowsNumberLab.font = textFont;
    
    timeLab.text = agency.time;
    timeLab.font = textFont;
}

- (void)setCellFrame
{
    agencyNameLab.frame = self.agencyFrame.agencyNameF;
     addressLab.frame = self.agencyFrame.addressF;
     phoneLab.frame = self.agencyFrame.phoneF;
     windowsNumberLab.frame = self.agencyFrame.windowsNumberF;
     timeLab.frame = self.agencyFrame.timeF;
}
@end
