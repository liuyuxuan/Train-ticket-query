//
//  YXPickerView.h
//  CityPickerView
//
//  Created by 刘雨轩 on 15/10/12.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//


#import <UIKit/UIKit.h>
@class YXPickerView;
@protocol YXPickerViewDelegate <NSObject>

- (void)pickerView:(YXPickerView *)pickerView SelcetProvince:(NSString *)province andCity:(NSString *)city andArea:(NSString *)area;

@end

@interface YXPickerView : UIView

@property(nonatomic,weak)id<YXPickerViewDelegate> delegate;  /**< 代理*/

@end
