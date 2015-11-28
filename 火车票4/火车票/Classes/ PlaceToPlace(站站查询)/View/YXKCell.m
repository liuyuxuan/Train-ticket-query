//
//  YXKCell.m
//  火车票
//
//  Created by 刘雨轩 on 15/10/9.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#import "YXKCell.h"
#import "YXKTrain.h"
#import "UIView+Frame.h"
@interface YXKCell()
@property (weak, nonatomic) IBOutlet UILabel *numberLab; //车次
@property (weak, nonatomic) IBOutlet UILabel *staPlaceLab;   //起始地
@property (weak, nonatomic) IBOutlet UILabel *endPlaceLab;   //目的地
@property (weak, nonatomic) IBOutlet UILabel *useTimeLab;   //历时
@property (weak, nonatomic) IBOutlet UILabel *staTimeLab;   //开车时间
@property (weak, nonatomic) IBOutlet UILabel *endTimeLab;   //到达时间
@property (weak, nonatomic) IBOutlet UILabel *rwSeatLab;   //软卧
@property (weak, nonatomic) IBOutlet UILabel *ywSeatLab;   //硬卧
@property (weak, nonatomic) IBOutlet UILabel *yzSeatLab;   //硬座
@property (weak, nonatomic) IBOutlet UILabel *wzSeatLab;   //无座


@end

@implementation YXKCell

- (void)setKTrain:(YXKTrain *)kTrain
{
    _kTrain = kTrain;
    //设置数据
    [self.numberLab setText:kTrain.number];
    [self.numberLab sizeToFit];
    [self.staPlaceLab setText:kTrain.staPlace];
    [self.staPlaceLab sizeToFit];
    [self.endPlaceLab setText:kTrain.endPlace];
    [self.endPlaceLab sizeToFit];
    [self.useTimeLab setText:kTrain.useTime];
    [self.useTimeLab sizeToFit];
    [self.staTimeLab setText:kTrain.staTime];
    [self.staTimeLab sizeToFit];
    [self.endTimeLab setText:kTrain.endTime];
    [self.endTimeLab sizeToFit];
    
    //软卧
    [self.rwSeatLab setText:kTrain.rwSeat];
    [self.rwSeatLab sizeToFit];
    if ([kTrain.rwSeat isEqualToString:@"--"]||[kTrain.rwSeat isEqualToString:@"无"]) {
        [self.rwSeatLab setTextColor:[UIColor grayColor]];
    }else
    {
        [self.rwSeatLab setTextColor:[UIColor redColor]];
    }
    //硬卧
    [self.ywSeatLab setText:kTrain.ywSeat];
    [self.ywSeatLab sizeToFit];
    if ([kTrain.ywSeat isEqualToString:@"--"]||[kTrain.ywSeat isEqualToString:@"无"]) {
        [self.ywSeatLab setTextColor:[UIColor grayColor]];
    }else
    {
        [self.ywSeatLab setTextColor:[UIColor redColor]];
    }
    //硬座
    [self.yzSeatLab setText:kTrain.yzSeat];
    [self.yzSeatLab sizeToFit];
    if ([kTrain.yzSeat isEqualToString:@"--"]||[kTrain.yzSeat isEqualToString:@"无"]) {
        [self.yzSeatLab setTextColor:[UIColor grayColor]];
    }else
    {
        [self.yzSeatLab setTextColor:[UIColor redColor]];
    }
    //无座
    [self.wzSeatLab setText:kTrain.wzSeat];
    [self.wzSeatLab sizeToFit];
    if ([kTrain.wzSeat isEqualToString:@"--"]||[kTrain.wzSeat isEqualToString:@"无"]) {
        [self.wzSeatLab setTextColor:[UIColor grayColor]];
    }else
    {
        [self.wzSeatLab setTextColor:[UIColor redColor]];
    }
}

- (instancetype)init
{
    YXKCell *cell = [[NSBundle mainBundle] loadNibNamed:@"YXKCell" owner:nil options:nil].lastObject;
    cell.width = [UIScreen mainScreen].bounds.size.width;
    cell.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 71);
    //取消选中状态
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
