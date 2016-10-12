//
//  UIImage+CircleImage.h
//  Pan大夫
//
//  Created by 李昂 on 3/31/16.
//  Copyright © 2016 Neil. All rights reserved.
//

#import <UIKit/UIKit.h>

// 第三方库
// http://blog.csdn.net/nogodoss/article/details/28601875

@interface UIImage (CircleImage)

+ (UIImage *)circleImage:(UIImage *)image withParam:(CGFloat)inset;

@end
