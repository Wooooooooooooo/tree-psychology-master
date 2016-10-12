//
//  UIImage+CircleImage.m
//  Pan大夫
//
//  Created by 李昂 on 3/31/16.
//  Copyright © 2016 Neil. All rights reserved.
//

#import "UIImage+CircleImage.h"

@implementation UIImage (CircleImage)

+ (UIImage *)circleImage:(UIImage *)image withParam:(CGFloat)inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 圆的边框宽度为2，颜色为红色
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    // 在圆区域内画出image原图
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    // 生成新的image
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

@end
