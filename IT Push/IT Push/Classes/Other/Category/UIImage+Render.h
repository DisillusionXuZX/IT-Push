//
//  UIImage+Render.h
//  IT Express
//
//  Created by xuzx on 16/4/7.
//  Copyright © 2016年 xuzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Render)
// 提供一个不要渲染图片方法
+ (UIImage *)imageNameWithOriginal:(NSString *)imageName;

// 生成圆角图片
- (UIImage *)circleImage;
@end
