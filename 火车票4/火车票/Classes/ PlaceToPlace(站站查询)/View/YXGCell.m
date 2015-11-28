//
//  YXGCell.m
//  火车票
//
//  Created by 刘雨轩 on 15/10/10.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#import "YXGCell.h"
#import "YXGTrain.h"
#import "UIView+Frame.h"
@interface YXGCell()
@property (weak, nonatomic) IBOutlet UILabel *numberLab; //车次
@property (weak, nonatomic) IBOutlet UILabel *staPlaceLab;   //起始地
@property (weak, nonatomic) IBOutlet UILabel *endPlaceLab;   //目的地
@property (weak, nonatomic) IBOutlet UILabel *useTimeLab;   //历时
@property (weak, nonatomic) IBOutlet UILabel *staTimeLab;   //开车时间
@property (weak, nonatomic) IBOutlet UILabel *endTimeLab;   //到达时间
@property (weak, nonatomic) IBOutlet UILabel *swSeatLab;   //商务座
@property (weak, nonatomic) IBOutlet UILabel *ydSeatLab;   //一等座
@property (weak, nonatomic) IBOutlet UILabel *edSeatLab;   //二等座
@property (weak, nonatomic) IBOutlet UILabel *wzSeatLab;   //无座
@end
@implementation YXGCell

- (void)setGTrain:(YXGTrain *)gTrain
{
    _gTrain = gTrain;
    [self.numberLab setText:gTrain.number];
    [self.numberLab sizeToFit];
    [self.staPlaceLab setText:gTrain.staPlace];
    [self.staPlaceLab sizeToFit];
    [self.endPlaceLab setText:gTrain.endPlace];
    [self.endPlaceLab sizeToFit];
    [self.useTimeLab setText:gTrain.useTime];
    [self.useTimeLab sizeToFit];
    [self.staTimeLab setText:gTrain.staTime];
    [self.staTimeLab sizeToFit];
    [self.endTimeLab setText:gTrain.endTime];
    [self.endTimeLab sizeToFit];
    //商务座
    [self.swSeatLab setText:gTrain.swSeat];
    [self.swSeatLab sizeToFit];
    if ([gTrain.swSeat isEqualToString:@"--"]||[gTrain.swSeat isEqualToString:@"无"]) {
        [self.swSeatLab setTextColor:[UIColor grayColor]];
    }else
    {
        [self.swSeatLab setTextColor:[UIColor redColor]];
    }
    //一等
    [self.ydSeatLab setText:gTrain.ydSeat];
    [self.ydSeatLab sizeToFit];
    if ([gTrain.ydSeat isEqualToString:@"--"]||[gTrain.ydSeat isEqualToString:@"无"]) {
        [self.ydSeatLab setTextColor:[UIColor grayColor]];
    }
    else
    {
        [self.ydSeatLab setTextColor:[UIColor redColor]];
    }
    //二等
    [self.edSeatLab setText:gTrain.edSeat];
    [self.edSeatLab sizeToFit];
    if ([gTrain.edSeat isEqualToString:@"--"]||[gTrain.edSeat isEqualToString:@"无"]) {
        [self.edSeatLab setTextColor:[UIColor grayColor]];
    }
    else
    {
        [self.edSeatLab setTextColor:[UIColor redColor]];
    }
    //无座
    [self.wzSeatLab setText:gTrain.wzSeat];
    [self.wzSeatLab sizeToFit];
    if ([gTrain.wzSeat isEqualToString:@"--"]||[gTrain.wzSeat isEqualToString:@"无"]) {
        [self.wzSeatLab setTextColor:[UIColor grayColor]];
    }else
    {
        [self.wzSeatLab setTextColor:[UIColor redColor]];
    }
    
}

- (instancetype)init
{
    YXGCell *cell = [[NSBundle mainBundle] loadNibNamed:@"YXGCell" owner:nil options:nil].lastObject;
    cell.width = [UIScreen mainScreen].bounds.size.width;
    //取消选中状态
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
