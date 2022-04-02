//
//  UIView+ScreenShot.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import <UIKit/UIKit.h>

@interface UIView (ScreenShot)
/**
 *
 *@param aspectRatio 比例 0~1,如果为0,截整个view
 *@param offset 偏移量
 *@param quality 截图质量 0~1
 */
- (UIImage *)screenShotAspectRatio:(CGFloat)aspectRatio
                            offset:(CGPoint)offset
                           quality:(CGFloat)quality;

@end

