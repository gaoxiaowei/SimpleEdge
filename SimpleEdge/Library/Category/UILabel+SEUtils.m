//
//  UILabel+SEUtils.m
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import "UILabel+SEUtils.h"

@implementation UILabel (SEUtils)

- (void)setAdjustsFontSizeMinfactor:(CGFloat)minfactor{
    [self setAdjustsFontSizeToFitWidth:YES];
    [self setMinimumScaleFactor:minfactor];
    [self setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
}

@end
