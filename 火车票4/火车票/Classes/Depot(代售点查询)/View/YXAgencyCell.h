//
//  YXAgencyCell.h
//  火车票
//
//  Created by 刘雨轩 on 15/10/13.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YXAgencyFrame;
@interface YXAgencyCell : UITableViewCell

@property(nonatomic,strong)YXAgencyFrame *agencyFrame;  /**< 对应的模型*/
@end
