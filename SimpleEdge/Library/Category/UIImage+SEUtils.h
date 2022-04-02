//
//  UIImage+SEUtils.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SEUtils)

+ (UIImage *)qh_imageWithColor:(UIColor *)color;
+ (UIImage *)qh_imageWithColor:(UIColor *)color rect:(CGRect)rect;
/**
 绘制图片
 
 @param color 背景色
 @param size 大小
 @param text 文字
 @param textAttributes 字体设置
 @param isCircular 是否圆形
 @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color
                       size:(CGSize)size
                       text:(NSString *)text
             textAttributes:(NSDictionary *)textAttributes
                   circular:(BOOL)isCircular;

+ (UIImage *)createOtherMerchantImage:(NSString *)str
                          withBgImage:(UIImage *)image
                             withFont:(CGFloat)fontSize
                        withTextColor:(UIColor *)textColor;

+ (UIImage *)randomLogoImage;
@end

NS_ASSUME_NONNULL_END
