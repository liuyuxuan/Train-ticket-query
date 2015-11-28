//
//  YXGCell.h
//  火车票
//
//  Created by 刘雨轩 on 15/10/10.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YXGTrain;
@interface YXGCell : UITableViewCell

@property(nonatomic,strong)YXGTrain *gTrain;  /**< G次列车*/
@end
