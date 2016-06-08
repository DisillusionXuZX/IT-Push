//
//  UIImage+Render.m
//  IT Express
//
//  Created by xuzx on 16/4/7.
//  Copyright © 2016年 xuzx. All rights reserved.
//

#import "UIImage+Render.h"

@implementation UIImage (Render)
+ (UIImage *)imageNameWithOriginal:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    
    // 返回一个没有渲染图片
    return  [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

// 生成一个圆角图片
- (UIImage *)circleImage
{
    // 裁剪图片: 图形上下文
    // 1.开启图形上下文
    // scale:比例因素 点:像素比例 0:自动识别比例因素
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    // 2.描述圆形裁剪路径
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    // 3.设置为裁剪区域
    [clipPath addClip];
    // 4.画图片
    [self drawAtPoint:CGPointZero];
    // 5.取出图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 6.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

@end
