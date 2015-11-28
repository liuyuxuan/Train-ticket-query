//
//  YXTrainTimeCell.m
//  火车票
//
//  Created by 刘雨轩 on 15/10/16.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#import "YXTrainTimeCell.h"
#import "YXTrainTime.h"
@interface YXTrainTimeCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *staTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *mileageLab;

@end
@implementation YXTrainTimeCell

- (instancetype)init
{
    return [[[NSBundle mainBundle]loadNibNamed:@"YXTrainTimeCell" owner:nil options:nil] lastObject];
}

- (void)setTrainTime:(YXTrainTime *)trainTime
{
    _trainTime = trainTime;
    self.nameLab.text = trainTime.name;
    self.staTimeLab.text = trainTime.staTime;
    self.endTimeLab.text = trainTime.endTime;
    self.timeLab.text = trainTime.useTime;
    self.mileageLab.text = trainTime.mileage;
}

@end
