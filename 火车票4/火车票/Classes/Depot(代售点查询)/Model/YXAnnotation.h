//
//  YXAnnotation.h
//  MapView
//
//  Created by 刘雨轩 on 15/10/17.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface YXAnnotation : NSObject<MKAnnotation>
// 确定大头针扎在地图上哪个位置
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

// 大头针弹框的标题
@property (nonatomic, copy, nullable) NSString *title;
// 弹框的子标题
@property (nonatomic, copy, nullable) NSString *subtitle;
@end
