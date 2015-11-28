//
//  UIImage+YXImage.m
//  彩票
//
//  Created by 刘雨轩 on 15/9/23.
//  Copyright © 2015年 刘雨轩. All rights reserved.
//

#import "UIImage+YXImage.h"

@implementation UIImage (YXImage)

+ (UIImage *)imageWithOriginalImageNamed:(NSString *)imageNamed
{
    UIImage *image = [UIImage imageNamed:imageNamed];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

@end
