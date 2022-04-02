//
//  UIView+ScreenShot.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import "UIView+ScreenShot.h"

@implementation UIView (ScreenShot)

- (UIImage *)screenShotAspectRatio:(CGFloat)aspectRatio
                            offset:(CGPoint)offset
                           quality:(CGFloat)quality {
    
    aspectRatio = aspectRatio ? aspectRatio : 0;
    quality = quality ? quality : 1;
    CGSize size = self.frame.size;
    
    if (aspectRatio > 0) {
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        
        CGFloat ratio = width / height;
        if (ratio > aspectRatio) {
            size.height = height;
            size.width = height * aspectRatio;
        } else {
            size.width = width;
            size.height = width / aspectRatio;
        }
    }
    UIImage *image = [self screenShotSize:size offset:offset quality:quality];
    return image;
}

- (UIImage *)screenShotSize:(CGSize)size
                     offset:(CGPoint)offset
                    quality:(CGFloat)quality {
    
    CGFloat scale = [[UIScreen mainScreen] scale] * quality;
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    CGRect rect = CGRectMake(offset.x, offset.y, w, h);
    [self drawViewHierarchyInRect:rect afterScreenUpdates:NO];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}

@end
