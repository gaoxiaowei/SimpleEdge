//
//  UIColor+SEUtils.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (SEUtils)

+ (UIColor *)randomColorWithImage;
+ (UIColor *)colorWithString:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
