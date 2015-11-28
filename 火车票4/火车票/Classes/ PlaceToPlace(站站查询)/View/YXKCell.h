//
//  YXKCell.h
//  火车票
//
//  Created by 刘雨轩 on 15/10/9.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YXKTrain;
@interface YXKCell : UITableViewCell

@property(nonatomic,strong)YXKTrain *kTrain;  /**< k次列车*/
@end
