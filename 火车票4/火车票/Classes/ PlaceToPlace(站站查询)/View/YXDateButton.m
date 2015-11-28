//
//  YXDateButton.m
//  火车票
//
//  Created by 刘雨轩 on 15/10/4.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//
#define imaHW 14

#import "YXDateButton.h"
#import "UIView+Frame.h"
@implementation YXDateButton
- (void)setHighlighted:(BOOL)highlighted
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, self.height * 0.5 - imaHW * 0.5, imaHW, imaHW);
    self.imageView.x = self.width - 35;
    self.titleLabel.x = self.imageView.x - self.titleLabel.width - imaHW * 0.5;
}


//给按钮标题赋值的时候调用
- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    [self.titleLabel sizeToFit];
}
@end
