//
//  YXHistoryCell.m
//  火车票
//
//  Created by 刘雨轩 on 15/10/16.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#import "YXHistoryCell.h"

@interface YXHistoryCell()
@property (strong, nonatomic)UILabel *historyLab;

@end
@implementation YXHistoryCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor lightGrayColor];
        self.frame = CGRectMake(0, 0, 150, 25);
        label.frame = self.frame;
        [self.contentView addSubview:label];
        self.historyLab = label;
    }
    return self;
}


- (void)setTrainName:(NSString *)trainName
{
    _trainName = trainName;
    self.historyLab.text =trainName;
}

@end
