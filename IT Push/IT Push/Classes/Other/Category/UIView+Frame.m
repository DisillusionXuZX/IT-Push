//
//  UIView+Frame.m
//  BuDeJie
//
//  Created by xuzx on 16/4/4.
//  Copyright © 2016年 xuzx. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)


- (CGFloat)XZX_Height{
    return self.frame.size.height;
}

- (void)setXZX_Height:(CGFloat)XZX_Height{
    CGRect rect = self.frame;
    rect.size.height = XZX_Height;
    self.frame = rect;
}

- (CGFloat)XZX_Width{
    return self.frame.size.width;
}

- (void)setXZX_Width:(CGFloat)XZX_Width{
    CGRect rect = self.frame;
    rect.size.width = XZX_Width;
    self.frame = rect;
}

- (CGFloat)XZX_X{
    return self.frame.origin.x;
}

- (void)setXZX_X:(CGFloat)XZX_X{
    CGRect rect = self.frame;
    rect.origin.x = XZX_X;
    self.frame = rect;
}

- (CGFloat)XZX_Y{
    return self.frame.origin.y;
}

- (void)setXZX_Y:(CGFloat)XZX_Y{
    CGRect rect = self.frame;
    rect.origin.y = XZX_Y;
    self.frame = rect;
}

- (void)setXZX_centerX:(CGFloat)XZX_centerX{
    CGPoint center = self.center;
    center.x = XZX_centerX;
    self.center = center;
}

- (CGFloat)XZX_centerX{
    return self.center.x;
}

- (void)setXZX_centerY:(CGFloat)XZX_centerY{
    CGPoint center = self.center;
    center.y = XZX_centerY;
    self.center = center;
}

- (CGFloat)XZX_centerY{
    return self.center.y;
}


@end
