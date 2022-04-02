//
//  UIButton+SEUIUtils.h
//  SimpleEdge
//
//  Created by gaoxiaowei on 2022/3/28.
//  Copyright © 2022 gaoxiaowei. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (SEUIUtils)

+ (UIButton *)createButtonWithFrameByImage:(CGRect)frame
                               normalImage:(UIImage *)normalImage
                               selectImage:(UIImage *)selectImage
                              disableImage:(UIImage *)disableImage
                                    target:(id)target
                                    action:(SEL)action
                          forControlEvents:(UIControlEvents)controlEvents;

@end

NS_ASSUME_NONNULL_END
